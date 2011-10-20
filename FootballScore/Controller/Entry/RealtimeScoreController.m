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


@implementation RealtimeScoreController
@synthesize myFollowButton;
@synthesize myFollowCountView;

@synthesize matchSecondTimer;
@synthesize matchDetailController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        matchScoreType = MATCH_SCORE_TYPE_FIRST;
    }
    return self;
}

- (void)dealloc
{
    [matchDetailController release];
    [matchSecondTimer release];
    [myFollowButton release];
    [myFollowCountView release];
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



- (void)updateSelectMatchStatusButtonState:(int)selectMatchStatus
{
    for (int i=MATCH_SELECT_STATUS_ALL; i<=MATCH_SELECT_STATUS_MYFOLLOW; i++){
        UIButton* button = (UIButton*)[self.view viewWithTag:i];
        if (i == selectMatchStatus) {
            [button setSelected:YES];  
            [button setBackgroundImage:[UIImage imageNamed:@"live_menu_2_on"] forState:UIControlStateNormal];     
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else{
            [button setSelected:NO];
            [button setBackgroundImage:[UIImage imageNamed:@"live_menu_2"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }   
        
    }

}




- (void)loadMatch:(int)scoreType
{
    [self showActivityWithText:FNS(@"加载数据中...")];
    [GlobalGetMatchService() getRealtimeMatch:self matchScoreType:scoreType];
}

- (void)viewDidLoad
{
    int UPDATE_TIME_INTERVAL = 60;
    self.matchSecondTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_TIME_INTERVAL
                                                             target:self 
                                                           selector:@selector(updateMatchTimeDisplay) 
                                                           userInfo:nil 
                                                            repeats:YES];
    
    [self updateSelectMatchStatusButtonState:MATCH_SELECT_STATUS_ALL];
    [self setRightBarButtons];
//    [self setLeftBarButtons];等 logo完成之后，这个取消注释

    self.view.backgroundColor = [UIColor colorWithRed:(0xf3)/255.0 
                                                green:(0xf7)/255.0 
                                                 blue:(0xf8)/255.0 
                                                alpha:1.0];
    
    [super viewDidLoad];
    
    [self loadMatch:0];
    // Do any additional setup after loading the view from its nib.
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
		cell.selectionStyle = UITableViewCellSelectionStyleNone;			        
        [cell setBackgroundImageByName:@"kive_li.png"];
	}		
    
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

#pragma remote request delegate
#pragma -

- (void)getRealtimeMatchFinish:(int)result
                    serverDate:(NSDate*)serverDate
                   leagueArray:(NSArray*)leagueArray
              updateMatchArray:(NSArray*)updateMatchArray
{
    self.dataList = [[MatchManager defaultManager] filterMatch];
    [[self dataTableView] reloadData];
    [self hideActivity];
    
    [self showMyFollowCount];
}

- (void)getRealtimeScoreFinish:(NSSet*)updateMatchSet
{
    
    NSMutableArray* indexPathes = [[NSMutableArray alloc] init];    
    int row = 0;
    int matchCount = 0;
    for (Match* match in self.dataList){
        if ([updateMatchSet containsObject:match.matchId]){
            [indexPathes addObject:[NSIndexPath indexPathForRow:row inSection:0]];
            matchCount ++;
        }
        row ++;
    }

    MatchManager* manager = [MatchManager defaultManager];
    BOOL allMatchUpdateFound = (matchCount == [updateMatchSet count]);
    BOOL viewOngoingMatch = (manager.filterMatchStatus == MATCH_SELECT_STATUS_ON_GOING);
    
    if (allMatchUpdateFound || !viewOngoingMatch){
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
								  destructiveButtonTitle:FNS(@"全部比分")
								  otherButtonTitles:FNS(@"一级赛事"), 
                                  FNS(@"单场比分"), FNS(@"足彩比分"), FNS(@"竞彩比分"), nil
                                  ];
	
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == actionSheet.cancelButtonIndex) {
		return;
	}
    
//    if (buttonIndex == matchScoreType){
//        // same type, no change, return directly
//        return;
//    }
    
    matchScoreType = buttonIndex;
    
    // reload data
    [self loadMatch:matchScoreType];
}


- (void)clickFilterLeague:(id)sender
{
    [SelectLeagueController show:self]; 
}

- (void)clickSelectMatchType:(id)sender
{
    [self showActionSheet:sender];
}

- (void)didSelectLeague:(NSSet*)selectedLeagueArray
{
    // filter data list by league data
    MatchManager* manager = [MatchManager defaultManager];
    [manager updateFilterLeague:selectedLeagueArray removeExist:YES];
    self.dataList = [manager filterMatch];
    [[self dataTableView] reloadData];
}

- (IBAction)clickSelectMatchStatus:(id)sender
{
    UIButton* button = (UIButton*)sender;
    int selectMatchStatus = button.tag;
    [self updateSelectMatchStatusButtonState:selectMatchStatus];
    
    // filter data list by league data
    MatchManager* manager = [MatchManager defaultManager];
    [manager updateFilterMatchStatus:selectMatchStatus];
    self.dataList = [manager filterMatch];
    [[self dataTableView] reloadData];    
}

- (IBAction)clickMyFollow:(id)sender
{
    UIButton* button = (UIButton*)sender;
    int selectMatchStatus = button.tag;
    [self updateSelectMatchStatusButtonState:selectMatchStatus];
    
    // filter data list
    MatchManager* manager = [MatchManager defaultManager];
    [manager updateFilterMatchStatus:selectMatchStatus];
    self.dataList = [manager filterMatch];
    [[self dataTableView] reloadData];
}

- (void)didClickFollowButton:(id)sender atIndex:(NSIndexPath*)indexPath
{
    // TODO call Match Manager follow/unfollow method
    Match* match = [self.dataList objectAtIndex:indexPath.row];
    MatchManager* manager = [MatchManager defaultManager];
    if ([match isFollow]){
        [manager unfollowMatch:match];  
    }
    else{
        [manager followMatch:match];
    }
    
    if ([manager filterMatchStatus] == MATCH_SELECT_STATUS_MYFOLLOW){
        // only unfollow is possible here... so just update data list and delete the row
        self.dataList = [manager filterMatch];
        [self.dataTableView reloadData];             // I am lazy today so I just reload the table view
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
    NSLog(@"updateMatchTimeDisplay, update %@", [indexPathes description]);
#endif    
    
}

- (void)setRightBarButtons
{
    float buttonHigh = 27.5;
    float buttonLen = 47.5;
    float refeshButtonLen = 32.5;
    float seporator = 5;
    float leftOffest = 20;
    UIFont *font = [UIFont systemFontOfSize:14];
    
    UIView *rightButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3*(buttonLen+seporator), buttonHigh)];
    
    UIButton *refleshButton = [[UIButton alloc]initWithFrame:CGRectMake(leftOffest+(buttonLen+seporator)*2, 0, refeshButtonLen, buttonHigh)];
    [refleshButton setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [refleshButton setTitle:@"" forState:UIControlStateNormal];
    [refleshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [refleshButton addTarget:self action:@selector(clickRefleshButton) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:refleshButton];
    [refleshButton release];
    
    UIButton *scoreTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(leftOffest+buttonLen+seporator, 0, buttonLen, buttonHigh)];
    [scoreTypeButton setBackgroundImage:[UIImage imageNamed:@"ss"] forState:UIControlStateNormal];
    [scoreTypeButton setTitle:FNS(@"完整") forState:UIControlStateNormal];
    [scoreTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scoreTypeButton.titleLabel setFont:font]; 
    [scoreTypeButton addTarget:self action:@selector(clickSelectMatchType:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:scoreTypeButton];
    [scoreTypeButton release];
    
    UIButton *filterButton = [[UIButton alloc] initWithFrame:CGRectMake(leftOffest, 0, buttonLen, buttonHigh)];
    [filterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(clickFilterLeague:) forControlEvents:UIControlEventTouchUpInside];
    [filterButton setBackgroundImage:[UIImage imageNamed:@"ss"] forState:UIControlStateNormal];
    [filterButton setTitle:FNS(@"筛选") forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterButton.titleLabel setFont:font];
    [rightButtonView addSubview:filterButton];
    [filterButton release];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    [rightButtonView release];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
}

- (void)setLeftBarButtons
{
    UIView *leftTopBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    
    UIImageView *liveLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_logo"]];
    [leftTopBarView addSubview:liveLogo];
    [liveLogo release];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftTopBarView];
    [leftTopBarView release];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    [leftBarButton release];
    
}


- (void)clickRefleshButton
{
    [self loadMatch:matchScoreType];
}

- (void)showMyFollowCount
{
    int tagLen = 20;
    CGRect rect = [myFollowButton bounds];
    self.myFollowCountView = [[UIBadgeView alloc] initWithFrame:CGRectMake(rect.size.width-tagLen, -1, tagLen, tagLen)];
    [self.myFollowCountView setShadowEnabled:NO];
    [self.myFollowButton addSubview:self.myFollowCountView];
    [self reloadMyFollowCount];
}

- (void)reloadMyFollowCount
{
    MatchManager *manager = [MatchManager defaultManager];
    int followMatchCount = [manager getCurrentFollowMatchCount];
    self.myFollowCountView.badgeString = [NSString stringWithFormat:@"%d", followMatchCount];
    [self.myFollowCountView setBadgeColor:[UIColor redColor]];
    
    if (followMatchCount == 0) {
        [myFollowCountView setHidden:YES];
    }
    else {
        [myFollowCountView setHidden:NO];
    }

}

@end
