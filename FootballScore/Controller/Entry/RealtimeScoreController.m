//
//  RealtimeScoreController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RealtimeScoreController.h"
#import "RealtimeScoreCell.h"
#import "MatchService.h"
#import "MatchManager.h"
#import "Match.h"
#import "LocaleConstants.h"
#import "MatchConstants.h"
#import "SelectLeagueController.h"
#import "UITableViewCellUtil.h"
#import "LeagueManager.h"
#import "ShowAlertTextViewController.h"
#import "UserManager.h"
#import "ColorManager.h"
#import "PPNetworkRequest.h"
#import "RecommendedAppsControllerViewController.h"
#import "RecommendAppManager.h"
#import "FootballScoreAppDelegate.h"

@implementation RealtimeScoreController
@synthesize myFollowButton;
@synthesize myFollowCountView;
@synthesize scoreTypeButton;
@synthesize matchSecondTimer;
@synthesize matchDetailController;
@synthesize filterBarButton;
@synthesize matchScoreType = _matchScoreType;
@synthesize recommendAppCountView = _recommendAppCountView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.matchScoreType = MATCH_SCORE_TYPE_FIRST;
    }
    return self;
}

- (void)dealloc
{
    [scoreTypeButton release];
    [matchDetailController release];
    [matchSecondTimer release];
    [myFollowButton release];
    [myFollowCountView release];
    [_recommendAppCountView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    self.matchDetailController = nil;
}

#pragma mark - View lifecycle

- (NSInteger ) toMatchScoreTypeFromSheetIndex:(NSInteger)sheetIndex
{
    switch (sheetIndex) {
        case MATCH_SCORE_TYPE_ALL:
            return MATCH_SCORE_TYPE_FIRST;
        case MATCH_SCORE_TYPE_FIRST:
            return MATCH_SCORE_TYPE_ALL;
        default:
            return sheetIndex;
    }
}

- (void)updateSelectMatchStatusButtonState:(int)selectMatchStatus
{
    for (int i=MATCH_SELECT_STATUS_ALL; i<=MATCH_SELECT_STATUS_MYFOLLOW; i++){
        UIButton* button = (UIButton*)[self.view viewWithTag:i];
        if (i == selectMatchStatus) {
            [button setSelected:YES];  
            [button setBackgroundImage:[UIImage imageNamed:@"live_menu_2_on"] forState:UIControlStateNormal];     
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
        }
        else{
            [button setSelected:NO];
            [button setBackgroundImage:[UIImage imageNamed:@"live_menu_2"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
        }   
        
    }

}




- (void)loadMatch:(int)scoreType
{
    [[MatchManager defaultManager] setIsSelectAll:NO];
    [self showActivityWithText:FNS(@"加载数据中...")];
    [GlobalGetMatchService() getRealtimeMatch:self matchScoreType:scoreType];
}

- (void)loadMatch:(int)scoreType isSelectAll:(BOOL)isSelectAll
{
    [[MatchManager defaultManager] setIsSelectAll:isSelectAll];
    [self showActivityWithText:FNS(@"加载数据中...")];
    [GlobalGetMatchService() getRealtimeMatch:self matchScoreType:scoreType];
}

- (void)performPanGesture:(UIPanGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        UIButton *button = nil;
        CGPoint point = [recognizer translationInView:dataTableView];
        //from right to left
        if (point.x < 0) {
            if(matchSelectStatus == MATCH_SELECT_STATUS_ALL)
                return;
            button = (UIButton *)[self.view viewWithTag:matchSelectStatus - 1];
        }else{
            if (matchSelectStatus == MATCH_SELECT_STATUS_MYFOLLOW) 
                return;
            button = (UIButton *)[self.view viewWithTag:matchSelectStatus + 1];
            if (matchSelectStatus == MATCH_SELECT_STATUS_FINISH) {
                [self clickMyFollow:button];
            }
        }
        [self clickSelectMatchStatus:button];
    }
}

- (void)viewDidLoad
{
    self.supportRefreshHeader = YES;

    [super viewDidLoad];
    int UPDATE_TIME_INTERVAL = 1;
    hasClickedRefresh = NO;
    self.matchSecondTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIME_INTERVAL
                                                             target:self 
                                                           selector:@selector(updateMatchTimeDisplay) 
                                                           userInfo:nil 
                                                            repeats:YES];
    
    [self updateSelectMatchStatusButtonState:MATCH_SELECT_STATUS_ALL];
    [self setRightBarButtons];
    [self setLeftBarButtons];
    [self myFollowCountBadgeViewInit];
    
    
    
    self.view.backgroundColor = [ColorManager realTimeScoreControllerTableViewBackgroundColor];
    [self.tipsLabel setTextColor:[ColorManager leageNameColor]];
    
    [self setRefreshHeaderViewFrame:CGRectMake(0, 0-self.dataTableView.bounds.size.height, 320, self.dataTableView.bounds.size.height)];
    
    self.matchScoreType = [[MatchManager defaultManager] filterMatchScoreType];
    [self resetScoreButtonTitle];
    
    [self loadMatch:self.matchScoreType isSelectAll:YES];
    matchSelectStatus = MATCH_SELECT_STATUS_ALL;
    
    [RecommendAppService defaultService].delegate = self;
    [[RecommendAppService defaultService] getRecommendApp];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(performPanGesture:)];
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self setMyFollowButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma table view delegate
#pragma -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [RealtimeScoreCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [RealtimeScoreCell getCellIdentifier];
	RealtimeScoreCell *cell = (RealtimeScoreCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [RealtimeScoreCell createCell:self];				
	}		
    
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kive_li2.png"]];
    
    bgView.frame = cell.bounds;
    cell.selectedBackgroundView = bgView;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    [bgView release];
    
    cell.indexPath = indexPath;

    Match* match = [self.dataList objectAtIndex:indexPath.row];
    [cell setCellInfo:match];
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Match* match = [self.dataList objectAtIndex:indexPath.row];
    
    if (self.matchDetailController == nil){    
        MatchDetailController *controller = [[MatchDetailController alloc] initWithMatch:match];    
        self.matchDetailController = controller;
        [controller release];
    }
    
    [self.matchDetailController resetWithMatch:match];
    [self.navigationController pushViewController:self.matchDetailController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return NO; 
}

#pragma remote request delegate
#pragma mark -

- (void)getRealtimeMatchFinish:(int)result
                    serverDate:(NSDate*)serverDate
                   leagueArray:(NSArray*)leagueArray
              updateMatchArray:(NSArray*)updateMatchArray
{
    [self hideActivity];
    [self hideTipsOnTableView];
    
    if (result == ERROR_SUCCESS) {
        if (result == 0 && updateMatchArray == nil) {
            [self popupMessage:FNS(@"今天没有比赛更新") title:@""];
        }
        self.dataList = [[MatchManager defaultManager] filterMatch];
        if (self.dataList == nil || [self.dataList count] == 0) 
        {
            if (matchSelectStatus == MATCH_SELECT_STATUS_MYFOLLOW ) 
                [self showTipsOnTableView:FNS(@"您还没有选择关注的赛事")];
            else
                [self showTipsOnTableView:FNS(@"暂时没有相关的比赛")];
        } 
//        else 
//        {
//            [self hideTipsOnTableView];
//        }
    } 
    else if(hasClickedRefresh)
    {
        [self popupUnhappyMessage:FNS(@"kUnknowFailure") title:nil];
    }
    
    hasClickedRefresh = NO;
    [self dataSourceDidFinishLoadingNewData];
    [self.dataTableView reloadData];   
}

- (void)getRealtimeScoreFinish:(NSSet*)updateMatchSet
{
    
    NSMutableArray* indexPathes = [[NSMutableArray alloc] init];    
    int row = 0;
    int matchCount = 0;
    BOOL needReloadData = NO;
    for (Match* match in self.dataList){
        if ([updateMatchSet containsObject:match.matchId]){
            if ([match.status intValue] < 0) {
                needReloadData = YES;
                break;
            }
            [indexPathes addObject:[NSIndexPath indexPathForRow:row inSection:0]];
            matchCount ++;
        }
        row ++;
    }

    MatchManager* manager = [MatchManager defaultManager];
    BOOL allMatchUpdateFound = (matchCount == [updateMatchSet count]);
    BOOL viewOngoingMatch = (manager.filterMatchStatus == MATCH_SELECT_STATUS_ON_GOING);
    
    if ((needReloadData == NO) && (allMatchUpdateFound || !viewOngoingMatch)){
        // update rows only for better performance
        if ([indexPathes count] > 0){
            [self.dataTableView reloadRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationNone];
        }    
    }
    else{
        // reload all data
        self.dataList = [manager filterMatch];
        [self.dataTableView reloadData];
    }
    [indexPathes release];
}

- (IBAction) showActionSheet: (id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:FNS(@"请选择赛事比分类型")
                                  delegate:self
								  cancelButtonTitle:FNS(@"返回")
                                  
                                  
                                  
								  destructiveButtonTitle:FNS(@"一级赛事")
								  otherButtonTitles:FNS(@"全部比分"), 
                                  FNS(@"足彩比分"), FNS(@"竞彩比分"), FNS(@"单场比分"), nil
                                  ];
	
    	[actionSheet showFromTabBar:self.tabBarController.tabBar];
    	[actionSheet release];
    
    
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == actionSheet.cancelButtonIndex || matchSelectStatus == MATCH_SELECT_STATUS_MYFOLLOW) {
		return;
	}
    
