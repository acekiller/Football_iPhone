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

#define MAX_TEAM_NAME_SIZE 7
#define MAX_TEAM_RANK_SIZE 5

#define WEBVIEW_CENTERPOINT CGPointMake(160, 280)


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
@synthesize oupeiString;
@synthesize eventString;

@synthesize match;
@synthesize detailHeader;
@synthesize scoreButton;
@synthesize defaultHomeTeamIcon;
@synthesize defaultAwayTeamIcon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        firstLoadWebView = YES;
    }
    return self;
}

-(id)initWithMatch:(Match *)aMatch
{
    self = [super init];
    if (self) {
        self.match = aMatch;
       // currentSelection = SELECT_EVENT;
        //currentSelection = -1;
    }
    return self;
}

- (void)initAMatch
{
        //score text
    self.matchStateLabel.text = [DataUtils toMatchStatusString:[self.match.status intValue]];
    NSInteger status = [self.match.status intValue];
    
    if (status == MATCH_STATUS_FIRST_HALF 
        || status == MATCH_STATUS_SECOND_HALF 
        || status == MATCH_STATUS_MIDDLE 
        || status == MATCH_STATUS_FINISH 
        || status == MATCH_STATUS_PAUSE) 
    {
        //score text
        NSString *title = [NSString stringWithFormat:@"%d : %d",self.match.homeTeamScore,self.match.awayTeamScore];
        [self.scoreButton setTitle:title forState:UIControlStateNormal];
        [self.scoreButton setImage:nil forState:UIControlStateNormal];
    }else{
        // vs image
        [self.scoreButton setImage:[UIImage imageNamed:@"vs.png"] forState:UIControlStateNormal];
        [self.scoreButton setTitle:nil forState:UIControlStateNormal];
    }
    //    [self.scoreButton setEnabled:NO];
    NSDate *date = self.match.date;
    NSString *dateString = dateToStringByFormat(date, @"MM/dd HH:mm");
    if (date && dateString) {
        self.matchStarttimeLabel.text = [NSString stringWithFormat:@"%@",dateString];
    }else{
        self.matchStarttimeLabel.text = nil;
    }
    
    //acoording to the language setting, show the team names.
    [self setTeamNameLable:self.homeTeamName name:self.match.homeTeamName];
    [self setTeamNameLable:self.awayTeamName name:self.match.awayTeamName];
 
}

- (void)resetWithMatch:(Match*)newMatch
{
    self.match = newMatch;
    self.eventString = nil;
    self.oupeiString = nil;
    [self initAMatch];
    [self setSelection];
    
    [self loadMatchDetailHeaderFromServer];
    [self showWebViewByClick:YES];
}

- (void)dealloc
{
    [eventString release];
    [oupeiString release];
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
    [scoreButton release];
    [defaultHomeTeamIcon release];
    [defaultAwayTeamIcon release];
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
    [self initAMatch];
    // set default select button for button_event
    [self setSelection];           

    // left button 
    NSString * leftButtonName = @"ss.png";    
    [self setNavigationLeftButton:FNS(@"返回") imageName:leftButtonName action:@selector(clickBack:)];
    
    // right button
    NSString * rightButtonName = @"refresh.png";    
    [self setNavigationRightButton:nil imageName:rightButtonName action:@selector(clickReflashLeftButton)];    
    
    // set title
    [self.navigationItem setTitle:FNS(@"赛事数据")];
    
    self.dataWebView.hidden = YES;
    [self initWebView];  
    
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [self.timer invalidate];    
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
//    if (self.timer){
//        [self.timer fire];
//    }
    
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self.timer invalidate];
    [self setTimer:nil];
    
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
    [self setScoreButton:nil];
    [self setDefaultHomeTeamIcon:nil];
    [self setDefaultAwayTeamIcon:nil];
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
    
    
    for ( int i=MATCH_DATA_STATUS_EVENT; i<=MATCH_DATA_STATUS_SIZE; i++){
        UIButton* button = (UIButton*)[self.view viewWithTag:i];
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
}

#pragma Ou Pei
#pragma mark - 

