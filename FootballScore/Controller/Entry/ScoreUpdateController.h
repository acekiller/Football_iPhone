//
//  ScoreUpdateController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "MatchService.h"
#import "ScoreUpdateCell.h"
@protocol ScoreUpdateControllerDelegate <NSObject>

-(void) updateScoreMessageCount:(NSInteger)count;

@end

@interface ScoreUpdateController : PPTableViewController <UIActionSheetDelegate, MatchServiceDelegate, ScoreUpdateCellDelegate>{

    BOOL deleteFlag;
    UILabel *dateTimeLabel;
    id<ScoreUpdateControllerDelegate> ScoreUpdateControllerDelegate;
}

@property (nonatomic, retain) IBOutlet UILabel *dateTimeLabel;
@property (nonatomic, assign) BOOL deleteFlag;
@property (nonatomic, assign) id<ScoreUpdateControllerDelegate> ScoreUpdateControllerDelegate;
- (void)getScoreUpdateFinish:(NSSet *)scoreUpdateSet;
- (void)getRealtimeScoreFinish:(NSSet*)updateMatchSet;
- (void)endClickDeleteButton:(NSIndexPath *)indexPath;
- (void)refleshCount;
- (id)initWithDelegate:(id<ScoreUpdateControllerDelegate>)delegate;

- (void)clickEdit:(id)sender;
- (void)clickDone:(id)sender;
- (void)clickRefresh:(id)sender;
- (void)clickClear:(id)sender;

- (NSDictionary*)getShowScoreList:(NSSet *)scoreUpdateSet;

@end
