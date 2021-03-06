//
//  ScheduleController.m
//  FootballScore
//
//  Created by Orange on 11-12-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ScheduleController.h"
#import "LocaleConstants.h"
#import "MatchManager.h"
#import "Match.h"
#import "LeagueManager.h"
#import "TimeUtils.h"
#import "ColorManager.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

#define COMPLETE_SCORE  120111217
#define WEEKLY_SCHEDULE 220111217
#define FORWARD_DAY   1
#define BACKWARD_DAY -1

@implementation ScheduleController
@synthesize selectedDateButton;
@synthesize dateLabel;
@synthesize scheduleType = _scheduleType;
@synthesize dayDirection = _dayDirection;
@synthesize initDate = _initDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dateLabel  = [[UILabel alloc] init];
        // Custom initialization
    }
    return self;
}

- (id)initWithType:(int)scheduleType initDate:(NSDate*)initDate title:(NSString*)title dayDirection:(int)dayDirection
{
    self = [super init];
    if (self) {
        [self setTitle:title];
        self.scheduleType = scheduleType;
        self.initDate = initDate;
        self.dayDirection = dayDirection;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.dataTableView setBackgroundColor:[ColorManager indexTableViewBackgroundColor]];
    [self setNavigationLeftButton:FNS(@"返回") imageName:@"ss.png" action:@selector(clickBack:)];
    [self.dateLabel setText:[NSString stringWithFormat:@"%@ %@", dateToString(self.initDate), chineseWeekDayFromDate(self.initDate)]];
    [self.selectedDateButton setTitle:FNS(@" 选择日期") forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setDateLabel:nil];
    [self setSelectedDateButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - PPTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;	
}	

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:@"ScheduleController"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ScheduleController"] autorelease];
        [self initCell:cell];
    }
    Match* match = [self.dataList objectAtIndex:[indexPath row]];
    [self setCell:cell withMatch:match];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([indexPath row]%2 != 0) {
        [cell.contentView setBackgroundColor:[ColorManager scoreIndexTitleCellBackgroundColor]];
    } else {
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return NO; 
}

#pragma mark - ScheduleDelegate
- (void)getMatchScheduleFinish
{
    [self hideActivity];
    self.dataList = [[MatchManager defaultMatchScheduleManager] matchArray];
    [self.dataTableView reloadData];
}

+ (void)showScheduleWithSuperController:(UIViewController*)superViewController
{
    NSDate* today = [NSDate dateWithTimeIntervalSinceNow:0];
    ScheduleController* vc = [[ScheduleController alloc] initWithType:WEEKLY_SCHEDULE initDate:today title:FNS(@"一周赛程") dayDirection:FORWARD_DAY];
    [superViewController.navigationController pushViewController:vc animated:YES];
    [GlobalGetScheduleService() getSchedule:vc date:nil];
    [vc showActivityWithText:FNS(@"loading")];
    [vc release];
}

+ (void)showFinishedMatchWithSuperController:(UIViewController*)superViewController
{
    NSDate* yesterday = [NSDate dateWithTimeIntervalSinceNow:-24*60*60];
    ScheduleController* vc = [[ScheduleController alloc] initWithType:COMPLETE_SCORE initDate:yesterday title:FNS(@"完场比分") dayDirection:BACKWARD_DAY];
    [superViewController.navigationController pushViewController:vc animated:YES];
    [GlobalGetScheduleService() getSchedule:vc date:yesterday];
    [vc showActivityWithText:FNS(@"loading")];
    [vc release];
}

#define WEEK_DAY_COUNT 7
- (IBAction)clicksSelectDateButton:(id)sender
{
    
    UIActionSheet *dateActionSheet = [[UIActionSheet alloc]initWithTitle:FNS(@"选择日期")
                                                                delegate:self 
                                                       cancelButtonTitle:nil
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:nil];
    
    NSTimeInterval oneDayInterval= 24*60*60;
          for (int i=0; i<WEEK_DAY_COUNT; i++) {
            NSDate* date = [NSDate dateWithTimeInterval:i*oneDayInterval*self.dayDirection sinceDate:self.initDate];
            NSString* title = dateToString(date);
            [dateActionSheet addButtonWithTitle:title];
          }

    [dateActionSheet addButtonWithTitle:FNS(@"返回")];
    [dateActionSheet setCancelButtonIndex:WEEK_DAY_COUNT];
    
    [dateActionSheet showFromTabBar:self.tabBarController.tabBar];
    
    [dateActionSheet release];
}