- (void)loadOupeiDataFromServer
{
    [self showActivityWithText:FNS(@"加载数据中...") withCenter:WEBVIEW_CENTERPOINT];
    [GlobalGetMatchService() getMatchOupei:self matchId:match.matchId];
}

- (void)getMatchOupeiFinish:(int)result data:(NSString*)data
{
    [self hideActivity];
    showDataFinish = YES;
    
    if (result == 0){
        self.oupeiString = data;
        if (currentSelection == SELECT_OUPEI){
            [self updateOupeiView:self.oupeiString];
        }
    }
}

- (void)updateOupeiView:(NSString*)oupeiDataString
{           
//    NSString *jsCode = [NSString stringWithFormat:@"displayOupeiDetail(true, null, %d, \"%@\");", [LanguageManager getLanguage], oupeiDataString];      

    NSString *jsCode = [NSString stringWithFormat:@"displayOupeiDetail(true, \"%@\", %d);",
                        match.matchId, [LanguageManager getLanguage]];    
    PPDebug(@"<displayOupei> execute java script = %@",jsCode);        
    [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];   

    [self hideActivity];
    self.dataWebView.hidden = NO;    
}

// return the view is shown directly or not
- (BOOL)showOupeiView:(BOOL)needReload
{
//    if (self.oupeiString == nil || needReload){
//        [self loadOupeiDataFromServer];
//        return NO;
//    }
    
    [self updateOupeiView:self.oupeiString];
    return YES;
}

- (void)updateYapeiView:(NSString*)dataString
{           
    NSString *jsCode = [NSString stringWithFormat:@"displayYapeiDetail(true, %@, %d);", 
                        match.matchId, [LanguageManager getLanguage]];      
    PPDebug(@"<updateYapeiView> execute java script = %@",jsCode);        
    [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];   
    
    [self hideActivity];
    self.dataWebView.hidden = NO;    
}

// return the view is shown directly or not
- (BOOL)showYapeiView:(BOOL)needReload
{
    [self updateYapeiView:nil];
    return YES;
}

- (void)updateOverunderView:(NSString*)dataString
{           
    NSString *jsCode = [NSString stringWithFormat:@"displayOverunder(true, %@, %d);", 
                        match.matchId, [LanguageManager getLanguage]];      
    PPDebug(@"<updateOverunderView> execute java script = %@",jsCode);        
    [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];   
    
    [self hideActivity];
    self.dataWebView.hidden = NO;    
}

// return the view is shown directly or not
- (BOOL)showOverunderView:(BOOL)needReload
{
    [self updateOverunderView:nil];
    return YES;
}

- (void)updateLineupView:(NSString*)dataString needReload:(BOOL)needReload
{           
    NSString *jsCode = [NSString stringWithFormat:@"displayLineup(true, %@, %d);", 
                        match.matchId, [LanguageManager getLanguage]];      
    PPDebug(@"<updateLineupView> execute java script = %@",jsCode);        
    [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];   
    
    [self hideActivity];
    self.dataWebView.hidden = NO;    
}

// return the view is shown directly or not
- (BOOL)showLineupView:(BOOL)needReload
{
    [self updateLineupView:nil needReload:needReload];
    return YES;
}

- (void)updateAnalysisView:(NSString*)dataString needReload:(BOOL)needReload
{           
    NSString *jsCode = [NSString stringWithFormat:@"displayAnalysis(true, %@, '%@', '%@', %d);", 
                        match.matchId, match.homeTeamName, match.awayTeamName, [LanguageManager getLanguage]];      
    PPDebug(@"<updateAnalysisView> execute java script = %@",jsCode);        
    [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];   
    
    [self hideActivity];
    self.dataWebView.hidden = NO;    
}

- (BOOL)showAnalysisView:(BOOL)needReload
{
    [self updateAnalysisView:nil needReload:needReload];
    return YES;
}

#pragma Event
#pragma mark - 

- (void)loadMatchEventFromServer
{
    [self showActivityWithText:FNS(@"加载数据中...") withCenter:WEBVIEW_CENTERPOINT];
    [GlobalGetMatchService() getMatchEvent:self matchId:match.matchId];    
}

