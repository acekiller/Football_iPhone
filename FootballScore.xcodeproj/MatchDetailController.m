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
#import "LocaleConstants.h"

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
@synthesize eventJsonArray;
@synthesize statJsonArray;

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
    [eventJsonArray release];
    [statJsonArray release];
    
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
    
    [self setNavigationLeftButton:FNS(@"返回") action:@selector(clickBack:)];
    [self setNavigationRightButtonWithSystemStyle:UIBarButtonSystemItemRefresh action:@selector(clickBack:)];
    
    self.matchStateLabel.text = [DataUtils toMatchStatusString:self.match.status language:1];
    self.matchStarttimeLabel.text = dateToChineseStringByFormat(self.match.date, @"MM/dd hh:mm");
    
    [self showActivityWithText:FNS(@"加载数据中...")];
    [GlobalGetMatchService() getMatchEvent:self matchId:match.matchId];

    NSURL* url1 = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURL* url = [FileUtil bundleURL:@"www/match_detail.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"load url = %@", [request description]);
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

- (void)displayTimer
{
    NSString *jsCode = [NSString stringWithFormat:@"updateMatchDetail(\"%@\",\"%@\");",eventJsonArray,statJsonArray];
    NSLog(@"jsCode = %@",jsCode);
    [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];    
    
    [self hideActivity];
}

- (void)showResult
{
    [self showActivityWithText:@"加载数据中..."];
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(displayTimer) userInfo:nil repeats:NO];
    
    showDataFinish = YES;
}

- (BOOL)isLoadFinish
{
    return (loadCounter >= 2);
}

- (void)getMatchEventFinish:(int)result match:(Match *)matchValue
{    
    [self hideActivity];
    
    if (result == 0) {
        NSMutableArray *eventArray = [NSMutableArray arrayWithCapacity:[matchValue.events count]];
        NSMutableArray *statArray = [NSMutableArray arrayWithCapacity:[matchValue.stats count]];
        
        for (MatchEvent *event in matchValue.events) {
            [eventArray addObject:[event toJsonString]];
        }
        for (MatchStat *stat in matchValue.stats) {
            [statArray addObject:[stat toJsonString]];
        }
        
        self.eventJsonArray = [eventArray componentsJoinedByString:@", "];
        self.statJsonArray = [statArray componentsJoinedByString:@", "];

        self.eventJsonArray = [NSString stringWithFormat:@"[%@]",eventJsonArray];
        self.statJsonArray = [NSString stringWithFormat:@"[%@]",statJsonArray];
        
        if ([self isLoadFinish]){
            [self showResult];
        }
        
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
   
    NSLog(@"webViewDidStartLoad, isLoading=%d", webView.loading);  
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad, isLoading=%d", webView.loading);
    loadCounter ++;

    if ([self isLoadFinish] && showDataFinish == NO && (eventJsonArray || statJsonArray)){
        [self showResult];
    }        
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}



@end
