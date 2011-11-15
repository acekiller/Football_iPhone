//
//  RealtimeIndexController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RealtimeIndexController.h"
#import "SelectIndexController.h"
#import "StatusView.h"
#import "ScoreIndexCell.h"
#import "ScoreIndexTitleCell.h"
#import "OddsManager.h"
#import "CompanyManager.h"
#import "Company.h"
#import "Odds.h"
#import "YaPei.h"
#import "LocaleConstants.h"

@implementation RealtimeIndexController
@synthesize matchOddsList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
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
    OddsService* service = [[OddsService alloc] init];
    NSArray* array = [NSArray arrayWithObjects:@"14",nil];
    [service getOddsListByDate:nil companyIdArray:array language:0 matchType:0 oddsType:1 delegate:self];
    
    OddsManager* manager = [OddsManager defaultManager];
    self.matchOddsList  = [[NSMutableDictionary alloc] init];
    for (Odds* odds in manager.yapeiArray) {
        [self.matchOddsList setObject:odds forKey:odds.matchId];
    }
    self.dataList = [matchOddsList allKeys];
    [self.dataTableView reloadData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)clickContentFilterButton:(id)sender
{
    SelectIndexController *vc = [[SelectIndexController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)clickSearcHistoryBackButton:(id)sender
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
    
    for (i = 0 ; i<7 ;i++)
    {
        interval = 24*60*60*i;
        date = [date initWithTimeIntervalSinceNow:-interval];
        dateString = [df stringFromDate:date];
        [dateActionSheet addButtonWithTitle: dateString];
    }
    
    
    [dateActionSheet showFromTabBar:self.tabBarController.tabBar];
    
    
    [dateActionSheet release];
}



#pragma table view delegate
#pragma -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [ScoreIndexTitleCell getCellHeight];    
    }
    return [ScoreIndexCell getCellHeight];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataList count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* key = [self.dataList objectAtIndex:section];
    NSArray* array = [self.matchOddsList valueForKey:key];
	return [array count] + 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        NSString *CellIdentifier = [ScoreIndexTitleCell getCellIdentifier];
        ScoreIndexTitleCell *cell = (ScoreIndexTitleCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [ScoreIndexTitleCell createCell:self];
        }
        return cell;
    }
    
    NSString *CellIdentifier = [ScoreIndexCell getCellIdentifier];
	ScoreIndexCell *cell = (ScoreIndexCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [ScoreIndexCell createCell:self];				
		cell.selectionStyle = UITableViewCellSelectionStyleNone;			        
	}		
    
    cell.indexPath = indexPath;
    NSString* key = [self.dataList objectAtIndex:[indexPath section]];
    NSArray* array = [self.matchOddsList objectForKey:key];
    Odds* odds = [array objectAtIndex:[indexPath row] - 1];
    Company* company = [[CompanyManager defaultCompanyManager] getCompanyById:odds.commpanyId];
	[cell setCellInfo:odds company:company oddsType:ODDS_TYPE_YAPEI];
	return cell;	
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* matchId = [self.dataList objectAtIndex:section];
    return [[[RealtimeIndexHeaderView alloc]initWithMatchId:matchId]autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma remote request delegate
#pragma -

- (void)getOddsListFinish
{
    OddsManager* manager = [OddsManager defaultManager];
    self.matchOddsList  = [[NSMutableDictionary alloc] init];
     for (Odds* odds in manager.yapeiArray) {
         [OddsManager addOdds:odds toDictionary:self.matchOddsList];
     }
    self.dataList = [matchOddsList allKeys];
    [self.dataTableView reloadData];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //next action
            break;
        case 1:
            //next action
            break;
        case 2:
            //next action
            break;
        case 3:
            //next action
            break;
        case 4:
            //next action
            break;
        case 5:
            //next action
            break;
        case 6:
            //next action
            break;
        default:
            break;
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}


@end


#import "MatchManager.h"
#import "Match.h"
#import "TimeUtils.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

@implementation RealtimeIndexHeaderView

#define HEADER_HEIGHT 33.5
- (id)initWithMatchId:(NSString *)matchId
{

    self = [super initWithFrame:CGRectMake(0, 0, 320, HEADER_HEIGHT)];
    Match *match = [[MatchManager defaultManager]getMathById:matchId];
    if (self && match) {
        NSString *leagueName = [[MatchManager defaultManager] getLeagueNameByMatch:match];
        NSString *dateString = dateToStringByFormat(match.date, @"MM/dd");
        NSString *teamString = [NSString stringWithFormat:@"%@ VS %@",match.homeTeamName,match.awayTeamName];
        NSString *leagueDate = [NSString stringWithFormat:@"   %@ %@",leagueName,dateString];
        NSString *title = [NSString stringWithFormat:@"%@   %@",leagueDate, teamString];
        OHAttributedLabel *aLabel = [[OHAttributedLabel alloc]initWithFrame:CGRectMake(0, 10, 320, 23.5)];
        NSMutableAttributedString *aString = [NSMutableAttributedString attributedStringWithString:title];

        NSRange range1 = [title rangeOfString:leagueDate];
        NSRange range2 = [title rangeOfString:teamString];
        
        [aString setFont:[UIFont systemFontOfSize:14.0] range:range1];
        [aString setFont:[UIFont systemFontOfSize:19.0] range:range2];
        [aString setTextColor:[UIColor grayColor] range:range1];
        [aString setTextColor:[UIColor blackColor] range:range2];
        
        aLabel.attributedText = aString;

        [self.layer setContents:(id)[UIImage imageNamed:@"odds_se_bg.png"].CGImage];
        
        [aLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:aLabel];

        [aLabel release];
    }
    return self;
}

@end