- (void)getMatchEventFinish:(int)result data:(NSString *)data
{    
    [self hideActivity];
    if (result == 0) {                
        
        self.eventString = data;        
        if (currentSelection == SELECT_EVENT){
            [self updateEventView:self.eventString];
        }
    }
}

- (void)updateEventView:(NSString*)eventDataString
{
//    NSString *jsCode = [NSString stringWithFormat:@"displayMatchEvent(true, null, %d, \"%@\");",
//                        [LanguageManager getLanguage], eventDataString];    
    NSString *jsCode = [NSString stringWithFormat:@"displayMatchEvent(true, \"%@\", %d);",
                        match.matchId, [LanguageManager getLanguage]];    
    PPDebug(@"<displayEvent> execute JS = %@",jsCode);    
    [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];    
    
    self.dataWebView.hidden = NO;    
    [self hideActivity];
}

// return the view is shown directly or not
- (BOOL)showEventView:(BOOL)needReload
{
//    if (self.eventString == nil || needReload){
//        [self loadMatchEventFromServer];
//        return NO;
//    }
    
    [self updateEventView:self.eventString];
    return YES;
}

#pragma Header Methods
#pragma mark -

- (void)setTeamNameLable:(UILabel *)label name:(NSString *)name
{
    NSInteger length = MIN([name length],MAX_TEAM_NAME_SIZE);

    const CGFloat pxPerLetter = 14.0;
    [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, pxPerLetter * length, label.frame.size.height)];
    if (label == self.homeTeamName) {
        CGPoint point = CGPointMake(self.homeTeamIcon.center.x, label.center.y);
        [label setCenter:point];
    }else if(label == self.awayTeamName)
    {
        CGPoint point = CGPointMake(self.awayTeamIcon.center.x, label.center.y);
        [label setCenter:point];
    }
    [label setText:name];
}

- (void)setTeamRankLable:(UILabel *)label rank:(NSString *)rank
{
    NSInteger length = MIN([rank length], MAX_TEAM_RANK_SIZE);
    
    const CGFloat pxPerLetter = 9.0;
    if (label == self.homeTeamRank) {
        
        CGFloat x = self.homeTeamName.frame.origin.x + self.homeTeamName.frame.size.width+0.5;
        [label setFrame:CGRectMake(x , label.frame.origin.y, pxPerLetter * length, label.frame.size.height)];
        
    }else if(label == self.awayTeamRank)
    {
    
        CGFloat x = self.awayTeamName.frame.origin.x + self.awayTeamName.frame.size.width+0.5;
        [label setFrame:CGRectMake(x, label.frame.origin.y, pxPerLetter * length, label.frame.size.height)];
    }
    
    [label setText:rank];
}