//    if (buttonIndex == matchScoreType){
//        // same type, no change, return directly
//        return;
//    }
    self.matchScoreType = [self toMatchScoreTypeFromSheetIndex:buttonIndex];
    [[MatchManager defaultManager] setFilterMatchScoreType:self.matchScoreType];
        
       // reload data
    [self loadMatch:self.matchScoreType isSelectAll:YES];
   
    // update score type button display   
    
    [self resetScoreButtonTitle];
      
}

-(void)resetScoreButtonTitle
{
    switch (self.matchScoreType) {
        case MATCH_SCORE_TYPE_ALL:
            [scoreTypeButton setTitle:FNS(@"全部") forState:UIControlStateNormal];
            break;
            
        case MATCH_SCORE_TYPE_FIRST:
            [scoreTypeButton setTitle:FNS(@"一级") forState:UIControlStateNormal];
            break;
            
        case MATCH_SCORE_TYPE_SINGLE:
            [scoreTypeButton setTitle:FNS(@"足彩") forState:UIControlStateNormal];
            break;
            
        case MATCH_SCORE_TYPE_ZUCAI:
            [scoreTypeButton setTitle:FNS(@"竞彩") forState:UIControlStateNormal];
            break;
            
        case MATCH_SCORE_TYPE_JINGCAI:
            [scoreTypeButton setTitle:FNS(@"单场") forState:UIControlStateNormal];
            break;
        default:
            break;
            
    }
}