- (void)trueSelectDate:(NSDate*)date
{
    [GlobalGetScheduleService() getSchedule:self date:date];
    [self.dateLabel setText:[NSString stringWithFormat:@"%@ %@", dateToString(date), chineseWeekDayFromDate(date)]];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDate* date;
    NSTimeInterval oneDayInterval= 24*60*60;
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    date = [NSDate dateWithTimeInterval:self.dayDirection*buttonIndex*oneDayInterval sinceDate:self.initDate];
    [self performSelector:@selector(trueSelectDate:) withObject:date afterDelay:0.5];
    [self showActivityWithText:FNS(@"加载中...")];
}

- (void)dealloc {
    [dateLabel release];
    [selectedDateButton release];
    [super dealloc];
}

- (NSString*)convertMatchStartTime:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSString *dateString = [[[NSString alloc] init] autorelease];
    
    if (self.scheduleType == WEEKLY_SCHEDULE) {
        [formatter setDateFormat:@"dd日HH:mm"];
    }
    else{
        [formatter setDateFormat:@"dd日"];
    }
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:TIME_ZONE_GMT]];

    
    if (nil !=[formatter stringFromDate:date]){
        dateString = [formatter stringFromDate:date];
    }
    
    [formatter release];
    return dateString;
    
}

//- (NSString*)convertStatus:(Match*)match
//{
//    switch ([match.status intValue]) {
//        case MATCH_STATUS_FIRST_HALF:
//        case MATCH_STATUS_SECOND_HALF:
//        case MATCH_STATUS_FINISH:
//            return [NSString stringWithFormat:@"%d:%d(%d:%d)", [match.homeTeamScore intValue], [match.awayTeamScore intValue], [match.homeTeamFirstHalfScore intValue], [match.awayTeamFirstHalfScore intValue]];
//        case MATCH_STATUS_MIDDLE:
//            return FNS(@"中场");
//        case MATCH_STATUS_PAUSE:
//            return FNS(@"中断");
//        case MATCH_STATUS_TBD:
//            return FNS(@"待定");
//        case MATCH_STATUS_KILL:
//            return FNS(@"腰斩");
//        case MATCH_STATUS_POSTPONE:
//            return FNS(@"推迟");
//        case MATCH_STATUS_CANCEL:
//            return FNS(@"取消");
//        case MATCH_STATUS_NOT_STARTED:
//        default:
//            return FNS(@"未");
//    }
//}

enum {
    TAG_LEAGUE_NAME = 20111205,
    TAG_DATE_AND_STATUS,
    TAG_HOME_TEAM_NAME,
    TAG_SCORE_LABEL,
    TAG_AWAY_TEAM_NAME
};
- (void)initCell:(UITableViewCell*)cell
{
    UILabel* leagueName = nil;
    UILabel* dateAndStatus = nil;
    UILabel* homeTeamName = nil;
    OHAttributedLabel* scoreLabel = nil;
    UILabel* awayTeamName = nil;
    
    if (self.scheduleType == WEEKLY_SCHEDULE) {
        leagueName = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 60, 30)];
        dateAndStatus = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 52, 30)];
        homeTeamName = [[UILabel alloc] initWithFrame:CGRectMake(117, 0, 80, 30)];
        scoreLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(197, 8, 43, 30)];
        awayTeamName = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 80, 30)];
    }
    else
    {
        leagueName = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 60, 30)];
        dateAndStatus = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 25, 30)];
        homeTeamName = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 90, 30)];
        scoreLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(180, 8, 50, 30)];
        awayTeamName = [[UILabel alloc] initWithFrame:CGRectMake(230, 0, 90, 30)];
    }
    
    [leagueName setFont:[UIFont systemFontOfSize:12]];
    [dateAndStatus setFont:[UIFont systemFontOfSize:11]];
    [homeTeamName setFont:[UIFont systemFontOfSize:12]];
    [scoreLabel setFont:[UIFont systemFontOfSize:11]];
    [awayTeamName setFont:[UIFont systemFontOfSize:12]];
    [leagueName setBackgroundColor:[UIColor clearColor]];
    [dateAndStatus setBackgroundColor:[UIColor clearColor]];
    [homeTeamName setBackgroundColor:[UIColor clearColor]];
    [scoreLabel setBackgroundColor:[UIColor clearColor]];
    [awayTeamName setBackgroundColor:[UIColor clearColor]];
    [leagueName setTag:TAG_LEAGUE_NAME];
    [dateAndStatus setTag:TAG_DATE_AND_STATUS];
    [homeTeamName setTag:TAG_HOME_TEAM_NAME];
    [scoreLabel setTag:TAG_SCORE_LABEL];
    [awayTeamName setTag:TAG_AWAY_TEAM_NAME];
    [scoreLabel setTextAlignment:UITextAlignmentCenter];
    [homeTeamName setTextAlignment:UITextAlignmentRight];
    [cell addSubview:leagueName];
    [cell addSubview:dateAndStatus];
    [cell addSubview:homeTeamName];
    [cell addSubview:scoreLabel];
    [cell addSubview:awayTeamName];
    [leagueName release];
    [dateAndStatus release];
    [homeTeamName release];
    [scoreLabel release];
    [awayTeamName release];
}

