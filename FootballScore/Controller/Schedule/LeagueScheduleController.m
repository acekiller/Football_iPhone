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

#define REPOSITORY_URL @"www/repository.html"
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
@synthesize currentRound = _currentRound;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        firstLoadWebView = YES;
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
        //dataWebView2 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 70, 320, 297)];
        //[self.dataWebView2 setHidden:YES];
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
    [self.roundSelectionButton setHidden:YES];
    
}

- (void)initTitle
{
    [self setTitle:[NSString stringWithFormat:@"%@%@", self.league.shortName, self.currentSeason]];
}

- (void)initWebView
{
    [self loadWebViewByHtml:REPOSITORY_URL];
    [self showActivityWithText:FNS(@"加载数据中...")];
}

- (void)resetWithLeague:(League *)leagueValue
{
    self.league = leagueValue;
    self.currentSeason = [self.league.seasonList objectAtIndex:0];
    [self initTitle];
    [self resetCommand];
    [self resetSelection];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initButtons];
    [self initTitle];
    [self initWebView];
    //[self.view addSubview:self.dataWebView2];
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
    [buttonCommandsDict release];
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
    [self.dataWebView setScalesPageToFit:YES];
    UIButton* button = (UIButton*)sender;
    if (button.tag == SCHEDULE_BUTTON_TAG) {
        [self.dataWebView setFrame:CGRectMake(0, 70, 320, 297)];
        [self.dataWebView setContentStretch:CGRectMake(0, 70, 320, 330)];
    } else {
        [self.dataWebView setFrame:CGRectMake(0, 37, 320, 330)];
        
    }
}

#define ROUND_SEGMENT_SEPARATOR @"$$"
#define TOTAL_ROUND_INDEX 0
#define CURRENT_ROUND_INDEX 1
- (void)showSchedule
{
    [self showActivityWithText:FNS(@"加载数据中...")];

    NSString* season = [self.league.seasonList objectAtIndex:0];
    NSString* jsCode;
    if ([currentSeason isEqualToString:season]) {
        jsCode = [NSString stringWithFormat:@"displaySchedule(true,\"%@\", \"%@\", '', %d)",self.league.leagueId, self.currentSeason, [LanguageManager getLanguage]];
    } else {
        jsCode = [NSString stringWithFormat:@"displaySchedule(true,\"%@\", \"%@\", 1, %d)",self.league.leagueId, self.currentSeason, [LanguageManager getLanguage]];
    }
    NSString* result = [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];
    PPDebug(@"<displayEvent>%@", jsCode);
    if (result) {
        NSArray* resultArray = [result componentsSeparatedByString:ROUND_SEGMENT_SEPARATOR];
        if (resultArray && [resultArray count] == 2) {
            NSString* roundsCountString = [resultArray objectAtIndex:TOTAL_ROUND_INDEX];
            NSString* currentRoundString = [resultArray objectAtIndex:CURRENT_ROUND_INDEX];
            roundsCount = [roundsCountString intValue];
            self.currentRound = [NSNumber numberWithInt:[currentRoundString intValue]];
            NSString *titleString = FNS(@"轮次");
            [self.roundSelectionButton setTitle:[NSString stringWithFormat:@"  %@:%d", titleString,[self.currentRound intValue]] forState:UIControlStateNormal];
        }
    }
    [self hideActivity];
}

- (void)trueClickButton:(UIButton*)sender
{
    
    [self updateButtonState:(id)sender];
    [self updateDataWebViewState:(id)sender];
    int i = [(UIButton*)sender tag];
    id<CommonCommandInterface> command = [self.buttonCommandsDict objectForKey:[NSNumber numberWithInt:i]];
    if (command) {
        [command execute];
    } else if ([sender tag ] == SEASON_SELECTION_BUTTON_TAG) {
        [self showSeasonSelectionActionSheet];
    }
    [self hideActivity];
}

- (IBAction)buttonClick:(id)sender
{
    [self performSelector:@selector(trueClickButton:) 
               withObject:(UIButton *)sender
               afterDelay:0];
    [self showActivityWithText:FNS(@"加载数据中...")];
}

- (IBAction)clickShowScheduleButton:(id)sender
{
    [self updateButtonState:(id)sender];
    [self updateDataWebViewState:(id)sender];
    [self.roundSelectionButton setHidden:NO];
    [self showSchedule];
    
}

- (void)resetSelection
{
    UIButton* button = (UIButton*)[self.view viewWithTag:POINT_BUTTON_TAG];
    [self trueClickButton:button];
    
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
        NSString *before = FNS(@"第");
        NSString *after = FNS(@"轮");
        [roundsSelector addButtonWithTitle:[NSString stringWithFormat:@"%@%d%@",before,i,after]];
    }
    [roundsSelector addButtonWithTitle:FNS(@"返回")];
    [roundsSelector setCancelButtonIndex:roundsCount];
    [roundsSelector showFromTabBar:self.tabBarController.tabBar];
    [roundsSelector release];
}