- (void)clickFilterLeague:(id)sender
{    
    [SelectLeagueController show:self  
                   leagueIdArray:[[LeagueManager defaultManager]  leagueArray]
              filterLeagueIdList:[[MatchManager defaultManager] filterLeagueIdList]];
    
}

- (void)clickSelectMatchType:(id)sender
{
    [self showActionSheet:sender];
}

#pragma Select Leaguge Delegate

- (void)didSelectLeague:(NSSet *)selectedLeagueArray
{
    if (matchSelectStatus == MATCH_SELECT_STATUS_MYFOLLOW)
        return;
    // filter data list by league data
    MatchManager* manager = [MatchManager defaultManager];
    [manager setIsSelectAll:NO];
    [manager updateFilterLeague:selectedLeagueArray removeExist:YES];
    self.dataList = [manager filterMatch];
    if (self.dataList == nil || [self.dataList count] == 0) {
        [self showTipsOnTableView:FNS(@"暂时没有相关的比赛")];
    } else {
        [self hideTipsOnTableView];
    }
    [[self dataTableView] reloadData];
    
}

- (int)calculateHiddenMatchCount:(NSMutableSet*)selectLeagueIdArray
{
    return [[MatchManager defaultManager] getHiddenMatchCount:selectLeagueIdArray];
}

- (IBAction)clickSelectMatchStatus:(id)sender
{
    if (sender == nil) {
        return;
    }
    [self setRefreshHeaderViewEnable:YES];
    UIButton* button = (UIButton*)sender;
    matchSelectStatus = button.tag;
    [self.filterBarButton setHidden:NO];
    [self.scoreTypeButton setHidden:NO];
    [self updateSelectMatchStatusButtonState:matchSelectStatus];

    // filter data list by league data
    MatchManager* manager = [MatchManager defaultManager];
    
    [manager updateFilterMatchStatus:matchSelectStatus];
    self.dataList = [manager filterMatch];
    if (self.dataList == nil || [self.dataList count] == 0) {
        [self showTipsOnTableView:FNS(@"暂时没有相关的比赛")];
    } else {
        [self hideTipsOnTableView];
    }
    [[self dataTableView] reloadData];    
}

