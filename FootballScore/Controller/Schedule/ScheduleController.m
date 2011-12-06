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

@implementation ScheduleController
@synthesize selectedDateButton;
@synthesize dateLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dateLabel  = [[UILabel alloc] init];
        // Custom initialization
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
    [self.dateLabel setText:dateToString([NSDate dateWithTimeIntervalSinceNow:0])];
    [self.selectedDateButton setTitle:FNS(@"选择日期") forState:UIControlStateNormal];
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
    return 20.0f;	
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
    //[self.dateLabel setText:dateToString([MatchManager defaultMatchScheduleManager].serverDate)];
    [self.dataTableView reloadData];
}

+ (void)showScheduleWithSuperController:(UIViewController*)superViewController
{
    ScheduleController* vc = [[ScheduleController alloc] init];
    [superViewController.navigationController pushViewController:vc animated:YES];
    [GlobalGetScheduleService() getSchedule:vc date:nil];
    [vc showActivityWithText:FNS(@"loading")];
    [vc release];
}

+ (void)showFinishedMatchWithSuperController:(UIViewController*)superViewController
{
    ScheduleController* vc = [[ScheduleController alloc] init];
    [superViewController.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)clicksSelectDateButton:(id)sender
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    UIActionSheet *dateActionSheet = [[UIActionSheet alloc]initWithTitle:FNS(@"历史回查") 
                                                                delegate:self 
                                                       cancelButtonTitle:FNS(@"返回")
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:nil];
    
    int i;
    NSTimeInterval interval;
    NSString *dateString = nil;
    NSDate *beforeDate=[NSDate date];
    
    for (i = 0 ; i<7 ;i++)
    {
        interval = 24*60*60*i;
        beforeDate = [date dateByAddingTimeInterval:interval];
        dateString = [df stringFromDate:beforeDate];
        [dateActionSheet addButtonWithTitle: dateString];
    }
    
    [dateActionSheet showFromTabBar:self.tabBarController.tabBar];
    
    [dateActionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:24*60*60*buttonIndex];
    [GlobalGetScheduleService() getSchedule:self date:date];
    [self.dateLabel setText:dateToString(date)];
    [self showActivityWithText:FNS(@"loading")];
    [self.dataTableView reloadData];
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
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:TIME_ZONE_GMT]];

    
    if (nil !=[formatter stringFromDate:date]){
        dateString = [formatter stringFromDate:date];
    }
    
    [formatter release];
    return dateString;
    
}

- (NSString*)convertStatus:(NSNumber*)status
{
    switch ([status intValue]) {
        case MATCH_STATUS_FIRST_HALF:
        case MATCH_STATUS_SECOND_HALF:
            return FNS(@"进行中");
        case MATCH_STATUS_MIDDLE:
            return FNS(@"中");
        case MATCH_STATUS_FINISH:
            return FNS(@"完");
        case MATCH_STATUS_PAUSE:
            return FNS(@"中断");
        case MATCH_STATUS_TBD:
        case MATCH_STATUS_KILL:
        case MATCH_STATUS_POSTPONE:
        case MATCH_STATUS_CANCEL:
        case MATCH_STATUS_NOT_STARTED:
        default:
            return FNS(@"未开");
    }
}

enum {
    TAG_LEAGUE_NAME = 20111205,
    TAG_DATE_AND_STATUS,
    TAG_HOME_TEAM_NAME,
    TAG_SCORE_LABEL,
    TAG_AWAY_TEAM_NAME
};
- (void)initCell:(UITableViewCell*)cell
{
    UILabel* leagueName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    UILabel* dateAndStatus = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 55, 20)];
    UILabel* homeTeamName = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 85, 20)];
    UILabel* scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(195, 0, 40, 20)];
    UILabel* awayTeamName = [[UILabel alloc] initWithFrame:CGRectMake(235, 0, 85, 20)];
    [leagueName setFont:[UIFont systemFontOfSize:10]];
    [dateAndStatus setFont:[UIFont systemFontOfSize:10]];
    [homeTeamName setFont:[UIFont systemFontOfSize:10]];
    [scoreLabel setFont:[UIFont systemFontOfSize:10]];
    [awayTeamName setFont:[UIFont systemFontOfSize:10]];
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
    UILabel* scoreLabel = (UILabel*)[cell viewWithTag:TAG_SCORE_LABEL];
    UILabel* awayTeamName = (UILabel*)[cell viewWithTag:TAG_AWAY_TEAM_NAME];
    [leagueName setText:[[LeagueManager defaultLeagueScheduleManager] getNameById:match.leagueId ]];
    [homeTeamName setText:match.homeTeamName];
    [dateAndStatus setText:[NSString stringWithFormat:@"%@ %@", [self convertMatchStartTime:match.date], [self convertStatus:match.status]]];
    [scoreLabel setText:[NSString stringWithFormat:@"%d:%d(%d:%d)", [match.homeTeamScore intValue], [match.awayTeamScore intValue], [match.homeTeamFirstHalfScore intValue], [match.awayTeamFirstHalfScore intValue]]];
    [awayTeamName setText:match.awayTeamName];
}
@end