- (void) setHeaderInfo:(DetailHeader *)header
{
    
    self.matchStateLabel.text = [DataUtils toMatchStatusString:header.matchStatus];
    NSInteger status = header.matchStatus;
    
    if (status == MATCH_STATUS_FIRST_HALF 
        || status == MATCH_STATUS_SECOND_HALF 
        || status == MATCH_STATUS_MIDDLE 
        || status == MATCH_STATUS_FINISH 
        || status == MATCH_STATUS_PAUSE) 
    {
        //score text
        NSString *title = [NSString stringWithFormat:@"%d : %d",header.homeTeamScore,header.awayTeamScore];
        [self.scoreButton setTitle:title forState:UIControlStateNormal];
        [self.scoreButton setImage:nil forState:UIControlStateNormal];
    }else{
        // vs image
        [self.scoreButton setImage:[UIImage imageNamed:@"vs.png"] forState:UIControlStateNormal];
        [self.scoreButton setTitle:nil forState:UIControlStateNormal];
    }
//    [self.scoreButton setEnabled:NO];
    NSDate *date = dateFromStringByFormat(header.matchDateString, DEFAULT_DATE_FORMAT);
    
    
    
    NSString *dateString = dateToStringByFormat(date, @"MM/dd HH:mm");
    
    if (date && dateString) {
        self.matchStarttimeLabel.text = [NSString stringWithFormat:@"%@",dateString];
    }else{
        self.matchStarttimeLabel.text = nil;
    }
    
    NSInteger lang = [LanguageManager getLanguage];
    
    //acoording to the language setting, show the team names.
    if (lang == LANG_CANTON) {
        [self setTeamNameLable:self.homeTeamName name:header.homeTeamYYName];
        [self setTeamNameLable:self.awayTeamName name:header.awayTeamYYName];
    }else{
        [self setTeamNameLable:self.homeTeamName name:header.homeTeamSCName];
        [self setTeamNameLable:self.awayTeamName name:header.awayTeamSCName];
    }


    if ([header.homeTeamRank length] > 0) {
        [self setTeamRankLable:self.homeTeamRank rank:[NSString stringWithFormat:@"[%@]",header.homeTeamRank]];
    }else{
        self.homeTeamRank.text = nil;
    }
    
    if ([header.awayTeamRank length] > 0) {
        [self setTeamRankLable:self.awayTeamRank rank:[NSString stringWithFormat:@"[%@]",header.awayTeamRank]];
    }else{
        self.awayTeamRank.text = nil;
    }
    
    [self.defaultHomeTeamIcon setHidden:NO];
    [self.defaultAwayTeamIcon setHidden:NO];
    
    [self.homeTeamIcon clear];
    [self.awayTeamIcon clear];
    self.homeTeamIcon.callbackOnSetImage = self;
    self.awayTeamIcon.callbackOnSetImage = self;
    
    self.homeTeamIcon.url = [NSURL URLWithString:header.homeTeamImage];
    [GlobalGetImageCache() manage:self.homeTeamIcon];
    self.awayTeamIcon.url = [NSURL URLWithString:header.awayTeamImage];
    [GlobalGetImageCache() manage:self.awayTeamIcon];    
    
}

- (void) managedImageSet:(HJManagedImageV*)mi
{
    if (mi == self.homeTeamIcon){
        // hide home team default icon
        [self.defaultHomeTeamIcon setHidden:YES];
    }else if(mi == self.awayTeamIcon){
        [self.defaultAwayTeamIcon setHidden:YES];
    }
}

- (void)loadMatchDetailHeaderFromServer
{
    [self showActivityWithText:FNS(@"加载数据中...") withCenter:WEBVIEW_CENTERPOINT];    
    [GlobalGetMatchService() getMatchDetailHeader:self matchId:match.matchId];  
}

- (void)getMatchDetailHeaderFinish:(NSArray*)headerInfo
{
    DetailHeader* header = [[DetailHeader alloc] initWithDetailHeaderArray:headerInfo];
    self.detailHeader = header;
    [self setHeaderInfo:self.detailHeader];
    [header release];
}

#pragma Web View Related & Web View Delegate
#pragma mark - 

- (void)trueShowWebView:(NSNumber*)needReloadValue
{
    BOOL needReload = [needReloadValue boolValue];
    switch (currentSelection) {
        case SELECT_EVENT:
            [self showEventView:needReload];
            break;
            
        case SELECT_OUPEI:
            [self showOupeiView:needReload];
            break;
            
        case SELECT_YAPEI:
            [self showYapeiView:needReload];
            break;
            
        case SELECT_DAXIAO:
            [self showOverunderView:needReload];
            break;
            
        case SELECT_LINEUP:
            [self showLineupView:needReload];
            break;
        case SELECT_ANALYSIS:
            [self showAnalysisView:needReload];
            break;
        default:
            break;
    }
    
    [self hideActivity];
}


- (void)showWebView:(BOOL)needReload
{
    [self showActivityWithText:FNS(@"加载数据中....")  withCenter:WEBVIEW_CENTERPOINT];
    [self performSelector:@selector(trueShowWebView:) 
               withObject:[NSNumber numberWithBool:needReload] 
               afterDelay:0.0f];
}

- (void)loadWebViewByHtml:(NSString*)html
{
    self.dataWebView.hidden = YES;
    loadCounter = 0;
    showDataFinish = NO;
    
    NSURL* url = [FileUtil bundleURL:html];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"load webview url = %@", [request description]);
    if (request) {
        [self.dataWebView loadRequest:request];        
    }        
}

