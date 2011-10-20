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

@class MatchDetailController;

@interface RealtimeScoreController : PPTableViewController <MatchServiceDelegate, 
    UIActionSheetDelegate, SelectLeagueControllerDelegate> {
    
    int matchScoreType;
        
    NSTimer *matchSecondTimer;
    UIButton *myFollowButton;
}

@property (nonatomic, retain) NSTimer *matchSecondTimer;

- (IBAction)clickSelectMatchStatus:(id)sender;
- (void)setRightBarButtons;
- (void)setLeftBarButtons;
- (void)clickRefleshButton;
- (void)showMyFollowCount;
- (void)reloadMyFollowCount;

@property (nonatomic, retain) IBOutlet UIButton *myFollowButton;
@property (nonatomic, retain) IBOutlet UIBadgeView *myFollowCountView;
@property (nonatomic, retain) MatchDetailController *matchDetailController;

@end
