//
//  MatchDetailController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MatchDetailController.h"
#import "DataUtils.h"
#import "TimeUtils.h"
#import "FileUtil.h"

@implementation MatchDetailController
@synthesize homeTeamIcon;
@synthesize awayTeamIcon;
@synthesize matchStateLabel;
@synthesize matchStarttimeLabel;
@synthesize homeTeamName;
@synthesize awayTeamName;
@synthesize homeTeamRank;
@synthesize awayTeamRank;
@synthesize eventButton;
@synthesize lineUpButton;
@synthesize analysisButton;
@synthesize asianOdds;
@synthesize auropeanOdds;
@synthesize sizeButton;
@synthesize dataWebView;
@synthesize match;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithMatch:(Match *)aMatch
{
    self = [super init];
    if (self) {
        self.match = aMatch;
    }
    return self;
}

- (void)dealloc
{
    [match release];
    [homeTeamIcon release];
    [awayTeamIcon release];
    [matchStateLabel release];
    [matchStarttimeLabel release];
    [homeTeamName release];
    [awayTeamName release];
    [homeTeamRank release];
    [awayTeamRank release];
    [eventButton release];
    [lineUpButton release];
    [analysisButton release];
    [asianOdds release];
    [auropeanOdds release];
    [sizeButton release];
    [dataWebView release];
    [super dealloc];
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
    [self setNavigationLeftButton:@"返回" action:@selector(clickBack:)];
    [self setNavigationRightButtonWithSystemStyle:UIBarButtonSystemItemRefresh action:@selector(clickBack:)];
    
    self.matchStateLabel.text = [DataUtils toMatchStatusString:self.match.status language:1];
    self.matchStarttimeLabel.text = dateToChineseStringByFormat(self.match.date, @"MM/dd hh:mm");
    [GlobalGetMatchService() getMatchEvent:self matchId:match.matchId];
    
    NSURL* url = [FileUtil bundleURL:@"www/match_detail.html"];
    NSLog(@"load url = %@", [url description]);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if (request) {
        [self.dataWebView loadRequest:request];
    }    
}

- (void)viewDidUnload
{
    [self setHomeTeamIcon:nil];
    [self setAwayTeamIcon:nil];
    [self setMatchStateLabel:nil];
    [self setMatchStarttimeLabel:nil];
    [self setHomeTeamName:nil];
    [self setAwayTeamName:nil];
    [self setHomeTeamRank:nil];
    [self setAwayTeamRank:nil];
    [self setEventButton:nil];
    [self setLineUpButton:nil];
    [self setAnalysisButton:nil];
    [self setAsianOdds:nil];
    [self setAuropeanOdds:nil];
    [self setSizeButton:nil];
    [self setDataWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)getMatchEventFinish:(int)result match:(Match *)match
{
    if (result == 0) {
        for (MatchEvent *event in match.events) {
            NSLog(@"event:%@",[event toString]);
        }
        for (MatchStat *stat in match.stats) {
            NSLog(@"Stat:%@",[stat toString]);
        }
      //  [self.dataWebView stringByEvaluatingJavaScriptFromString:@"document.write('testtest')"];
         //[self.dataWebView stringByEvaluatingJavaScriptFromString:@"alert(\"document.getElementById('event')\""];
       // [self.dataWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('ddd').value='test'"];
        
      //  [self.dataWebView stringByEvaluatingJavaScriptFromString:@"document.write('ddasdfadfsdf')"];
    }
}

@end
