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
#import "DetailHeader.h"
#import "PPApplication.h"
#import "MatchManager.h"
#import "MatchConstants.h"
#import "LogUtil.h"

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
@synthesize dataString;

@synthesize match;
@synthesize detailHeader;

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
    [dataString release];
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
    
    [detailHeader release];
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
    
    [self updateSelectMatchStatusButtonState:MATCH_DATA_STATUS_EVENT];
    
    
     

    [super viewDidLoad];
    
    //left  button 
    NSString * leftButtonName = @"ss.png";    
    [self setNavigationLeftButton:FNS(@"返回") imageName:leftButtonName action:@selector(clickBack:)];
    
    // right button
    NSString * rightButtonName = @"refresh.png";    
    [self setNavigationRightButton:nil imageName:rightButtonName action:@selector(clickReflashLeftButton)];    
    
    [self.navigationItem setTitle:FNS(@"赛事数据")];
    
 //   self.matchStateLabel.text = [DataUtils toMatchStatusString:self.match.status language:1];
 //   self.matchStarttimeLabel.text = dateToChineseStringByFormat(self.match.date, @"MM/dd hh:mm");
    
    
    
    [self showActivityWithText:FNS(@"加载数据中...")];
    
    [GlobalGetMatchService() getMatchDetailHeader:self matchId:match.matchId];    
    [GlobalGetMatchService() getMatchEvent:self matchId:match.matchId];

    self.dataWebView.hidden = YES;
    
    currentSelection = SELECT_EVENT;
    [self loadWebView];    
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
    
    [self setDetailHeader:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateSelectMatchStatusButtonState:(int)selectMatchStatus
{
    
    for (int i=MATCH_DATA_STATUS_EVENT; i<=MATCH_DATA_STATUS_SIZE; i++){
        UIButton* button = (UIButton*)[self.view viewWithTag:i];
        switch (i) {
            case MATCH_DATA_STATUS_EVENT:
            {
                if (i == selectMatchStatus) {
                     [button setSelected:YES];  
                     [button setBackgroundImage:[UIImage imageNamed:@"data_m_2.png"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                else{
                    [button setSelected:NO];
                    [button setBackgroundImage:[UIImage imageNamed:@"data_m_1.png"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }   
            }
                break;
            case MATCH_DATA_STATUS_LINEUP:
            {
                if (i == selectMatchStatus) {
                    [button setSelected:YES];  
                    [button setBackgroundImage:[UIImage imageNamed:@"data_m_2.png"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                }
                else{
                    [button setSelected:NO];
                    [button setBackgroundImage:[UIImage imageNamed:@"data_m_1.png"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }   
            }
                break; 
            case MATCH_DATA_STATUS_ANALYSIS:
            {
                if (i == selectMatchStatus) {
                     [button setSelected:YES];  
                    [button setBackgroundImage:[UIImage imageNamed:@"data_m_2.png"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                else{
                    [button setSelected:NO];
                    [button setBackgroundImage:[UIImage imageNamed:@"data_m_1.png"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }   
            }
                break; 
            case MATCH_DATA_STATUS_ASIANODDS:
            {
                if (i == selectMatchStatus) {
                     [button setSelected:YES];  
                    [button setBackgroundImage:[UIImage imageNamed:@"data_m_2.png"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                else{
                    [button setSelected:NO];
                    [button setBackgroundImage:[UIImage imageNamed:@"data_m_1.png"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }   
            }
                break; 
            case MATCH_DATA_STATUS_AUROPEANODDS:
            {
                if (i == selectMatchStatus) {
                    [button setSelected:YES];  
                    [button setBackgroundImage:[UIImage imageNamed:@"data_m_2.png"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                else{
                    [button setSelected:NO];
                    [button setBackgroundImage:[UIImage imageNamed:@"data_m_1.png"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }   
            }
                break; 
            case MATCH_DATA_STATUS_SIZE:
            {
                if (i == selectMatchStatus) {
                    [button setSelected:YES];  
                    [button setBackgroundImage:[UIImage imageNamed:@"data_m_2.png"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                else{
                    [button setSelected:NO];
                    [button setBackgroundImage:[UIImage imageNamed:@"data_m_1.png"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }   
            }
                break; 

                
                
            default:
                break;
        }
    }
}

- (void)loadOupeiData
{
    [GlobalGetMatchService() getMatchOupei:self matchId:match.matchId];
}

- (void)getMatchOupeiFinish:(int)result data:(NSString*)data
{
    [self hideActivity];
    showDataFinish = YES;
    
    if (result == 0){
        self.dataString = data;
        [self loadWebView];
    }
}

- (IBAction)clickMatchesDatasButton:(id)sender;
{        
    UIButton* button = (UIButton*)sender;
    int selectMatchStatus = button.tag;
    [self updateSelectMatchStatusButtonState:selectMatchStatus];
}

- (IBAction)clickMatchesOupeiButton:(id)sender
{
    UIButton* button = (UIButton*)sender;
    int selectMatchStatus = button.tag;
    [self updateSelectMatchStatusButtonState:selectMatchStatus];    
    
    currentSelection = SELECT_OUPEI;
    [self loadOupeiData];
}

-(void)clickReflashLeftButton{            
    
    
    
     NSLog(@"reflashing now ");
    
    
    
}

- (void)displayOupei:(NSString*)oupeiDataString
{
    
    NSString *jsCode = [NSString stringWithFormat:@"updateOupeiDetail(\"%@\");", oupeiDataString];      
    PPDebug(@"<displayOupei> execute java script = %@",jsCode);        
    [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];   
    [self hideActivity];
    self.dataWebView.hidden = NO;    

}

- (void)displayEvent
{
    NSString *jsCode = [NSString stringWithFormat:@"updateMatchDetail(\"%@\",\"%@\");",eventJsonArray,statJsonArray];
    
    PPDebug(@"<displayEvent> execute JS = %@",jsCode);
    
    [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];    
    self.dataWebView.hidden = NO;    
    [self hideActivity];
}

- (void)loadWebViewByHtml:(NSString*)html
{
    self.dataWebView.hidden = YES;
    loadCounter = 0;
    showDataFinish = NO;
    
    NSURL* url = [FileUtil bundleURL:html];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"load url = %@", [request description]);
    if (request) {
        [self.dataWebView loadRequest:request];        
    }        
}

- (void)loadWebView
{
    switch (currentSelection) {
        case SELECT_EVENT:
            [self loadWebViewByHtml:@"www/match_detail.html"];
            break;
            
        case SELECT_OUPEI:
            [self loadWebViewByHtml:@"www/oupei.html"];
            break;
            
        default:
            break;
    }    
}

- (void)displayWebView
{
    switch (currentSelection) {
        case SELECT_EVENT:
            [self displayEvent];
            break;
            
        case SELECT_OUPEI:
            [self displayOupei:dataString];
            break;
            
        default:
            break;
    }
}

- (void)showResult
{
    [self showActivityWithText:FNS(@"加载数据中...")];
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(displayWebView) userInfo:nil repeats:NO];
    
    showDataFinish = YES;
}

- (BOOL)isLoadFinish
{
    return (loadCounter >= 2);
}

- (void)getMatchEventFinish:(int)result match:(Match *)matchValue
{    
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


- (void) setHeaderInfo:(DetailHeader *)header
{
    
    self.matchStateLabel.text = [DataUtils toMatchStatusString:header.matchStatus language:1];

    NSDate *date = dateFromStringByFormat(header.matchDateString, DEFAULT_DATE_FORMAT);
    
    
    NSString *dateString = dateToStringByFormat(date, @"MM/dd HH:mm");
    
    if (date && dateString) {
        self.matchStarttimeLabel.text = [NSString stringWithFormat:@"[%@]",dateString];
    }else{
        self.matchStarttimeLabel.text = nil;
    }
    
    NSInteger lang = [LanguageManager getLanguage];
    
    //acoording to the language setting, show the team names.
    if (lang == LANG_CANTON) {
        self.homeTeamName.text = header.homeTeamYYName;
        self.awayTeamName.text = header.awayTeamYYName;
    }else{
        self.homeTeamName.text = header.homeTeamSCName;
        self.awayTeamName.text = header.awayTeamSCName;
    }
    
    if ([header.homeTeamRank length] > 0) {
        self.homeTeamRank.text = [NSString stringWithFormat:@"[%@]",header.homeTeamRank];
    }else{
        self.homeTeamRank.text = nil;
    }
    if ([header.awayTeamRank length] > 0) {
        self.awayTeamRank.text = [NSString stringWithFormat:@"[%@]",header.awayTeamRank];
    }else{
        self.awayTeamRank.text = nil;
    }
    
    [self.homeTeamIcon clear];
    self.homeTeamIcon.url = [NSURL URLWithString:header.homeTeamImage];
    [GlobalGetImageCache() manage:self.homeTeamIcon];
    
    [self.awayTeamIcon clear];
    
    self.awayTeamIcon.url = [NSURL URLWithString:header.awayTeamImage];
    [GlobalGetImageCache() manage:self.awayTeamIcon];    
    
}

- (void)getMatchDetailHeaderFinish:(NSArray*)headerInfo
{
    self.detailHeader = [[DetailHeader alloc] initWithDetailHeaderArray:headerInfo];
    [self setHeaderInfo:self.detailHeader];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{   
    NSLog(@"webViewDidStartLoad, isLoading=%d", webView.loading);  
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad, isLoading=%d", webView.loading);
    loadCounter ++;

    if ([self isLoadFinish] && showDataFinish == NO){
        [self showResult];
    }        
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}


@end
