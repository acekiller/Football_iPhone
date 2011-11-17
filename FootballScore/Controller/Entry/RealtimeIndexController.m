//
//  RealtimeIndexController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//


#import "SelectLeagueController.h"
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
#import "ColorManager.h"
#import "LeagueManager.h"
#import "MatchManager.h"
#import "LanguageManager.h"


@implementation RealtimeIndexController
@synthesize matchOddsList;
@synthesize companyIdArray;
@synthesize oddsDate;
@synthesize matchType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.matchType = 0;
        self.oddsDate = nil;
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







#pragma Select Leaguge Delegate

- (void)didSelectLeague:(NSSet *)selectedLeagueArray
{
    // filter data list by league data
    
    OddsManager* manager = [OddsManager defaultManager];
    [manager updateFilterLeague:selectedLeagueArray removeExist:YES];
    
    
    
    //  self.dataList = [manager filterMatch];
    //    [[self dataTableView] reloadData];
    
    
    
}
- (int)calculateHiddenMatchCount:(NSMutableSet*)selectLeagueIdArray
{
    return [[OddsManager defaultManager] getHiddenMatchCount:selectLeagueIdArray];
}


- (void)setLeftBarLogo
{
    UIView *leftTopBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    
    UIImageView *liveIndexLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"odds_logo.png"]];
    [leftTopBarView addSubview:liveIndexLogo];
    [liveIndexLogo release];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftTopBarView];
    [leftTopBarView release];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.title = @"";
    [leftBarButton release];
    
}



#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLeftBarLogo];
    [self setNavigationRightButton:FNS(nil) imageName:@"refresh.png" action:nil];
    
    OddsService* service = GlobalGetOddsService();
    NSArray* array = [NSArray arrayWithObjects:@"14",@"1",nil];
    
    [service getOddsListByDate:nil companyIdArray:array language:0 matchType:0 oddsType:3 delegate:self];
    
    [service startGetRealtimOddsTimer:3 delegate:self];
    
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
    [SelectIndexController show:self];
}


-(IBAction)clickSelectLeagueController:(id)sender{
    
    [SelectLeagueController show:self  
                   leagueIdArray:[[LeagueManager defaultIndexManager] leagueArray] 
              filterLeagueIdList:[[OddsManager defaultManager] filterLeagueIdList]];
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
    NSDate *beforeDate=[NSDate date];
    
    for (i = 0 ; i<7 ;i++)
    {
        interval = 24*60*60*i;
        beforeDate = [date dateByAddingTimeInterval:-interval];
        dateString = [df stringFromDate:beforeDate];
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
        [cell.contentView setBackgroundColor:[ColorManager scoreIndexCellBackgroundColor]];
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

- (void)getRealtimeOddsFinish:(NSSet *)oddsSet oddsType:(ODDS_TYPE)oddsType
{
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

#pragma mark -
#pragma delegate

- (void) SelectCompanyFinish
{
    [self refleshData];
}

- (void)refleshData
{
    int type = [[CompanyManager defaultCompanyManager] selectedOddsType];
    NSArray* selectedCompanyArray = [[CompanyManager defaultCompanyManager].selectedCompany allObjects];
    NSMutableArray* selectedCompanyIdArray = [[NSMutableArray alloc] init ];
    for (Company* company in selectedCompanyArray) {
        [selectedCompanyIdArray addObject:company.companyId];
    }
    
    OddsService* service = GlobalGetOddsService();
    [service getOddsListByDate:oddsDate companyIdArray:selectedCompanyIdArray language:[LanguageManager getLanguage] matchType:matchType oddsType:type delegate:self];
    OddsManager* manager = [OddsManager defaultManager];
//    self.matchOddsList  = [[NSMutableDictionary alloc] init];
    [self.matchOddsList removeAllObjects];
    switch (type) {
        case ODDS_TYPE_YAPEI: {
            for (Odds* odds in manager.yapeiArray) {
                [self.matchOddsList setObject:odds forKey:odds.matchId];
            }
        }
            break;
        case ODDS_TYPE_OUPEI: {
            for (Odds* odds in manager.oupeiArray) {
                [self.matchOddsList setObject:odds forKey:odds.matchId];
            }
        }
            break;
        case ODDS_TYPE_DAXIAO: {
            for (Odds* odds in manager.daxiaoArray) {
                [self.matchOddsList setObject:odds forKey:odds.matchId];
            }
        }
            break;
        default:
            break;
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
        OHAttributedLabel *aLabel = [[OHAttributedLabel alloc]initWithFrame:CGRectMake(0, 0, 320, 23.5)];
        NSMutableAttributedString *aString = [NSMutableAttributedString attributedStringWithString:title];

        NSRange range1 = [title rangeOfString:leagueDate];
        NSRange range2 = [title rangeOfString:teamString];
        
        [aString setFont:[UIFont systemFontOfSize:12.0] range:range1];
        [aString setFont:[UIFont systemFontOfSize:16.0] range:range2];
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
