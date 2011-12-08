//
//  LeagueScheduleController.m
//  FootballScore
//
//  Created by Orange on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LeagueScheduleController.h"
#import "LogUtil.h"
#import "FileUtil.h"
#import "LogUtil.h"

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
@synthesize dataWebView;
@synthesize buttonCommandsDict;
@synthesize pointButton;
@synthesize scheduleButton;
@synthesize rangQiuButton;
@synthesize daxiaoButton;
@synthesize shooterRankingButton;
@synthesize seasonSelectionButton;
@synthesize roundSelectionButton;
@synthesize league;
@synthesize loadCount;
@synthesize showDataFinished;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithLeague:(League*)leagueValue
{
    self = [super init];
    if (self) {
        self.league = leagueValue;
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
    [self buttonTagInit];
    [self initWebView];
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

- (void)dealloc {
    [pointButton release];
    [scheduleButton release];
    [rangQiuButton release];
    [daxiaoButton release];
    [shooterRankingButton release];
    [seasonSelectionButton release];
    [roundSelectionButton release];
    [dataWebView release];
    [super dealloc];
}

+ (void)showWithSuperController:(UIViewController*)superController League:(League*)league
{
    LeagueScheduleController* vc = [[LeagueScheduleController alloc] initWithLeague:league];
    [superController.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)buttonTagInit
{
    [self.pointButton setTag:POINT_BUTTON_TAG];
    [self.scheduleButton setTag:SCHEDULE_BUTTON_TAG];
    [self.rangQiuButton setTag:RANG_QIU_BUTTON_TAG];
    [self.daxiaoButton setTag:DAXIAO_BUTTON_TAG];
    [self.shooterRankingButton setTag:SHOOTER_RANKING_BUTTON_TAG];
    [self.seasonSelectionButton setTag:SEASON_SELECTION_BUTTON_TAG];
    [self.roundSelectionButton setTag:ROUND_SELECTION_BUTTON_TAG];
}

- (void)initWebView
{
    [self loadWebViewByHtml:@"www/repository.html"];
    [self showActivityWithText:@"loading"];
}

- (void)setScoreCommand:(id<CommonCommandDelegate>)command forKey:(int)Key
{
    if (buttonCommandsDict == nil) {
        buttonCommandsDict = [[NSMutableDictionary alloc] init];
    }
    [self.buttonCommandsDict setObject:command forKey:[NSNumber numberWithInt:Key]];
        
}

- (IBAction)buttonClick:(id)sender
{
    id<CommonCommandDelegate> command = [self.buttonCommandsDict objectForKey:[NSNumber numberWithInt:[sender tag]]];
    if (command) {
        [command execute];
    } else if ([sender tag ] == SEASON_SELECTION_BUTTON_TAG) {
        [self showSeasonSelectionActionSheet];
    }
    
}

- (void)loadWebViewByHtml:(NSString*)html
{
    self.dataWebView.hidden = NO;
    loadCount = 0;
    showDataFinished = NO;
    
    NSURL* url = [FileUtil bundleURL:html];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    PPDebug(@"load webview url = %@", [request description]);
    if (request) {
        [self.dataWebView loadRequest:request];        
    }        
}

- (void)showSeasonSelectionActionSheet
{
    
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad, isLoading=%d", webView.loading);
    loadCount ++; 
 
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"<webView> didFailLoadWithError, error=%@", [error description]);
}

@end

@implementation JsCommand


- (void)execute
{  
    PPDebug(@"<displayEvent> execute JS = %@",jsCodeString);    
    [superControllerWebView stringByEvaluatingJavaScriptFromString:jsCodeString];    
    
}

- (id)initWithJSCodeString:(NSString*)jsCode dataWebView:(UIWebView*)webView
{
    self = [super init];
    if (self) {
        superControllerWebView = webView;
        jsCodeString = jsCode;
    }
    return self;
}

@end
