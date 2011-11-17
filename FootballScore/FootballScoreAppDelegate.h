//
//  FootballScoreAppDelegate.h
//  Dipan
//
//  Created by qqn_pipi on 11-4-30.
//  Copyright QQN-PIPI.com 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataUtil.h"
#import "PPApplication.h"
#import "MobClick.h"
#import "ScoreUpdateController.h"

@class PPTabBarController;

// TODO remove all depedency class header files

@class ReviewRequest;
@class MatchService;
@class RealtimeScoreController;
@class OddsService;

#define _THREE20_		1
#define kAppId			@"456494464"					// To be changed for each project
#define kMobClickKey	@"4ec3d2b65270150459000007"		// To be changed for each project

#define MAKE_FRIEND_PLACEID @"GroupBuy"

@interface FootballScoreAppDelegate : PPApplication <UIApplicationDelegate, UITabBarControllerDelegate, MobClickDelegate, ScoreUpdateControllerDelegate> {
    
    UIWindow			*window;
    PPTabBarController	*tabBarController;
	CoreDataManager		*dataManager;	
        
    ReviewRequest           *reviewRequest;
    NSString                *dataForRegistration;
    MatchService            *matchService;
    RealtimeScoreController *matchController;
    UIBackgroundTaskIdentifier backgroundTask;
}

@property (nonatomic, retain) IBOutlet UIWindow				*window;
@property (nonatomic, retain) IBOutlet PPTabBarController	*tabBarController;
@property (nonatomic, retain) CoreDataManager				*dataManager;
@property (nonatomic, retain) ReviewRequest                 *reviewRequest;
@property (nonatomic, retain) MatchService                  *matchService;
@property (nonatomic, retain) RealtimeScoreController       *matchController;
@property (nonatomic, retain) OddsService                   *oddsService;
@end