- (IBAction)clickMyFollow:(id)sender
{ 
    if (sender == nil) {
        return;
    }
    [self hideTipsOnTableView];
    [self setRefreshHeaderViewEnable:NO];
    UIButton* button = (UIButton*)sender;
    matchSelectStatus = button.tag;
    [self.filterBarButton setHidden:YES];
    [self.scoreTypeButton setHidden:YES];
    [self updateSelectMatchStatusButtonState:matchSelectStatus];
    [[MatchManager defaultManager] updateFilterMatchStatus:matchSelectStatus];
    [self reloadMyFollowList];
    if (self.dataList == nil || [self.dataList count] == 0) {
        [self showTipsOnTableView:FNS(@"您还没有选择关注的赛事")];
    } else {
        [self hideTipsOnTableView];
    }
//    MatchManager *manager = [MatchManager defaultManager];
//    self.dataList = [manager getAllFollowMatch];
//    [[self dataTableView] reloadData];
}

- (void)didClickFollowButton:(id)sender atIndex:(NSIndexPath*)indexPath
{
    // TODO call Match Manager follow/unfollow method
    Match* match = [self.dataList objectAtIndex:indexPath.row];
    MatchManager* manager = [MatchManager defaultManager];
    if (match.isFollow == [NSNumber numberWithBool:YES]){
        [GlobalGetMatchService() unfollowMatch:[UserManager getUserId] match:match];
        [ShowAlertTextViewController show:self.view message:FNS(@"已成功取消关注")];
    }
    else{
        [GlobalGetMatchService() followMatch:[UserManager getUserId] match:match]; 
        [ShowAlertTextViewController show:self.view message:FNS(@"已成功关注")];
    }
    
    if (matchSelectStatus == MATCH_SELECT_STATUS_MYFOLLOW){
        // only unfollow is possible here... so just update data list and delete the row
        Match* matchInMatchArray = [manager getMathById:match.matchId];
        [matchInMatchArray setIsFollow:[NSNumber numberWithBool:NO]];//because in myfollow,we can just delete,not add   
        [self reloadMyFollowList];            // I am lazy today so I just reload the table view
    }
    else{
        [self.dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                             withRowAnimation:UITableViewRowAnimationNone];
    }
    [self reloadMyFollowCount];
}

- (void)updateMatchTimeDisplay
{
    NSArray* indexPathes = [self.dataTableView indexPathsForVisibleRows];
    [self.dataTableView reloadRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationNone];

#ifdef DEBUG    
   // NSLog(@"updateMatchTimeDisplay, update %@", [indexPathes description]);
#endif    
    
}

- (void)setRightBarButtons
{
    float buttonHigh = 27.5;
    float buttonLen = 47.5;
    float refreshButtonLen = 32.5;
    float seporator = 3;
    float leftOffest = 0;
    UIFont *font = [UIFont systemFontOfSize:14];
    
    UIView *rightButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3*(buttonLen+seporator)+refreshButtonLen, buttonHigh)];
    
    UIButton *refreshButton = [[UIButton alloc]initWithFrame:CGRectMake(leftOffest+(buttonLen+seporator)*3, 0, refreshButtonLen, buttonHigh)];
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [refreshButton setTitle:@"" forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(clickRefreshButton) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:refreshButton];
    [refreshButton release];
    