- (BOOL)isAppLaunched
{
    NSString *jsCode = [NSString stringWithFormat:@"isAppLaunched();"];    
    PPDebug(@"<isAppLaunched> execute JS = %@",jsCode);    
    NSString* result = [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];
    NSLog(@"result = %@", result);
    if ([result intValue] == 1)
        return YES;
    else
        return NO;
}

- (void)initWebView
{
    [self showActivityWithText:FNS(@"加载数据中...") withCenter:WEBVIEW_CENTERPOINT];
    [self loadWebViewByHtml:@"www/match_detail.html"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{   
    NSLog(@"webViewDidStartLoad, isLoading=%d", webView.loading);  
    
}

- (void)detectAppLaunch
{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkAppLaunched) userInfo:nil repeats:NO];
}

- (void)checkAppLaunched
{
    if ([self isAppLaunched]){
        self.timer = nil;
        firstLoadWebView = NO;
        isWebViewReady = YES;
        
        [self showWebView:YES];        // this is the first time, so need reload
        return;
    }
    
    // if not, continue to detect
    [self detectAppLaunch];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad, isLoading=%d", webView.loading);
    loadCounter ++; 
    
    [self detectAppLaunch];    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"<webView> didFailLoadWithError, error=%@", [error description]);
}

#pragma Button Actions
#pragma mark -

- (void)updateButtonState:(UIButton*)button
{
    int selectMatchStatus = button.tag;
    [self updateSelectMatchStatusButtonState:selectMatchStatus];    
}

- (void)showWebViewByClick:(BOOL)needReload
{
    if (isWebViewReady){
        [self showWebView:needReload];
    }
}

- (void)handleClickButton:(id)sender selection:(int)newSelection
{
    if (currentSelection == newSelection)
        return;
    
    [self updateButtonState:sender];    
    currentSelection = newSelection;
    [self showWebViewByClick:NO];    
}

- (IBAction)clickMatchesDatasButton:(id)sender;
{       
    [self handleClickButton:sender selection:SELECT_EVENT];
}

- (IBAction)clickMatchesOupeiButton:(id)sender
{
    [self handleClickButton:sender selection:SELECT_OUPEI];
}

- (IBAction)clickSelectYapeiButton:(id)sender
{
    [self handleClickButton:sender selection:SELECT_YAPEI];
}

- (IBAction)clickSelectLineupButton:(id)sender
{
    [self handleClickButton:sender selection:SELECT_LINEUP];
}

- (IBAction)clickSelectAnalysisButton:(id)sender
{
    [self handleClickButton:sender selection:SELECT_ANALYSIS];    
}

- (IBAction)clickSelectDaxiaoButton:(id)sender
{
    [self handleClickButton:sender selection:SELECT_DAXIAO];
}

- (void)clickReflashLeftButton{            
    
    [self showWebViewByClick:YES];
    
    NSLog(@"reflashing now ");
     
}

- (void)clickBack:(id)sender
{
//    [self.dataWebView stopLoading];
//    self.dataWebView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setSelection
{
    switch ([match.status intValue]) {
        case MATCH_STATUS_NOT_STARTED:
        {
            currentSelection = SELECT_ANALYSIS;
            [self updateSelectMatchStatusButtonState:MATCH_DATA_STATUS_ANALYSIS]; 
        }
            break;
        case MATCH_STATUS_FIRST_HALF:
        case MATCH_STATUS_SECOND_HALF:
        case MATCH_STATUS_MIDDLE:
        case MATCH_STATUS_PAUSE:       
        case MATCH_STATUS_FINISH:
        case MATCH_STATUS_TBD:
        case MATCH_STATUS_KILL:
        case MATCH_STATUS_POSTPONE:
        case MATCH_STATUS_CANCEL:
        default:
        {
            currentSelection = SELECT_EVENT;
            [self updateSelectMatchStatusButtonState:MATCH_DATA_STATUS_EVENT];  
        }
            break;
            
    }

}

-(void) managedImageCancelled:(HJManagedImageV*)mi
{
    
}


@end
