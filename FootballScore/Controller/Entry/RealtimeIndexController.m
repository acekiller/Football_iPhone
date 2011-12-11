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

#define SECOND_LEVEL_LEAGUE 0

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
        self.matchType = SECOND_LEVEL_LEAGUE;
        self.oddsType = ODDS_TYPE_YAPEI;
        matchOddsList = [[NSMutableDictionary alloc] init ];
        companyIdArray = [[NSMutableArray alloc] initWithObjects:@"1", @"8", @"3", @"4", nil ];
        //four company id:1---澳彩    3---SB   4----立博   8----bet365
        hideSectionSet = [[NSMutableSet alloc] init];
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
    
    UIImageView *liveLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"odds_logo.png"]];
    [leftTopBarView addSubview:liveLogo];
    [liveLogo release];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftTopBarView];
    [leftTopBarView release];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.title = @"";
    [leftBarButton release];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    supportRefreshHeader = YES;
    [super viewDidLoad];
    [self setRefreshHeaderViewFrame:CGRectMake(0, 0 - self.dataTableView.bounds.size.height, 320, self.dataTableView.bounds.size.height)];
    [self setLeftBarLogo];
    [self setRightBarButtons];
    [self.dataTableView setBackgroundColor:[ColorManager indexTableViewBackgroundColor]];
    CompanyManager* manager = [CompanyManager defaultCompanyManager];
    [manager setSelectedOddsType:ODDS_TYPE_YAPEI];
    for (NSString* str in companyIdArray) {
        [manager selectCompanyById:str];
    }
    [self updateAllOddsData];
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

#pragma Pull Refresh Delegate
- (void) reloadTableViewDataSource
{
    if (self.oddsType < 1 || self.oddsType > 3) {
        return;
    }
    [self updateAllOddsData];
}


#pragma setRightBarButtons and selector
- (void)setRightBarButtons
{
    float buttonHigh = 27.5;
    float buttonLen = 47.5;
    float seporator = 10;
    float leftOffest = 20;
    UIFont *font = [UIFont systemFontOfSize:14];
    
    UIView *rightButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, leftOffest+3*(buttonLen+seporator)-4, buttonHigh)]; 
    
    
    UIButton *selectContentButton = [[UIButton alloc]initWithFrame:CGRectMake(leftOffest, 0, buttonLen, buttonHigh)];
    [selectContentButton setBackgroundImage:[UIImage imageNamed:@"ss.png"] forState:UIControlStateNormal];
    [selectContentButton setTitle:FNS(@"内容") forState:UIControlStateNormal];
    [selectContentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectContentButton.titleLabel setFont:font];
    [selectContentButton addTarget:self action:@selector(clickSelectContentButton) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:selectContentButton]; 
    [selectContentButton release];
    
    
    UIButton *selectLeagueButton = [[UIButton alloc]initWithFrame:CGRectMake(leftOffest+buttonLen+seporator, 0, buttonLen, buttonHigh)];
    [selectLeagueButton setBackgroundImage:[UIImage imageNamed:@"ss.png"] forState:UIControlStateNormal];
    [selectLeagueButton setTitle:FNS(@"赛事") forState:UIControlStateNormal];
    [selectLeagueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectLeagueButton.titleLabel setFont:font];
    [selectLeagueButton addTarget:self action:@selector(clickSelectLeagueButton) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:selectLeagueButton]; 
    [selectLeagueButton release];
    
    UIButton *searcHistoryButton = [[UIButton alloc]initWithFrame:CGRectMake(leftOffest+(buttonLen+seporator)*2, 0, buttonLen, buttonHigh)];
    [searcHistoryButton setBackgroundImage:[UIImage imageNamed:@"ss.png"] forState:UIControlStateNormal];
    [searcHistoryButton setTitle:FNS(@"回查") forState:UIControlStateNormal];
    [searcHistoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searcHistoryButton.titleLabel setFont:font];
    [searcHistoryButton addTarget:self action:@selector(clickSearcHistoryButton) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:searcHistoryButton]; 
    [searcHistoryButton release];
    
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    [rightButtonView release];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
}

- (void)clickSelectContentButton
{
    [SelectIndexController show:self];
}

- (void)clickSelectLeagueButton
{
    [SelectLeagueController show:self  
                   leagueIdArray:[[OddsManager defaultManager] leagueArray] 
              filterLeagueIdList:[[OddsManager defaultManager] filterLeagueIdList]];
}