- (void)resetRound
{
    NSString* season = [self.league.seasonList objectAtIndex:0];
    if ([self.currentSeason isEqualToString:season]) {
        self.currentRound = nil;
    } else {
        self.currentRound = [NSNumber numberWithInt:1];
    }
}

- (void)didSelectSeason:(int)index
{
    self.currentSeason = [self.league.seasonList objectAtIndex:index];
    [self setTitle:[NSString stringWithFormat:@"%@%@", self.league.shortName, self.currentSeason]];
    [self resetCommand];
    [self resetRound];
    [self resetSelection];
    [self hideActivity];
}

- (void)didSelectRound:(int)roundIndex
{
    self.currentRound = [NSNumber numberWithInt:roundIndex+1];
    [self showSchedule];
    [self hideActivity];
}

- (void)trueSelectButton:(NSNumber*)buttonIndexNumber
{   
    switch (actionSheetIndex) {
        case SEASON_SELECTOR: {
            [self didSelectSeason:[buttonIndexNumber intValue]];
        }
            break;
        case ROUNDS_SELECTOR: {
            NSString *titleString = FNS(@"轮次");
            [self.roundSelectionButton setTitle:[NSString stringWithFormat:@"  %@:%d", titleString,[buttonIndexNumber intValue]+1] forState:UIControlStateNormal];
            [self didSelectRound:[buttonIndexNumber intValue]];
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
    [self performSelector:@selector(trueSelectButton:) 
               withObject:[NSNumber numberWithInt:buttonIndex] 
               afterDelay:0.0];
    [self showActivityWithText:FNS(@"加载数据中...")];
    
}

- (void)resetCommand
{
    [self.buttonCommandsDict removeAllObjects];
    JsCommand* shooter = [[JsCommand alloc] initWithJSCodeString:[NSString stringWithFormat:@"displayScorer(true,\"%@\", \"%@\", %d)",self.league.leagueId, self.currentSeason, [LanguageManager getLanguage]] dataWebView:self.dataWebView];
    JsCommand* points = [[JsCommand alloc] initWithJSCodeString:[NSString stringWithFormat:@"displayJifen(true,\"%@\", \"%@\", %d)",self.league.leagueId, self.currentSeason, [LanguageManager getLanguage]] dataWebView:self.dataWebView];
    JsCommand* schedule = [[JsCommand alloc] initWithJSCodeString:[NSString stringWithFormat:@"displaySchedule(true,\"%@\", \"%@\", '%d', %d)",self.league.leagueId, self.currentSeason, self.currentRound, [LanguageManager getLanguage]] dataWebView:self.dataWebView];
    JsCommand* rangQiu = [[JsCommand alloc] initWithJSCodeString:[NSString stringWithFormat:@"displayRangqiu(true,\"%@\", \"%@\", %d)",self.league.leagueId, self.currentSeason, [LanguageManager getLanguage]] dataWebView:self.dataWebView];
    JsCommand* daXiao = [[JsCommand alloc] initWithJSCodeString:[NSString stringWithFormat:@"displayDaxiao(true,\"%@\", \"%@\", %d)",self.league.leagueId, self.currentSeason, [LanguageManager getLanguage]] dataWebView:self.dataWebView];
    [self setScoreCommand:shooter forKey:SHOOTER_RANKING_BUTTON_TAG];
    [self setScoreCommand:points forKey:POINT_BUTTON_TAG];
    [self setScoreCommand:schedule forKey:SCHEDULE_BUTTON_TAG];
    [self setScoreCommand:rangQiu forKey:RANG_QIU_BUTTON_TAG];
    [self setScoreCommand:daXiao forKey:DAXIAO_BUTTON_TAG];
    [shooter release];
    [points release];
    [schedule release];
    [rangQiu release];
    [daXiao release];
    
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
        [self resetCommand];
        [self hideActivity];
        [self resetSelection];
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
@end

@implementation JsCommand
@synthesize jsCodeString;
@synthesize superControllerWebView;

- (NSString*)execute
{  
    NSString* string;
    PPDebug(@"<displayEvent> execute JS = %@",jsCodeString);    
    // change by Benson, no autorelease here
    string = [superControllerWebView stringByEvaluatingJavaScriptFromString:jsCodeString];  
    return string;
}

- (id)initWithJSCodeString:(NSString*)jsCode dataWebView:(UIWebView*)webView
{
    self = [super init];
    if (self) {
        self.superControllerWebView = webView;
        self.jsCodeString = jsCode;
    }
    return self;
}



@end
