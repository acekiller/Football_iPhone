//
//  ScoreUpdateController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ScoreUpdateController.h"
#import "LocaleConstants.h"
#import "ScoreUpdate.h"
#import "ScoreUpdateManager.h"
#import "TimeUtils.h"
#import "MatchManager.h"
@implementation ScoreUpdateController
@synthesize dateTimeLabel;
@synthesize deleteFlag;
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
    [dateTimeLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (NSString *)getDateString
{
    NSString *dateString = dateToChineseStringByFormat([NSDate date], @"yyyy-MM-dd");
    return [NSString stringWithFormat:@"%@ %@",dateString, chineseWeekDayFromDate([NSDate date])];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.dataTableView setEditing:NO];
    [self setDeleteFlag:NO];
    
    
    
    [self setNavigationRightButtonWithSystemStyle:UIBarButtonSystemItemRefresh action:@selector(clickRefresh:)];
    [self setNavigationRightButton:nil imageName:@"refresh.png" action:@selector(clickRefresh:)];
    
    
    [self setNavigationLeftButton:FNS(@"编辑") imageName:@"ss.png" action:@selector(clickEdit:)];
    
    
    self.dateTimeLabel.text = [self getDateString];
    
        
    /*  假数据，调试使用。
    

    MatchManager *manager = [MatchManager defaultManager];
    Match *match = [manager.matchArray objectAtIndex:2];
    ScoreUpdate *update = [[ScoreUpdate alloc] initWithMatch:match ScoreUpdateType:HOMETEAMYELLOW];
    [[[ScoreUpdateManager defaultManager]scoreUpdateList] addObject:update];
    self.dataList = [[ScoreUpdateManager defaultManager] scoreUpdateList];
    [update release];
     
     */

}

- (void)viewDidUnload
{
    [self setDateTimeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma matchServiece delegate
#pragma -
- (void)getRealtimeScoreFinish:(NSSet*)updateMatchSet
{
    
}

#pragma table view delegate
#pragma -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [ScoreUpdateCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataList count];
    //return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [ScoreUpdateCell getCellIdentifier];
	ScoreUpdateCell *cell = (ScoreUpdateCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [ScoreUpdateCell createCell:self];		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;							
	}		
    cell.scoreUpdateCellDelegate = self;
    cell.indexPath = indexPath;
    
    [cell.deleteButton setHidden:!self.deleteFlag];
    
    ScoreUpdate* scoreUpdate = [dataList objectAtIndex:indexPath.row];
    
    [cell setCellInfo:scoreUpdate];
	
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}



#pragma delegate
- (void)getScoreUpdateFinish:(NSSet *)scoreUpdateSet
{
    ScoreUpdateManager *scoreUpdateManager = [ScoreUpdateManager defaultManager];
    
    
    NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
    [self.dataTableView beginUpdates];
    
    int count = [scoreUpdateManager insertScoreUpdateSet:scoreUpdateSet];
    self.dataList = [scoreUpdateManager scoreUpdateList];
    
    for (int i = 0; i < count; ++ i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:indexPath];
    }
    
    [self.dataTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:YES];
    
    [self.dataTableView endUpdates];
    [indexPathArray release];
}


-(void) endClickDeleteButton:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.dataTableView beginUpdates];
        
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        
        [self.dataTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [[ScoreUpdateManager defaultManager] removeScoreUpdateAtIndex:indexPath.row];
        self.dataList = [[ScoreUpdateManager defaultManager] scoreUpdateList];
        [self.dataTableView endUpdates];
        if (!self.dataList || [self.dataList count] == 0) {
            [self clickDone:nil];
        }
    }
}
#pragma action selector

- (void)clickEdit:(id)sender
{
    [self setDeleteFlag:YES];
    [self.dataTableView reloadData];
    [self setNavigationLeftButton:FNS(@"完成")imageName:@"ss.png" action:@selector(clickDone:)];
    [self setNavigationRightButton:FNS(@"清空") imageName:@"ss.png" action:@selector(clickClear:)];
    
}
- (void)clickDone:(id)sender
{
    [self setDeleteFlag:NO];
    [self setNavigationRightButtonWithSystemStyle:UIBarButtonSystemItemRefresh action:@selector(clickRefresh:)];
    [self setNavigationRightButton:nil imageName:@"refresh.png" action:@selector(clickRefresh:)];
    [self setNavigationLeftButton:FNS(@"编辑") imageName:@"ss.png" action:@selector(clickEdit:)];
    [self.dataTableView reloadData];    
}
- (void)clickRefresh:(id)sender
{
    [GlobalGetMatchService() getRealtimeScore];
}
- (void)clickClear:(id)sender
{
    [self setDeleteFlag:NO];
    [self setNavigationRightButtonWithSystemStyle:UIBarButtonSystemItemRefresh action:@selector(clickRefresh:)];
    [self setNavigationRightButton:nil imageName:@"refresh.png" action:@selector(clickRefresh:)];
    [self setNavigationLeftButton:FNS(@"编辑") imageName:@"ss.png" action:@selector(clickEdit:)];
    [[ScoreUpdateManager defaultManager] removeAllScoreUpdates];
    self.dataList = [[ScoreUpdateManager defaultManager] scoreUpdateList];
    [self.dataTableView reloadData];
}

@end