- (void)clickSearcHistoryButton
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
    [dateActionSheet setCancelButtonIndex:-1];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [RealtimeIndexHeaderView getHeight];
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
    if ([self isSectionHide:section]) {
        [header setBackgroundImage:[UIImage imageNamed:@"odds_down.png"]];
    }else{
        [header setBackgroundImage:[UIImage imageNamed:@"odds_up.png"]];
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return NO; 
}

#pragma mark -


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

- (void)getOddsListFinish:(int)reslutCode
{
    [self hideActivity];
    [self dataSourceDidFinishLoadingNewData];
    OddsManager* manager = [OddsManager defaultManager];
    [manager selectAllLeague];
    self.matchOddsList = [manager filterOddsByOddsType:self.oddsType date:self.oddsDate];
    self.dataList = [matchOddsList allKeys];
    [self.hideSectionSet removeAllObjects];
    [self updateHeaderMatch];
    [self.dataTableView reloadData];
    
    
}

- (void)getRealtimeOddsFinish:(NSSet *)oddsSet oddsType:(ODDS_TYPE)oddsType
{
    [self hideActivity];
    if ([oddsSet count] != 0) {
        [self.dataTableView reloadData];    
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    self.oddsDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60-24*60*60*buttonIndex];
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
    [self showActivityWithText:FNS(@"加载中...")];

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
    self.matchOddsList = [[OddsManager defaultManager] filterOddsByOddsType:self.oddsType date:self.oddsDate];
    [self.hideSectionSet removeAllObjects];
    self.dataList = [matchOddsList allKeys];
    [self updateHeaderMatch];
    if (self.dataList == nil || [self.dataList count] == 0) {
        [self showTipsOnTableView:FNS(@"没有符合条件的指数")];
    } else {
        [self hideTipsOnTableView];
    }
    [self.dataTableView reloadData];
}

- (void)updateHeaderMatch
{
    self.dataList = [[self.matchOddsList allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Match* match1 = [[MatchManager defaultMatchIndexManger]getMathById:obj1];
        Match* match2 = [[MatchManager defaultMatchIndexManger]getMathById:obj2];
        return [match1.date compare:match2.date];
    }];
                
}

@end


#import "Match.h"
#import "TimeUtils.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

@implementation RealtimeIndexHeaderView

#define HEADER_HEIGHT 33.0
#define BUTTON_TAG 1223
- (id)initWithMatchId:(NSString *)matchId
{

    self = [super initWithFrame:CGRectMake(0, 0, 320, HEADER_HEIGHT)];
    Match *match = [[MatchManager defaultMatchIndexManger]getMathById:matchId];
    if (self && match) {
        NSString *leagueName = [[LeagueManager defaultIndexManager]getNameById:match.leagueId];
        NSString *dateString = dateToStringByFormat(match.date, @"MM/dd");
        
        NSString *teamString=nil;
        
        if ([match.status intValue] == MATCH_STATUS_FINISH) 
        {
            teamString = [NSString stringWithFormat:@"%@ %@:%@ %@",match.homeTeamName,match.homeTeamScore,match.awayTeamScore,match.awayTeamName];
        }
        else
        {
            teamString = [NSString stringWithFormat:@"%@ VS %@",match.homeTeamName,match.awayTeamName];
        }

        NSString *leagueDate = [NSString stringWithFormat:@"%@ %@",leagueName,dateString];
        NSString *title = [NSString stringWithFormat:@"%@   %@",leagueDate, teamString];
        CGFloat x = 25.0;
        OHAttributedLabel *aLabel = [[OHAttributedLabel alloc]initWithFrame:CGRectMake(x, 6, 320 - x, HEADER_HEIGHT)];
        NSMutableAttributedString *aString = [NSMutableAttributedString attributedStringWithString:title];

        NSRange range1 = [title rangeOfString:leagueDate];
        NSRange range2 = [title rangeOfString:teamString];
        
        [aString setFont:[UIFont systemFontOfSize:13.0] range:range1];
        [aString setFont:[UIFont systemFontOfSize:15.0] range:range2];
        [aString setTextColor:[UIColor whiteColor] range:range1];
        [aString setTextColor:[UIColor whiteColor] range:range2];
        
        aLabel.attributedText = aString;
        aLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
        [self.layer setContents:(id)[UIImage imageNamed:@"odds_up.png"].CGImage];
        [aLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:aLabel];
        [aLabel release];
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)image
{
    [self.layer setContents:(id)image.CGImage];
}

+ (CGFloat)getHeight
{
    return HEADER_HEIGHT;
}
@end
