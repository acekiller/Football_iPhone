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
#import "LocaleConstants.h"
#import "League.h"

enum {
    POINT_BUTTON_TAG = 20111206,
    SCHEDULE_BUTTON_TAG,
    RANG_QIU_BUTTON_TAG,
    DAXIAO_BUTTON_TAG,
    SHOOTER_RANKING_BUTTON_TAG,
    SEASON_SELECTION_BUTTON_TAG,
    ROUND_SELECTION_BUTTON_TAG    
};

enum {
    SEASON_SELECTOR = 0,
    ROUNDS_SELECTOR
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
@synthesize currentSeason;

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
        self.currentSeason = [self.league.seasonList objectAtIndex:0];
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)initButtons
{
    [self setNavigationLeftButton:FNS(@"返回") imageName:@"ss.png" action:@selector(clickBack:)];
    [self setNavigationRightButton:FNS(@"赛季") imageName:@"ss.png" action:@selector(showSeasonSelectionActionSheet)];
    [self.pointButton setTag:POINT_BUTTON_TAG];
    [self.scheduleButton setTag:SCHEDULE_BUTTON_TAG];
    [self.rangQiuButton setTag:RANG_QIU_BUTTON_TAG];
    [self.daxiaoButton setTag:DAXIAO_BUTTON_TAG];
    [self.shooterRankingButton setTag:SHOOTER_RANKING_BUTTON_TAG];
    [self.seasonSelectionButton setTag:SEASON_SELECTION_BUTTON_TAG];
    [self.roundSelectionButton setTag:ROUND_SELECTION_BUTTON_TAG];
    
}

- (void)initTitle
{
    [self setTitle:[NSString stringWithFormat:@"%@%@", self.league.shortName, self.currentSeason]];
}

- (void)initWebView
{
    [self loadWebViewByHtml:@"www/repository.html"];
    //[self showActivityWithText:@"loading"];
}

- (void)updateRounds
{
    [GlobalGetRepositoryService() getRoundsCountWithLeagueId:self.league.leagueId season:self.currentSeason Delegate:self];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initButtons];
    [self initTitle];
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

- (void)setScoreCommand:(id<CommonCommandInterface>)command forKey:(int)Key
{
    if (buttonCommandsDict == nil) {
        buttonCommandsDict = [[NSMutableDictionary alloc] init];
    }
    [self.buttonCommandsDict setObject:command forKey:[NSNumber numberWithInt:Key]];
        
}

- (void)updateButtonState:(id)sender
{
    for (int i=POINT_BUTTON_TAG; i<=SHOOTER_RANKING_BUTTON_TAG; i++) {
        UIButton* button = (UIButton*)[self.view viewWithTag:i];
        UIButton* selectedButton = (UIButton*)sender;
        if (button.tag == selectedButton.tag) {
            [button setSelected:YES];
        } else {
            [button setSelected:NO];
        }
    }
}

- (void)updateDataWebViewState:(id)sender
{
    UIButton* button = (UIButton*)sender;
    if (button.tag == SCHEDULE_BUTTON_TAG) {
        [self.dataWebView setFrame:CGRectMake(0, 70, 320, 297)];
    } else {
        [self.dataWebView setFrame:CGRectMake(0, 37, 320, 330)];
    }
}

- (IBAction)buttonClick:(id)sender
{
    [self updateButtonState:(id)sender];
    [self updateDataWebViewState:(id)sender];
    id<CommonCommandInterface> command = [self.buttonCommandsDict objectForKey:[NSNumber numberWithInt:[sender tag]]];
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
    actionSheetIndex = SEASON_SELECTOR;
    UIActionSheet* seasonSelector = [[UIActionSheet alloc] initWithTitle:FNS(@"赛季选择") 
                                                                delegate:self 
                                                       cancelButtonTitle:nil 
                                                  destructiveButtonTitle:nil 
                                                       otherButtonTitles:nil];
    for (NSString* title in self.league.seasonList) {
        [seasonSelector addButtonWithTitle:title];
    }
    [seasonSelector addButtonWithTitle:FNS(@"返回")];
    [seasonSelector setCancelButtonIndex:[self.league.seasonList count]];
    [seasonSelector showFromTabBar:self.tabBarController.tabBar];
    [seasonSelector release];
}

- (IBAction)showRoundsSelectionActionSheet:(id)sender
{
    actionSheetIndex = ROUNDS_SELECTOR;
    UIActionSheet* roundsSelector = [[UIActionSheet alloc] initWithTitle:FNS(@"轮次选择") 
                                                                delegate:self 
                                                       cancelButtonTitle:nil 
                                                  destructiveButtonTitle:nil 
                                                       otherButtonTitles:nil];
    for (int i=1; i<=roundsCount; i++) {
        [roundsSelector addButtonWithTitle:[NSString stringWithFormat:@"第%d轮", i]];
    }
    [roundsSelector addButtonWithTitle:FNS(@"返回")];
    [roundsSelector setCancelButtonIndex:roundsCount];
    [roundsSelector showFromTabBar:self.tabBarController.tabBar];
    [roundsSelector release];
}

- (void)didSelectSeason:(int)index
{
    self.currentSeason = [self.league.seasonList objectAtIndex:index];
    [self setTitle:[NSString stringWithFormat:@"%@%@", self.league.shortName, self.currentSeason]];
    [self updateRounds];
}

- (void)trueSelectButton:(NSNumber*)buttonIndexNumber
{   
    switch (actionSheetIndex) {
        case SEASON_SELECTOR: {
            [self didSelectSeason:[buttonIndexNumber intValue]];
        }
            break;
        case ROUNDS_SELECTOR: {
            [self.roundSelectionButton setTitle:[NSString stringWithFormat:@"第%d轮", [buttonIndexNumber intValue]+1] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    //NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    //[self showActivityWithText:FNS(@"加载中...")];
    [self performSelector:@selector(trueSelectButton:) 
               withObject:[NSNumber numberWithInt:buttonIndex] 
               afterDelay:0.5];
    
}

- (void)setCommand
{
    
}

#pragma mark - UIWebViewDelegate

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
        [self setCommand];
        // this is the first time, so need reload
        return;
    }
    
    // if not, continue to detect
    [self detectAppLaunch];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{   
    NSLog(@"webViewDidStartLoad, isLoading=%d", webView.loading); 
    
    
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

#pragma mark -get rounds finish
- (void)getRoundsCountFinish:(NSArray*)roundsArray
{
    NSNumber* totalRoundCount = [roundsArray objectAtIndex:0];
    NSNumber* currentRountIndex = [roundsArray objectAtIndex:1];
    roundsCount = [totalRoundCount intValue];
    currentRound = [currentRountIndex intValue];
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