- (void)setCell:(UITableViewCell*)cell withMatch:(Match*)match
{
    UILabel* leagueName = (UILabel*)[cell viewWithTag:TAG_LEAGUE_NAME];
    UILabel* dateAndStatus = (UILabel*)[cell viewWithTag:TAG_DATE_AND_STATUS];
    UILabel* homeTeamName = (UILabel*)[cell viewWithTag:TAG_HOME_TEAM_NAME];
    OHAttributedLabel* scoreLabel = (OHAttributedLabel*)[cell viewWithTag:TAG_SCORE_LABEL];
    UILabel* awayTeamName = (UILabel*)[cell viewWithTag:TAG_AWAY_TEAM_NAME];
    [leagueName setText:[[LeagueManager defaultLeagueScheduleManager] getNameById:match.leagueId ]];
    [homeTeamName setText:match.homeTeamName];
    [dateAndStatus setText:[NSString stringWithFormat:@"%@", [self convertMatchStartTime:match.date]]];
    [awayTeamName setText:match.awayTeamName];
    
    
    [dateAndStatus setTextColor:[UIColor grayColor]];
    [homeTeamName setTextColor:[ColorManager soundsAlertColor]];
    [awayTeamName setTextColor:[ColorManager soundsAlertColor]];
    
    //set scoreLabel
    switch ([match.status intValue]) {
        case MATCH_STATUS_FIRST_HALF:
        case MATCH_STATUS_SECOND_HALF:
        case MATCH_STATUS_MIDDLE:
        case MATCH_STATUS_OVERTIME:
        case MATCH_STATUS_FINISH:
        {
            NSString *homeScoreAndAwayScore = [NSString stringWithFormat:@"%d:%d",[match.homeTeamScore intValue],[match.awayTeamScore intValue]];
            
            NSString *homeHalfScoreAndAwayHalfScore = [NSString stringWithFormat:@"(%d:%d)",[match.homeTeamFirstHalfScore intValue],[match.awayTeamFirstHalfScore intValue]];
            
            NSString *scoreString = [NSString stringWithFormat:@"%@%@",homeScoreAndAwayScore,homeHalfScoreAndAwayHalfScore];
            
            NSMutableAttributedString *scoreAttributedString = [NSMutableAttributedString attributedStringWithString:scoreString];
            
            NSRange range1 = [scoreString rangeOfString:homeScoreAndAwayScore];
            NSRange range2 = [scoreString rangeOfString:homeHalfScoreAndAwayHalfScore]; 
            [scoreAttributedString setTextColor:[UIColor redColor] range:range1];
            [scoreAttributedString setTextColor:[ColorManager soundsAlertColor] range:range2];
            
            scoreLabel.attributedText = scoreAttributedString;
            scoreLabel.textAlignment = UITextAlignmentCenter;
            
            break;
        }
        case MATCH_STATUS_PAUSE:
        {
            scoreLabel.text = FNS(@"中断");
            [scoreLabel setTextColor:[UIColor blueColor]];
            break;
        }
        case MATCH_STATUS_TBD: {
            scoreLabel.text = FNS(@"待定");
            [scoreLabel setTextColor:[UIColor redColor]];
        }
            break;
        case MATCH_STATUS_KILL: {
            scoreLabel.text = FNS(@"腰斩");
            [scoreLabel setTextColor:[UIColor redColor]];
        }
            break;
        case MATCH_STATUS_POSTPONE: {
            scoreLabel.text = FNS(@"推迟");
            [scoreLabel setTextColor:[UIColor redColor]];
        }
            break;
        case MATCH_STATUS_CANCEL: {
            scoreLabel.text = FNS(@"取消");
            [scoreLabel setTextColor:[UIColor redColor]];
        }
            break;
        case MATCH_STATUS_NOT_STARTED:
        default:
        {
            scoreLabel.text = FNS(@"未");
            [scoreLabel setTextColor:[UIColor blueColor]];
            break;
        }
    }
    
    
    
}
@end
