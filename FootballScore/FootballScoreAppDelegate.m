//
//  FootballScoreAppDelegate.m
//  Dipan
//
//  Created by qqn_pipi on 11-4-30.
//  Copyright QQN-PIPI.com 2011. All rights reserved.
//

/*
 
 ReleaseNotes   : 1.1
 
    － 解决了反馈乱码问题
    － 解决了指数显示负数不正确的问题
 
 */

#import "FootballScoreAppDelegate.h"
#import "UIUtils.h"
#import "LocaleConstants.h"
#import "ReviewRequest.h"
#import "PPTabBarController.h"
#import "UINavigationBarExt.h"
#import "DeviceDetection.h"

#import "FootballNetworkRequest.h"

#import "MatchService.h"

// optional header files
#import "PPViewController.h"

// entry controllers
#import "ScoreUpdateController.h"
#import "RealtimeScoreController.h"
#import "RealtimeIndexController.h"
#import "RepositoryController.h"
#import "MoreController.h"
#import "MatchManager.h"
#import "UserManager.h"
#import "OddsService.h"
#import "UserService.h"
#import "RetryService.h"
#import "ScheduleService.h"

#import "NetworkDetector.h"

#import "ConfigManager.h"

#define kDbFileName			@"FootballDB"
#define MATCH_SELECT_STATUS_MYFOLLOW 15



NSString* GlobalGetServerURL()
{
    
    return @"http://192.168.1.101:8000/api/i?";
    //    return @"http://www.dipan100.com:8000/api/i?";
    
}

//AppService* GlobalGetAppService()
//{
//    FootballScoreAppDelegate* delegate = (FootballScoreAppDelegate*)[[UIApplication sharedApplication] delegate];    
//    return [delegate appService];            
//}

NSString* GlobalGetPlaceAppId()
{
    return @"FOOTBALL";
}

MatchService *GlobalGetMatchService()
{
    FootballScoreAppDelegate* delegate = (FootballScoreAppDelegate*)[[UIApplication sharedApplication] delegate];    
    return [delegate matchService];                
}
OddsService *GlobalGetOddsService()
{
    FootballScoreAppDelegate* delegate = (FootballScoreAppDelegate*)[[UIApplication sharedApplication] delegate];    
    return [delegate oddsService];                
}
ScheduleService *GlobalGetScheduleService()
{
    FootballScoreAppDelegate* delegate = (FootballScoreAppDelegate*)[[UIApplication sharedApplication] delegate];    
    return [delegate scheduleService];                
}
@implementation FootballScoreAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize dataManager;
@synthesize reviewRequest;
@synthesize matchService;
@synthesize matchController;
@synthesize oddsService;
@synthesize scheduleService;
@synthesize retryService;
@synthesize userService;
@synthesize realtimeIndexController;
#pragma mark -
#pragma mark Application lifecycle





- (void)initTabViewControllers
{
    tabBarController.delegate = self;
    
	NSMutableArray* controllers = [[NSMutableArray alloc] init];
    
	ScoreUpdateController* scoreUpdateController = (ScoreUpdateController*)
        [UIUtils addViewController:[[ScoreUpdateController alloc]
                  initWithDelegate:self]
					 viewTitle:FNS(@"比分动态")
					 viewImage:@"b_menu_1.png"
			  hasNavController:YES			
			   viewControllers:controllers];

    
    
	self.matchController = (RealtimeScoreController*)
            [UIUtils addViewController:[RealtimeScoreController alloc]
                             viewTitle:FNS(@"即时比分")
                             viewImage:@"b_menu_2.png"
                      hasNavController:YES			
                       viewControllers:controllers];	
    
    [matchService setMatchControllerDelegate:self.matchController];    
    [matchService setScoreUpdateControllerDelegate:scoreUpdateController];
    
	self.realtimeIndexController = (RealtimeIndexController *)
    [UIUtils addViewController:[RealtimeIndexController alloc]
					 viewTitle:FNS(@"即时指数")				 
					 viewImage:@"b_menu_3.png"
			  hasNavController:YES			
			   viewControllers:controllers];	
	
	[UIUtils addViewController:[RepositoryController alloc]
					 viewTitle:FNS(@"资料库")
					 viewImage:@"b_menu_4.png"
			  hasNavController:YES			
			   viewControllers:controllers];	

	[UIUtils addViewController:[MoreController alloc]
					 viewTitle:FNS(@"更多")
					 viewImage:@"b_menu_5.png"
			  hasNavController:YES			
			   viewControllers:controllers];	
    
    [self.tabBarController setSelectedImageArray:[NSArray arrayWithObjects:
                                                  @"b_menu_1s.png", 
                                                  @"b_menu_2s.png", 
                                                  @"b_menu_3s.png", 
                                                  @"b_menu_4s.png", 
                                                  @"b_menu_5s.png", nil]];
    
	tabBarController.viewControllers = controllers;
    tabBarController.selectedIndex = TAB_REALTIME_SCORE;
    
	[controllers release];
}

