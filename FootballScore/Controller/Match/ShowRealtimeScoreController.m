//
//  ShowRealtimeScoreController.m
//  FootballScore
//
//  Created by haodong qiu on 11-11-10.
//  Copyright (c) 2011年 orange. All rights reserved.
//

#import "ShowRealtimeScoreController.h"
#import "Match.h"
#import "LeagueManager.h"
#import "MatchManager.h"
#import "FootballScoreAppDelegate.h"

#define SHOW_REAL_TIME_SCORE_INTERVAL 10

ShowRealtimeScoreController* globalShowRealtimeScoreController;

@implementation ShowRealtimeScoreController

@synthesize leagueNameLabel;
@synthesize startTimeLabel;
@synthesize homeTeamLabel;
@synthesize awayTeamLabel;
@synthesize homeTeamEventLabel;
@synthesize awayTeamEventLabel;
@synthesize match;
@synthesize showTimer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //set color

    [self updateViewByMatch:nil];
    [super viewDidLoad];
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

- (void)removeFromSuperView
{
    if (self.view.superview){
        [self.view removeFromSuperview];
    }
}

//+ (void)show:(Match *)match
//{
//    FootballScoreAppDelegate *appDelegate = (FootballScoreAppDelegate *)[UIApplication sharedApplication].delegate;
//    UIViewController *controller = [appDelegate currentViewController];
//    UIView *view = [controller view];
//    if (view) {
//        [ShowRealtimeScoreController show:view match:match];
//    }
//    
//}

+ (void)show:(ScoreUpdate *)scoreUpdate
{
    FootballScoreAppDelegate *appDelegate = (FootballScoreAppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *controller = [appDelegate currentViewController];
    UIView *view = [controller view];
    if (view) {
        [ShowRealtimeScoreController show:view scoreUpdate:scoreUpdate];
    }
}

+ (void)show:(UIView*)superView scoreUpdate:(ScoreUpdate *)scoreUpdate
{
    
}

//+ (void)show:(UIView*)superView match:(Match*)match
//{
//    if (globalShowRealtimeScoreController == nil){
//        globalShowRealtimeScoreController = [[ShowRealtimeScoreController alloc] init];
//
//        // set position
//        CGRect rect = globalShowRealtimeScoreController.view.bounds;
//        rect.origin = CGPointMake(34, 314);
//        globalShowRealtimeScoreController.view.frame = rect;
//    }
//    
//    [globalShowRealtimeScoreController removeFromSuperView];
//    [superView addSubview:globalShowRealtimeScoreController.view];
//    
//    // set match
//    [globalShowRealtimeScoreController updateViewByMatch:match];    
//    
//    // schedule timer here 
//    [globalShowRealtimeScoreController createHideTimer];
//    
//        
//    return;
//}

- (void)dealloc
{
    [match release];
    [showTimer release];
    [super dealloc];
}

- (void)updateViewByMatch:(Match*)newMatch
{
    self.match = newMatch;
    
    UIColor *uicolor = [UIColor colorWithRed:(0x61)/255.0 
                                       green:(0x18)/255.0
                                        blue:(0x0A)/255.0
                                       alpha:1.0];
    leagueNameLabel.textColor = uicolor;
    startTimeLabel.textColor = uicolor;
    homeTeamLabel.textColor = uicolor;
    awayTeamLabel.textColor = uicolor;
    homeTeamEventLabel.textColor = uicolor;
    awayTeamEventLabel.textColor = uicolor;
    
    
    //set text
    leagueNameLabel.text = [[LeagueManager defaultManager] getNameById:match.leagueId];
    startTimeLabel.text = [[MatchManager defaultManager] matchMinutesString:match];
    homeTeamLabel.text = match.homeTeamName;
    awayTeamLabel.text = match.awayTeamName;
    homeTeamEventLabel.text = match.homeTeamScore;
    awayTeamEventLabel.text = match.awayTeamScore;
    
//    [self viewDidLoad];
}

- (void)createHideTimer
{
    [showTimer invalidate];
    self.showTimer = [NSTimer scheduledTimerWithTimeInterval:SHOW_REAL_TIME_SCORE_INTERVAL 
                                                  target:self
                                                  selector:@selector(cancelDisplay) 
                                                  userInfo:nil 
                                                  repeats:NO];
}

- (void)cancelDisplay
{
    [self removeFromSuperView];
}


@end
