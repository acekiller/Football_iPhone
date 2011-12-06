//
//  LeagueScheduleController.m
//  FootballScore
//
//  Created by Orange on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LeagueScheduleController.h"

enum {
    POINT_BUTTON_TAG = 20111206,
    SCHEDULE_BUTTON_TAG,
    RANG_QIU_BUTTON_TAG,
    DAXIAO_BUTTON_TAG,
    SHOOTER_RANKING_BUTTON_TAG,
    SEASON_SELECTION_BUTTON_TAG,
    ROUND_SELECTION_BUTTON_TAG    
};

@implementation LeagueScheduleController
@synthesize pointCommand;
@synthesize scheduleCommand;
@synthesize rangQiuCommand;
@synthesize daxiaoCommand;
@synthesize shooterRankingCommand;
@synthesize seasonCommand;
@synthesize roundCommand;
@synthesize pointButton;
@synthesize scheduleButton;
@synthesize rangQiuButton;
@synthesize daxiaoButton;
@synthesize shooterRankingButton;
@synthesize seasonSelectionButton;
@synthesize roundSelectionButton;

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
    [super viewDidLoad];
    [self.pointButton setTag:POINT_BUTTON_TAG];
    [self.scheduleButton setTag:SCHEDULE_BUTTON_TAG];
    [self.rangQiuButton setTag:RANG_QIU_BUTTON_TAG];
    [self.daxiaoButton setTag:DAXIAO_BUTTON_TAG];
    [self.shooterRankingButton setTag:SHOOTER_RANKING_BUTTON_TAG];
    [self.seasonSelectionButton setTag:SEASON_SELECTION_BUTTON_TAG];
    [self.roundSelectionButton setTag:ROUND_SELECTION_BUTTON_TAG];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPointButton:nil];
    [self setScheduleButton:nil];
    [self setRangQiuButton:nil];
    [self setDaxiaoButton:nil];
    [self setShooterRankingButton:nil];
    [self setSeasonSelectionButton:nil];
    [self setRoundSelectionButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setScoreCommand:(id<CommonCommandDelegate>)point 
               schedule:(id<CommonCommandDelegate>)schedule 
                rangQiu:(id<CommonCommandDelegate>)rangQiu 
                 daxiao:(id<CommonCommandDelegate>)daxiao 
         shooterRanking:(id<CommonCommandDelegate>)shooterRanking 
                 season:(id<CommonCommandDelegate>)season  
                  round:(id<CommonCommandDelegate>)round
{
    self.pointCommand = point;
    self.scheduleCommand = schedule;
    self.rangQiuCommand = rangQiu;
    self.daxiaoCommand = daxiao;
    self.shooterRankingCommand = shooterRanking;
    self.seasonCommand = season;
    self.roundCommand = round;
}

- (IBAction)buttonClick:(id)sender
{
    
}

- (void)dealloc {
    [pointButton release];
    [scheduleButton release];
    [rangQiuButton release];
    [daxiaoButton release];
    [shooterRankingButton release];
    [seasonSelectionButton release];
    [roundSelectionButton release];
    [super dealloc];
}
@end

@implementation Common_command


- (void)execute
{
    
}

@end