- (void)initMobClick
{
    [MobClick setDelegate:self reportPolicy:BATCH];
}

//- (void)initAppService
//{
//    self.appService = [[AppService alloc] init];
//}

- (void)initMatchService
{
    matchService = [[MatchService alloc] init];
}

- (void)initOddsSerivce
{
    oddsService = [[OddsService alloc] init];
}

- (void)initScheduleService
{
    scheduleService = [[ScheduleService alloc] init];
}

- (void)initRetryService
{
    retryService = [[RetryService alloc] init];
}

- (void)initNetworkDetector
{
    _networkDetector = [[NetworkDetector alloc] 
                        initWithErrorMsg:FNS(@"应用检测到无法连接到互联网，请检查您的网络连接设置。") 
                        detectInterval:2];
    [_networkDetector start];
}

- (void)initUserService
{
    userService = [[UserService alloc] init];
}

- (void)userRegister
{
    if (![UserManager isUserExisted]) {        
        [userService userRegisterByToken:[self getDeviceToken]];
    }
    else {
        NSLog(@"User exist,User ID is <%@>, Skip Registration",[UserManager getUserId]);
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	NSLog(@"Application starts, launch option = %@", [launchOptions description]);	
    
    // set autolocking screen by configuration
	[UIApplication sharedApplication].idleTimerDisabled = ![ConfigManager getIsLockScreen];
	
    // Init Core Data
	self.dataManager = [[CoreDataManager alloc] initWithDBName:kDbFileName dataModelName:nil];
    workingQueue = dispatch_queue_create("main working queue", NULL);    
            
    if ([DeviceDetection isOS5]){
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_live.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else{
        GlobalSetNavBarBackground(@"top_live.png");        
    }
    
    [tabBarController setBarBackground:@"bottom_bg.png"];    

    // init all service 
    [self initUserService];
    [self initMatchService];
    [self initOddsSerivce];
    [self initScheduleService];
    [self initRetryService];        

	[self initMobClick];
    [self initImageCacheManager];    
    [self initTabViewControllers];
    
    [self initNetworkDetector];
    
    
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
	
    // update config data
    //[appService startAppUpdate];
    
	// Ask For Review
	// self.reviewRequest = [ReviewRequest startReviewRequest:kAppId appName:GlobalGetAppName() isTest:NO];
    
    if (![self isPushNotificationEnable]){
        [self bindDevice];
    }
    
    
    [userService getVersion:self];
    
    
	[self commonLaunchActions:NO];    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	NSLog(@"applicationWillResignActive");	
	[MobClick appTerminated];
    
}

- (void)stopAudioPlayer
{
	if (player && [player isPlaying]){
		[player stop];
	}	
}

- (void)cleanUpDeleteData
{
//    int timeStamp = time(0) - 3600; // before 1 hour
//    [ProductManager cleanData:timeStamp];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	
	NSLog(@"applicationDidEnterBackground");	
	[UIApplication sharedApplication].idleTimerDisabled = NO;

    //stop the
    [[MatchManager defaultManager] saveFollowMatchList];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self stopAudioPlayer];
    [_networkDetector stop];
    backgroundTask = [application beginBackgroundTaskWithExpirationHandler: ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (UIBackgroundTaskInvalid != backgroundTask) {
                [application endBackgroundTask:backgroundTask];
                backgroundTask = UIBackgroundTaskInvalid;
                NSLog(@"application stop update data");
                [self.matchService stopAllUpdates];	
                [oddsService stopGetRealtimOddsTimer];
                [[MatchManager defaultManager] saveFollowMatchList];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        });
    }];
    
    NSLog(@"Background Task Remaining Time = %f", [application backgroundTimeRemaining]);
    if (UIBackgroundTaskInvalid != backgroundTask) {
        [self cleanUpDeleteData];
    }		
}

- (void)commonLaunchActions:(BOOL)loadAllMatch
{
    // clear badge while launching
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;    
    
    // register user if needed
    [self userRegister];    
    
    [self.oddsService updateAllBetCompanyList];
    
    int matchFilterStatus = [[MatchManager defaultManager] filterMatchStatus];
    int matchScoreType = [[MatchManager defaultManager] filterMatchScoreType];
    if (matchFilterStatus != MATCH_SELECT_STATUS_MYFOLLOW) {
        if (loadAllMatch){
            // update all match by given match score type
            [self.matchService startAllUpdates:self.matchController matchScoreType:matchScoreType];
            
            // TODO : also update all index data //done
            [self.oddsService startGetRealtimOddsTimer:realtimeIndexController.oddsType delegate:realtimeIndexController];
        }
        //fix the bug that when return to foreground,the score type button do not show correctly
        [self.matchController setMatchScoreType:matchScoreType];
        [self.matchController resetScoreButtonTitle];
	}

    // update follow match
    [self.matchService updateLatestFollowMatch];

    // MobClick, for statistic
    [MobClick appLaunched];    
    
    // start to update score
    [self.matchService startRealtimeMatchUpdate];
    
    // TODO : start to update realtime index timer   //done
    [self.oddsService getRealtimeOdds];

    // retry to send follow/unfollow match request
    [self.retryService retryFollowUnfollowList:[UserManager getUserId]];
    [self.retryService retryPushSet:[UserManager getUserId] token:[self getDeviceToken]];
    
    // forbid locking the screen
    [UIApplication sharedApplication].idleTimerDisabled = ![ConfigManager getIsLockScreen];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	NSLog(@"applicationWillEnterForeground");	
    
    [self commonLaunchActions:YES];
    [_networkDetector start];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	
	NSLog(@"applicationDidBecomeActive");	
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    
	NSLog(@"applicationWillTerminate");	
	
	[MobClick appTerminated];
}

