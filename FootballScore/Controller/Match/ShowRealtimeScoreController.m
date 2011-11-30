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
#import "ScoreUpdate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LogUtil.h"

#define SHOW_REAL_TIME_SCORE_INTERVAL 10

ShowRealtimeScoreController* globalShowRealtimeScoreController;

@implementation ShowRealtimeScoreController

@synthesize leagueNameLabel;
@synthesize startTimeLabel;
@synthesize homeTeamLabel;
@synthesize awayTeamLabel;
@synthesize homeTeamEventLabel;
@synthesize awayTeamEventLabel;
@synthesize showTimer;
@synthesize scoreUpdate;
@synthesize player;


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

    [self updateViewByScoreUpdate:scoreUpdate];
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

+ (void)show:(ScoreUpdate *)scoreUpdate 
 isVibration:(BOOL)isVibration 
    hasSound:(BOOL)hasSound
{
    FootballScoreAppDelegate *appDelegate = (FootballScoreAppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *controller = [appDelegate currentViewController];
    UIView *view = [controller view];
    if (view) {
        [ShowRealtimeScoreController show:view 
                              scoreUpdate:scoreUpdate 
                              isVibration:isVibration
                                 hasSound:hasSound];
    }
    
}

+ (void)show:(UIView*)superView 
 scoreUpdate:(ScoreUpdate *)newScoreUpdate
 isVibration:(BOOL)isVibration 
    hasSound:(BOOL)hasSound
{
    if (globalShowRealtimeScoreController == nil){
        globalShowRealtimeScoreController = [[ShowRealtimeScoreController alloc] init];

        // set position
        CGRect rect = globalShowRealtimeScoreController.view.bounds;
        rect.origin = CGPointMake(34, 314);
        globalShowRealtimeScoreController.view.frame = rect;
    }
    [globalShowRealtimeScoreController removeFromSuperView];
    [superView addSubview:globalShowRealtimeScoreController.view];
    
    // set scoreUpdate
    [globalShowRealtimeScoreController updateViewByScoreUpdate:newScoreUpdate];    
    
    // schedule timer here 
    [globalShowRealtimeScoreController createHideTimer];
    
    if (isVibration) {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
    if (hasSound)
    {
        [globalShowRealtimeScoreController playeSound:@"goals_sound.wav"];
    }
}

- (void)dealloc
{   [leagueNameLabel release];
    [startTimeLabel release];
    [homeTeamLabel release];
    [awayTeamLabel release];
    [homeTeamEventLabel release];
    [awayTeamEventLabel release];
    [showTimer release];
    [scoreUpdate release];
    [player release];
    [super dealloc];
}

- (void)updateViewByScoreUpdate:(ScoreUpdate *)newScoreUpdate
{
    self.scoreUpdate = newScoreUpdate;
    
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
    
    if (newScoreUpdate.scoreUpdateType == HOMETEAMSCORE)
    {
        homeTeamEventLabel.textColor = [UIColor colorWithRed:(0xFF)/255.0 
                                                       green:(0x33)/255.0
                                                        blue:(0x00)/255.0
                                                       alpha:1.0];
    }
    else if (newScoreUpdate.scoreUpdateType == AWAYTEAMSCORE)
    {
        awayTeamEventLabel.textColor = [UIColor colorWithRed:(0xFF)/255.0 
                                                       green:(0x33)/255.0
                                                        blue:(0x00)/255.0
                                                       alpha:1.0];
    }
    
    leagueNameLabel.text = [[LeagueManager defaultManager] getNameById:scoreUpdate.match.leagueId];
    startTimeLabel.text = [[MatchManager defaultManager] matchMinutesString:scoreUpdate.match];
    homeTeamLabel.text = scoreUpdate.match.homeTeamName;
    awayTeamLabel.text = scoreUpdate.match.awayTeamName;
    homeTeamEventLabel.text = scoreUpdate.match.homeTeamScore;
    awayTeamEventLabel.text = scoreUpdate.match.awayTeamScore;
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

- (void)playeSound:(NSString*)soundFile
{
    NSURL  *soundUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle]  resourcePath] , soundFile]];
    NSError  *error;
    self.player = [[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error] autorelease];
    
	if (!error){
		[player prepareToPlay];
	}
	else {
		PPDebug(@"Fail to init audio player , error = %d",error.code);
	}
    
    [player play];
}

@end
