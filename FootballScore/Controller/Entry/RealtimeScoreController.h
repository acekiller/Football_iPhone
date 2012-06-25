//
//  RealtimeScoreController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "SelectLeagueController.h"
#import "MatchService.h"
#import "MatchDetailController.h"
#import "UIBadgeView.h"
#import "RecommendAppService.h"

@class MatchDetailController;

@interface RealtimeScoreController : PPTableViewController <MatchServiceDelegate, 
    UIActionSheetDelegate, SelectLeagueControllerDelegate, RecommendAppServiceDelegate> {
    
    int _matchScoreType;
    int matchSelectStatus;   
        
    NSTimer *matchSecondTimer;
    UIButton *myFollowButton;
        
        
    UIButton *scoreTypeButton;
    UIButton *filterBarButton;
        
    BOOL hasClickedRefresh;    
}

@property (nonatomic,retain) NSTimer *matchSecondTimer;
@property (nonatomic, assign) int matchScoreType;

- (IBAction)clickSelectMatchStatus:(id)sender;
- (IBAction)clickMyFollow:(id)sender;
- (void)setRightBarButtons;
- (void)setLeftBarButtons;
- (void)clickRefreshButton;
- (void)myFollowCountBadgeViewInit;
- (void)reloadMyFollowCount;
- (void)reloadMyFollowList;
- (void)resetScoreButtonTitle;

@property (nonatomic, retain) IBOutlet UIButton *myFollowButton;
@property (nonatomic, retain) UIButton *scoreTypeButton;
@property (nonatomic, retain) UIButton *filterBarButton;

@property (nonatomic, retain) IBOutlet UIBadgeView *myFollowCountView;
@property (nonatomic, retain) UIBadgeView *recommendAppCountView;
@property (nonatomic, retain) MatchDetailController *matchDetailController;

@end
