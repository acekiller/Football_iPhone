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
#import "Match.h"


@implementation RealtimeIndexController
@synthesize matchOddsList;
@synthesize companyIdArray;
@synthesize oddsDate;
@synthesize matchType;
@synthesize oddsType;
@synthesize hideSectionSet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.matchType = 0;
        self.matchOddsList = [[NSMutableDictionary alloc] init ];
        self.companyIdArray = [[NSMutableArray alloc] init ];
        self.hideSectionSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [matchOddsList release];
    [hideSectionSet release];
    [companyIdArray release];
    [oddsDate release];
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
    [self filterOddsByLeague:selectedLeagueArray];
    
    
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

    [GlobalGetOddsService() startGetRealtimOddsTimer:self.oddsType delegate:self];
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
                   leagueIdArray:[[OddsManager defaultManager] leagueArray] 
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
    NSNumber *number = [NSNumber numberWithInt:section];
    if ([self.hideSectionSet containsObject:number]) {
        return 0;
    }
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
        [cell setCellInfo:self.oddsType];
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
	[cell setCellInfo:odds company:company];
	return cell;	
}


#pragma headerView action 
-(void)headerViewAction:(id)sender
{
    NSInteger section = [(UIButton *)sender tag];
    BOOL hideFlag = [self isSectionHide:section];
    if (hideFlag) {
        [self removeSectionFromHideSet:section];
    }else{
        [self addSectionToHideSet:section];
    }
    
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:section];
    [self.dataTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    [indexSet release];
    
    NSIndexPath *lastVisibleIndexpath = [[self.dataTableView indexPathsForVisibleRows] lastObject];
    if (section == lastVisibleIndexpath.section) {
        NSInteger index = [self tableView:self.dataTableView numberOfRowsInSection:section];
        if (index > 0) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:index - 1 inSection:section];
            [self.dataTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* matchId = [self.dataList objectAtIndex:section];
    RealtimeIndexHeaderView* header = [[[RealtimeIndexHeaderView alloc]initWithMatchId:matchId]autorelease];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:header.bounds];
    [button setTag:section];
    [button addTarget:self action:@selector(headerViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:button];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}



- (BOOL)isSectionHide:(NSInteger)section
{
    NSNumber *number = [NSNumber numberWithInt:section];
    return [self.hideSectionSet containsObject:number];
}
- (void)addSectionToHideSet:(NSInteger)section
{
    NSNumber *number = [NSNumber numberWithInt:section];
    [self.hideSectionSet addObject:number];
}
- (void)removeSectionFromHideSet:(NSInteger)section
{
    NSNumber *number = [NSNumber numberWithInt:section];
    [self.hideSectionSet removeObject:number];
}


#pragma remote request delegate
#pragma -

- (void)getOddsListFinish
{
    OddsManager* manager = [OddsManager defaultManager];
    [self.matchOddsList removeAllObjects];
    switch (oddsType) {
        case ODDS_TYPE_YAPEI: {
            for (Odds* odds in manager.yapeiArray) {
                [OddsManager addOdds:odds toDictionary:self.matchOddsList];
            }
        }
            break;
        case ODDS_TYPE_OUPEI: {
            for (Odds* odds in manager.oupeiArray) {
                [OddsManager addOdds:odds toDictionary:self.matchOddsList];
            }
        }
            break;
        case ODDS_TYPE_DAXIAO: {
            for (Odds* odds in manager.daxiaoArray) {
                [OddsManager addOdds:odds toDictionary:self.matchOddsList];
            }
        }
            break;
        default:
            break;
    }
    self.dataList = [matchOddsList allKeys];
    [self.hideSectionSet removeAllObjects];
    [self updateHeaderMatch];
    [self.dataTableView reloadData];
    
}

- (void)getRealtimeOddsFinish:(NSSet *)oddsSet oddsType:(ODDS_TYPE)oddsType
{
    if ([oddsSet count] != 0) {
        [self.dataTableView reloadData];    
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.oddsDate = [NSDate dateWithTimeIntervalSinceNow:-24*60*60*buttonIndex];
    [self updateAllOddsData];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark -
#pragma delegate

- (void) SelectCompanyFinish
{
    [self refleshOddsType];
    [self refleshCompanyIdArray];
    [self updateAllOddsData];
    [GlobalGetOddsService() startGetRealtimOddsTimer:self.oddsType delegate:self];
}

- (void)updateAllOddsData
{
    OddsService* service = GlobalGetOddsService();
    [service getOddsListByDate:oddsDate companyIdArray:companyIdArray language:[LanguageManager getLanguage] matchType:matchType oddsType:self.oddsType delegate:self];

}

- (void)refleshOddsType
{
    self.oddsType = [CompanyManager defaultCompanyManager].selectedOddsType;
}

- (void)refleshCompanyIdArray
{
    [self.companyIdArray removeAllObjects];
    NSArray* selectedCompanyArray = [[CompanyManager defaultCompanyManager].selectedCompany allObjects];
    for (Company* company in selectedCompanyArray) {
        [self.companyIdArray addObject:company.companyId];
    }
}


- (void)filterOddsByLeague:(NSSet*)filterLeagueIdSet
{
    [self.matchOddsList removeAllObjects];
    OddsManager* manager = [OddsManager defaultManager];
    [self.matchOddsList removeAllObjects];
    switch (oddsType) {
        case ODDS_TYPE_YAPEI: {
            for (Odds* odds in manager.yapeiArray) {
                if ([filterLeagueIdSet containsObject:[manager getLeagueIdByMatchId:odds.matchId]]) {
                    [OddsManager addOdds:odds toDictionary:self.matchOddsList];
                }
            }
        }
            break;
        case ODDS_TYPE_OUPEI: {
            for (Odds* odds in manager.oupeiArray) {
                if ([filterLeagueIdSet containsObject:[manager getLeagueIdByMatchId:odds.matchId]]) {
                    [OddsManager addOdds:odds toDictionary:self.matchOddsList];
                }
            }
        }
            break;
        case ODDS_TYPE_DAXIAO: {
            for (Odds* odds in manager.daxiaoArray) {
                if ([filterLeagueIdSet containsObject:[manager getLeagueIdByMatchId:odds.matchId]]) {
                    [OddsManager addOdds:odds toDictionary:self.matchOddsList];
                }
            }
        }
            break;
        default:
            break;
    }
    [self.hideSectionSet removeAllObjects];
    self.dataList = [matchOddsList allKeys];
    [self updateHeaderMatch];
    [self.dataTableView reloadData];
}

- (void)updateHeaderMatch
{
    self.dataList = [[self.matchOddsList allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Match* match1 = [[MatchManager defaultMatchIndexManger]getMathById:obj1];
        Match* match2 = [[MatchManager defaultMatchIndexManger]getMathById:obj2];
        return [match2.date compare:match1.date];
    }];
                
}

@end


#import "Match.h"
#import "TimeUtils.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

@implementation RealtimeIndexHeaderView

#define HEADER_HEIGHT 30
#define BUTTON_TAG 1223
- (id)initWithMatchId:(NSString *)matchId
{

    self = [super initWithFrame:CGRectMake(0, 0, 320, HEADER_HEIGHT)];
    Match *match = [[MatchManager defaultMatchIndexManger]getMathById:matchId];
    if (self && match) {
        NSString *leagueName = [[LeagueManager defaultIndexManager]getNameById:match.leagueId];
        NSString *dateString = dateToStringByFormat(match.date, @"MM/dd");
        NSString *teamString = [NSString stringWithFormat:@"%@ VS %@",match.homeTeamName,match.awayTeamName];
        NSString *leagueDate = [NSString stringWithFormat:@"   %@ %@",leagueName,dateString];
        NSString *title = [NSString stringWithFormat:@"%@   %@",leagueDate, teamString];
        OHAttributedLabel *aLabel = [[OHAttributedLabel alloc]initWithFrame:CGRectMake(0, 0, 320, 23.5)];
        NSMutableAttributedString *aString = [NSMutableAttributedString attributedStringWithString:title];

        NSRange range1 = [title rangeOfString:leagueDate];
        NSRange range2 = [title rangeOfString:teamString];
        
        [aString setFont:[UIFont systemFontOfSize:12.0] range:range1];
        [aString setFont:[UIFont systemFontOfSize:14.0] range:range2];
        [aString setTextColor:[UIColor whiteColor] range:range1];
        [aString setTextColor:[UIColor whiteColor] range:range2];
        
        aLabel.attributedText = aString;
        [self setCenter:aLabel.center];
        [self.layer setContents:(id)[UIImage imageNamed:@"odds_title_bg.jpg"].CGImage];
        [aLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:aLabel];
        [aLabel release];
    }
    return self;
}


@end