//    UIButton *recommendBackgroundButton = [[UIButton alloc]initWithFrame:CGRectMake(leftOffest+buttonLen*2+seporator
//                                                                          , -seporator
//                                                                          , recommendButtonLen+seporator*2
//                                                                          , buttonHigh+seporator*2)];
//    [recommendBackgroundButton setImage:[UIImage imageNamed:@"hot.png"] forState:UIControlStateNormal];
//    [rightButtonView addSubview:recommendBackgroundButton];
//    [recommendBackgroundButton release];
    
    UIButton *recommendButton = [[UIButton alloc]initWithFrame:CGRectMake(leftOffest+(buttonLen+seporator)*2
                                                                          , 0
                                                                          , buttonLen
                                                                          , buttonHigh)];
    [recommendButton setBackgroundImage:[UIImage imageNamed:@"ss.png"] forState:UIControlStateNormal];
    [recommendButton setTitle:@"荐" forState:UIControlStateNormal];
    //[recommendButton setBackgroundColor:[UIColor blackColor]];
    [recommendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recommendButton.titleLabel setFont:font]; 
    [recommendButton addTarget:self action:@selector(clickRecommendButton) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:recommendButton];
    [recommendButton release];
    
    self.recommendAppCountView = [[UIBadgeView alloc] initWithFrame:CGRectMake(0, 0, 22, 17)];
    [self.recommendAppCountView setCenter:CGPointMake(leftOffest+buttonLen*3+seporator,0)];
    [self.recommendAppCountView setBadgeColor:[UIColor redColor]];
    [self.recommendAppCountView setShadowEnabled:NO];
    [self.recommendAppCountView setHidden:YES];
    [rightButtonView addSubview:_recommendAppCountView];
    
    
    scoreTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(leftOffest, 0, buttonLen, buttonHigh)];
    [scoreTypeButton setBackgroundImage:[UIImage imageNamed:@"ss.png"] forState:UIControlStateNormal];
    [scoreTypeButton setTitle:FNS(@"全部") forState:UIControlStateNormal];
    [scoreTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scoreTypeButton.titleLabel setFont:font]; 
    [scoreTypeButton addTarget:self action:@selector(clickSelectMatchType:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:scoreTypeButton];
    
    
    filterBarButton = [[UIButton alloc] initWithFrame:CGRectMake(leftOffest+buttonLen+seporator, 0, buttonLen, buttonHigh)];
    [filterBarButton addTarget:self action:@selector(clickFilterLeague:) forControlEvents:UIControlEventTouchUpInside];
    [filterBarButton setBackgroundImage:[UIImage imageNamed:@"ss.png"] forState:UIControlStateNormal];
    [filterBarButton setTitle:FNS(@"筛选") forState:UIControlStateNormal];
    [filterBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterBarButton.titleLabel setFont:font];
    [rightButtonView addSubview:filterBarButton];
    [filterBarButton release];

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] 
                                       initWithCustomView:rightButtonView];

    [rightButtonView release];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
}

- (void)setLeftBarButtons
{
    UIView *leftTopBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    
    UIImageView *liveLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_logo2"]];
    [leftTopBarView addSubview:liveLogo];
    [liveLogo release];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftTopBarView];
    [leftTopBarView release];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.title = @"";
    [leftBarButton release];
    
}


- (void)clickRefreshButton
{
    hasClickedRefresh = YES;
    if (matchSelectStatus == MATCH_SELECT_STATUS_MYFOLLOW){ 
        [self.dataTableView reloadData];
        hasClickedRefresh = NO;
        return;
    }
    
    [self loadMatch:self.matchScoreType];
    
}

- (void)clickRecommendButton
{
    RecommendedAppsControllerViewController* vc = [[[RecommendedAppsControllerViewController alloc] init] autorelease];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)myFollowCountBadgeViewInit
{
    int tagLen = 20;
    CGRect rect = [myFollowButton bounds];
    myFollowCountView = [[UIBadgeView alloc] initWithFrame:CGRectMake(rect.size.width-tagLen, -1, tagLen, tagLen)];
    [self.myFollowCountView setShadowEnabled:NO];
    [self.myFollowCountView setBadgeColor:[UIColor redColor]];
    [self.myFollowButton addSubview:self.myFollowCountView];
    [self reloadMyFollowCount];
}

- (void)reloadMyFollowCount
{
    MatchManager *manager = [MatchManager defaultManager];
    int followMatchCount = [[manager getAllFollowMatch] count];
    self.myFollowCountView.badgeString = [NSString stringWithFormat:@"%d", followMatchCount];
    if (followMatchCount == 0) {
        [myFollowCountView setHidden:YES];
    }
    else {
        [myFollowCountView setHidden:NO];
    }

}

- (void)reloadMyFollowList
{
    MatchManager *manager = [MatchManager defaultManager];
    self.dataList = [manager getAllFollowMatch];
    [[self dataTableView] reloadData];
}


#pragma refreshHeaderView callback method.

- (void) reloadTableViewDataSource
{
    hasClickedRefresh = YES;
    if (matchSelectStatus == MATCH_SELECT_STATUS_MYFOLLOW) {
        return;
    }
    [self loadMatch:self.matchScoreType];
    
    
    // after finish loading data, please call the following codes
    // [refreshHeaderView setCurrentDate];  	
	// [self dataSourceDidFinishLoadingNewData];
    
}

#pragma mark - recommendAppServiceDelegate
- (void)getRecommendAppFinish
{
    int recommendAppCount = [RecommendAppManager defaultManager].appList.count;
    [self.recommendAppCountView setBadgeString:[NSString stringWithFormat:@"%d",recommendAppCount]];
    if (recommendAppCount <= 0) {
        [self.recommendAppCountView setHidden:YES];
    } else {
        [self.recommendAppCountView setHidden:NO];
    }
}

@end
