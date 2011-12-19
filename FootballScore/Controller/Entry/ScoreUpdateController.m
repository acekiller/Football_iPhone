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
#import "StatusView.h"
#import "ColorManager.h"
#import "ShowRealtimeScoreController.h"
#import "ConfigManager.h"
#import "Match.h"
#import "PPNetworkRequest.h"

@implementation ScoreUpdateController
@synthesize dateTimeLabel;
@synthesize deleteFlag;
@synthesize ScoreUpdateControllerDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDelegate:(id<ScoreUpdateControllerDelegate>) delegate
{
    self.ScoreUpdateControllerDelegate = delegate;
    self = [self init];
    if (self) {
        //
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
    
    hasClickedRefresh = NO;
    
    
    [self setNavigationRightButtonWithSystemStyle:UIBarButtonSystemItemRefresh action:@selector(clickRefresh:)];
    [self setNavigationRightButton:nil imageName:@"refresh.png" action:@selector(clickRefresh:)];
    
    
    [self setNavigationLeftButton:FNS(@"编辑") imageName:@"ss.png" action:@selector(clickEdit:)];
    
    
    self.dateTimeLabel.text = [self getDateString];
    self.dateTimeLabel.textColor=[ColorManager dateTimeTextColor]; 
    [self refreshCount];

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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return NO; 
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
    cell.indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    
    [cell.deleteButton setHidden:!self.deleteFlag];
    
    ScoreUpdate* scoreUpdate = [dataList objectAtIndex:indexPath.row];
    
    [cell setCellInfo:scoreUpdate deleteFlag:self.deleteFlag];
	
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


- (NSDictionary*)getShowScoreList:(NSSet *)scoreUpdateSet
{
    NSMutableDictionary *goalsTipsDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    for (ScoreUpdate *scoreUpdate in scoreUpdateSet) 
    {
        if (scoreUpdate.scoreUpdateType == HOMETEAMSCORE) 
        {
            NSString *matchId = [NSString stringWithFormat:@"%@",scoreUpdate.match.matchId];
            NSNumber *goalsTeam = [goalsTipsDictionary objectForKey:matchId];
            
            if (goalsTeam == nil)
            {
                [goalsTipsDictionary setValue:[NSNumber numberWithInt:HOMETEAM_GOALS] forKey:matchId];
            }
            else if ([goalsTeam intValue] == AWAYTEAM_GOALS)
                [goalsTipsDictionary setValue:[NSNumber numberWithInt:BOTH_GOALS] forKey:matchId];
        }
        
        else if(scoreUpdate.scoreUpdateType == AWAYTEAMSCORE)
        {
            NSString *matchId = [NSString stringWithFormat:@"%@",scoreUpdate.match.matchId];
            NSNumber *goalsTeam = [goalsTipsDictionary objectForKey:matchId];
            
            if (goalsTeam == nil)
                [goalsTipsDictionary setValue:[NSNumber numberWithInt:AWAYTEAM_GOALS] forKey:matchId ];
            else if ([goalsTeam intValue] == HOMETEAM_GOALS)
                [goalsTipsDictionary setValue:[NSNumber numberWithInt:BOTH_GOALS] forKey:matchId ];
        }
    }
    
    return  goalsTipsDictionary;
}

#pragma delegate
- (void)getScoreUpdateFinish:(NSSet *)scoreUpdateSet resultCode:(NSInteger)resultCode
{
    
    
    if (resultCode == ERROR_SUCCESS) {
        ScoreUpdateManager *scoreUpdateManager = [ScoreUpdateManager defaultManager];
        
        // according to the score update type set the hometeam data count and awayteam data count
        
        for (ScoreUpdate *update in scoreUpdateSet) {
            [update calculateAndSetData];
        }
        
        int count = [scoreUpdateManager insertScoreUpdateSet:scoreUpdateSet];
        if (count) {  
            NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
            [self.dataTableView beginUpdates];
            self.dataList = [scoreUpdateManager scoreUpdateList];
            for (int i = 0; i < count; ++ i) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPathArray addObject:indexPath];
            }
            [self.dataTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:YES];
            [self.dataTableView endUpdates];
            [indexPathArray release];
            
            
            NSDictionary *goalsTipsDictionary = [self getShowScoreList:scoreUpdateSet];
            
            NSEnumerator *enumerator = [goalsTipsDictionary keyEnumerator];
            NSString *matchId;
            NSNumber *type;
            
            while(matchId = [enumerator nextObject])
            {
                type = [goalsTipsDictionary objectForKey:matchId];
                
                [ShowRealtimeScoreController show:[[MatchManager defaultManager] getMathById:matchId]
                                        goalsTeam:[type intValue] 
                                      isVibration:[ConfigManager getIsVibration]
                                         hasSound:[ConfigManager getHasSound]];
            }
            
        }
        [self refreshCount];
    }else if(hasClickedRefresh)
    {
        [self popupUnhappyMessage:FNS(@"kUnknowFailure") title:nil];

    }

    hasClickedRefresh = NO;
}


-(void) endClickDeleteButton:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        
        [[ScoreUpdateManager defaultManager] removeScoreUpdateAtIndex:indexPath.row];
        self.dataList = [[ScoreUpdateManager defaultManager] scoreUpdateList];

        [self.dataTableView beginUpdates];        
        [self.dataTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.dataTableView endUpdates];
        
        
        [self.dataTableView beginUpdates];        
        [self.dataTableView reloadRowsAtIndexPaths:[self.dataTableView indexPathsForVisibleRows]  
                                  withRowAnimation:UITableViewRowAnimationNone];
        [self.dataTableView endUpdates];

        
        if (!self.dataList || [self.dataList count] == 0) {
            [self clickDone:nil];
        }
    }
    [self refreshCount];
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
    [self refreshCount];
    [self.dataTableView reloadData];    
}
- (void)clickRefresh:(id)sender
{
    hasClickedRefresh = YES;
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
    [self refreshCount];
    [self.dataTableView reloadData];
}

- (void)refreshCount
{
    if (self.ScoreUpdateControllerDelegate && [self.ScoreUpdateControllerDelegate respondsToSelector:@selector(updateScoreMessageCount:)]) {
        [self.ScoreUpdateControllerDelegate updateScoreMessageCount:[self.dataList count]];
    }
}

@end
