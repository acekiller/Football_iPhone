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
#import "UserService.h"

@class PPTabBarController;

// TODO remove all depedency class header files

@class ReviewRequest;
@class MatchService;
@class RealtimeScoreController;
@class OddsService;
@class ScheduleService;
@class NetworkDetector;
@class RetryService;
@class RealtimeIndexController;


#define _THREE20_		1
#define kAppId			@"492598483"					// To be changed for each project
#define kMobClickKey	@"4ef588a15270154623000019"		// To be changed for each project

#define MAKE_FRIEND_PLACEID @"GroupBuy"

@interface FootballScoreAppDelegate : PPApplication <UIApplicationDelegate, UITabBarControllerDelegate, MobClickDelegate, ScoreUpdateControllerDelegate,UserServiceDelegate> {
    
    UIWindow			*window;
    PPTabBarController	*tabBarController;
	CoreDataManager		*dataManager;	
        
    ReviewRequest           *reviewRequest;
    NSString                *dataForRegistration;
    MatchService            *matchService;
    RealtimeScoreController *matchController;
    RealtimeIndexController *realtimeIndexController;
    UIBackgroundTaskIdentifier backgroundTask;

    NetworkDetector *_networkDetector;
}

@property (nonatomic, retain) IBOutlet UIWindow				*window;
@property (nonatomic, retain) IBOutlet PPTabBarController	*tabBarController;
@property (nonatomic, retain) CoreDataManager				*dataManager;
@property (nonatomic, retain) ReviewRequest                 *reviewRequest;
@property (nonatomic, retain) MatchService                  *matchService;
@property (nonatomic, retain) RealtimeScoreController       *matchController;
@property (nonatomic, retain) RealtimeIndexController *realtimeIndexController;
@property (nonatomic, retain) OddsService                   *oddsService;
@property (nonatomic, retain) ScheduleService               *scheduleService;
@property (nonatomic, retain) RetryService                  *retryService;
@property (nonatomic, retain) UserService                   *userService;

- (UIViewController *)currentViewController;
- (void)commonLaunchActions:(BOOL)loadAllMatch;
- (void) setSeletedTabbarIndex:(NSInteger)index;
@end


enum
{
    TAB_REALTIME_SCORE = 1,
};
