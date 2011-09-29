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

@implementation RealtimeScoreController

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
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)updateSelectMatchStatusButtonState:(int)selectMatchStatus
{
    for (int i=MATCH_SELECT_STATUS_ALL; i<=MATCH_SELECT_STATUS_MYFOLLOW; i++){
        UIButton* button = (UIButton*)[self.view viewWithTag:i];
        if (i == selectMatchStatus){
            [button setSelected:YES];  
            [button setBackgroundColor:[UIColor greenColor]];
        }
        else{
            [button setSelected:NO];
            [button setBackgroundColor:[UIColor yellowColor]];
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

    [self updateSelectMatchStatusButtonState:MATCH_SELECT_STATUS_ALL];
    
    [self setNavigationLeftButton:FNS(@"赛事筛选") action:@selector(clickFilterLeague:)];
    [self setNavigationRightButton:FNS(@"比分类型") action:@selector(clickSelectMatchType:)];
    
    [super viewDidLoad];
    
    [self loadMatch:0];
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
	return [dataList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [RealtimeScoreCell getCellIdentifier];
	RealtimeScoreCell *cell = (RealtimeScoreCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [RealtimeScoreCell createCell:self];				
		cell.selectionStyle = UITableViewCellSelectionStyleNone;							
	}		
    
    cell.indexPath = indexPath;

    Match* match = [dataList objectAtIndex:indexPath.row];
    [cell setCellInfo:match];
	
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Match* match = [dataList objectAtIndex:indexPath.row];
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
        [dataTableView reloadData];             // I am lazy today so I just reload the table view
    }
    else{
        [dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                             withRowAnimation:UITableViewScrollPositionNone];
    }
}

#pragma remote request delegate
#pragma -

- (void)getRealtimeMatchFinish:(int)result
                    serverDate:(NSDate*)serverDate
                   leagueArray:(NSArray*)leagueArray
              updateMatchArray:(NSArray*)updateMatchArray
{
    self.dataList = [[MatchManager defaultManager] matchArray];
    [[self dataTableView] reloadData];
    [self hideActivity];
}


- (IBAction) showActionSheet: (id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:FNS(@"请选择赛事比分类型")
                                  delegate:self
								  cancelButtonTitle:FNS(@"返回")
								  destructiveButtonTitle:FNS(@"一级赛事")
								  otherButtonTitles:FNS(@"全部比分"), 
                                  FNS(@"单场比分"), FNS(@"足彩比分"), FNS(@"竞彩比分"), nil
                                  ];
	
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == actionSheet.cancelButtonIndex) {
		return;
	}
    
    if (buttonIndex == matchScoreType){
        // same type, no change, return directly
        return;
    }
    
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
}

@end