#pragma mark Local Notification Handler

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {		
    
	NSLog(@"didReceiveLocalNotification, application state is %d", app.applicationState);	
	if (app.applicationState == UIApplicationStateActive){		
		// if application is in active state, simulate to popup an alert box
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GlobalGetAppName() 
															message:notif.alertBody 
														   delegate:self 
												  cancelButtonTitle:NSLS(@"Close") 
												  otherButtonTitles:notif.alertAction, nil];
		[alertView show];
		[alertView release];
	}
	else {		
		// TO DO, And Local Notification Handling Code Here
	}	
}

#pragma mark -
#pragma mark UITabBarControllerDelegate methods

- (void)tabBarController:(UITabBarController *)tc didSelectViewController:(UIViewController *)viewController 
{
}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed 
{    
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	
	// release UI objects
    [tabBarController release];
    [window release];
	
	// release data objects
	[dataManager release];
    [dataForRegistration release];
    [reviewRequest release];
    [matchService release];
	[matchController release];
    [oddsService release];
    [scheduleService release];
    [retryService release];
    [realtimeIndexController release];

    [super dealloc];
}

#pragma mark Mob Click Delegates

- (NSString *)appKey
{
	return kMobClickKey;	// shall be changed for each application
}

#pragma mark -
#pragma mark Device Notification Delegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	
//    // Get a hex string from the device token with no spaces or < >	
	[self saveDeviceToken:deviceToken];    
    //TODO post the device token to the server.
        
    // user already register
    [userService updateUserPushInfo:[UserManager getUserId] pushType:1 token:[self getDeviceToken]];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
	NSString *message = [error localizedDescription];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"错误"
													message: message
                                                   delegate: nil
                                          cancelButtonTitle: @"确认"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
	
	// try again
	// [self bindDevice];
}

- (void)showNotification:(NSDictionary*)payload
{
	NSDictionary *dict = [[payload objectForKey:@"aps"] objectForKey:@"alert"];
	NSString* msg = [dict valueForKey:@"loc-key"];
	NSArray*  args = [dict objectForKey:@"loc-args"];
	
	if (args != nil && [args count] >= 2){
		NSString* from = nil; //[args objectAtIndex:0];
		NSString* text = nil; //[args objectAtIndex:1];		
		[UIUtils alert:[NSString stringWithFormat:NSLS(msg), from, text]];
	}	
}

- (void)playNotificationSound
{
	if (self.player == nil){
		[self initAudioPlayer:@"Voicemail"];
	}
	
	if ([self.player isPlaying]){
		[self.player stop];
	}
	
	[self.player play];	
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	NSDictionary *payload = userInfo;
    
#ifdef DEBUG    
	NSLog(@"receive push notification, payload=%@", [payload description]);
#endif
    
	if (nil != payload) {        
//        NSString *itemId = [[payload objectForKey:@"aps"] valueForKey:@"ii"];				        
	}	
}

-(void) updateScoreMessageCount:(NSInteger)count
{
   // [self.tabBarController setBadgeValue:[NSString stringWithFormat:@"%d", count] buttonTag:0];
    
}

- (UIViewController *)currentViewController
{
    UINavigationController *vc = [self.tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex];
    return [vc visibleViewController];
}

- (void) setSeletedTabbarIndex:(NSInteger)index
{
    UIButton *button = [tabBarController.buttons objectAtIndex:index];
    [tabBarController selectedTab:button];
}


#pragma mark -
#pragma mark user UserService Delegate
- (void)getVersionFinish:(int)result data:(NSString*)data
{
    if (0 == result) 
    {
        NSString *latestVersion = data;
        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if (![latestVersion isEqualToString:localVersion]) 
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                           message:FNS(@"检测到有新版本,是否更新?") 
                                                          delegate:self 
                                                 cancelButtonTitle:FNS(@"否")  
                                                 otherButtonTitles:FNS(@"是") , nil];
            [alert show];
            [alert release];
        }
    }
}

#pragma mark -
#pragma mark user alertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [UIUtils openApp:kAppId];  //跳到更新页面;
            break;
        default:
            break;
    }
}

@end

