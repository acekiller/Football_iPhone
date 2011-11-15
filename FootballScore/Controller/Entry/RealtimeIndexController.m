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
#import "OddsManager.h"
#import "CompanyManager.h"
#import "Company.h"
#import "Odds.h"
#import "YaPei.h"

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
    NSArray* array = [NSArray arrayWithObjects:@"1",nil];
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



#pragma table view delegate
#pragma -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [ScoreIndexCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataList count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* key = [self.dataList objectAtIndex:section];
    NSArray* array = [self.matchOddsList valueForKey:key];
	return [array count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [ScoreIndexCell getCellIdentifier];
	ScoreIndexCell *cell = (ScoreIndexCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [ScoreIndexCell createCell:self];				
		cell.selectionStyle = UITableViewCellSelectionStyleNone;			        
	}		
    
    cell.indexPath = indexPath;
    
//    Match* match = [self.dataList objectAtIndex:indexPath.row];
//    [cell setCellInfo:match];
    //NSString* str = [self.dataList objectAtIndex:indexPath.row];
    //[cell.matchName setText:str];
    NSString* key = [self.dataList objectAtIndex:[indexPath section]];
    NSArray* array = [self.matchOddsList objectForKey:key];
    Odds* odds = [array objectAtIndex:[indexPath row]];
    Company* company = [[CompanyManager defaultCompanyManager] getCompanyById:odds.commpanyId];
	[cell setCellInfo:odds company:company oddsType:ODDS_TYPE_YAPEI];
	return cell;	
}

//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString* matchId = [self.dataList objectAtIndex:section];
//    NSString* title = [[OddsManager defaultManager] getMatchTitleByMatchId:matchId];
//    if (title != nil) {
//        return title;
//    }
//    return matchId;
//}

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
