//
//  CupScheduleController.m
//  FootballScore
//
//  Created by Orange on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CupScheduleController.h"
#import "LeagueController.h"
#import "FileUtil.h"
#import "LogUtil.h"
#import "LocaleConstants.h"
#import "TimeUtils.h"
#import "LanguageManager.h"
#import "League.h"
#import "CupMatchType.h"

#define WEB_VIEW_URL @"www/cupRepository.html"

enum {
    SEASON_SELECTOR = 0,
    MATCH_TYPE_SELECTOR
    };

@implementation CupScheduleController
@synthesize cupScheduleResultTitle;
@synthesize groupPointsButton;
@synthesize matchTypeSelectButton;
@synthesize dataWebView;
@synthesize matchResultButton;
@synthesize league;
@synthesize matchTypesList;
@synthesize currentCupMatchType;
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

- (void)initGroup
{
    [GlobalGetRepositoryService() getGroupInfo:0 leagueId:self.league.leagueId season:self.currentSeason Delegate:self];
}

- (void)getGroupInfoFinish:(NSArray *)GroupInfo
{
    self.matchTypesList = GroupInfo;
    for (CupMatchType* type in self.matchTypesList) {
        if ([type.isCurrentType isEqualToString:@"True"]) {
            [self.matchTypeSelectButton setTitle:type.matchTypeName forState:UIControlStateNormal];
            self.currentCupMatchType = type.matchTypeId;
        }
    }
    isGroupReady = YES;
    if (isWebViewReady) {
        //[self updateView];
    } 
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initGroup];
    [self buttonTagInit];
    [self initWebView];
    [self initBarButton];

    [self.dataWebView setHidden:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setDataWebView:nil];
    [self setMatchTypeSelectButton:nil];
    [self setGroupPointsButton:nil];
    [self setMatchResultButton:nil];
    [self setCupScheduleResultTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+ (void)showWithSuperController:(UIViewController*)superController League:(League*)league
{
    CupScheduleController* vc = [[CupScheduleController alloc] initWithLeague:league];
    [superController.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)dealloc {
    [dataWebView release];
    [matchTypeSelectButton release];
    [groupPointsButton release];
    [matchResultButton release];
    [cupScheduleResultTitle release];
    [super dealloc];
}

enum {
    MATCH_RESLUT_BUTTON_TAG = 20111209,
    GROUP_POINT_BUTTON_TAG,
    MATCH_TYPE_SELECT_BUTTON_TAG
};

- (void)buttonTagInit
{
    [self.matchResultButton setTag:MATCH_RESLUT_BUTTON_TAG];
    [self.groupPointsButton setTag:GROUP_POINT_BUTTON_TAG];
    [self.matchTypeSelectButton setTag:MATCH_TYPE_SELECT_BUTTON_TAG];
}

- (void)initWebView
{
    [self loadWebViewByHtml:WEB_VIEW_URL];
    //[self showActivityWithText:@"loading"];
}

- (void)initBarButton
{
    [self setNavigationLeftButton:FNS(@"返回") imageName:@"ss.png" action:@selector(clickBack:)];
    [self setNavigationRightButton:FNS(@"赛季") imageName:@"ss.png" action:@selector(selectSeason)];
}

- (void)updateButtonState:(id)sender
{
    UIButton* button = (UIButton*)sender;
    [button setSelected:YES];
}

- (void)updateMatchResult
{
    //    NSString *jsCode = [NSString stringWithFormat:@"displayMatchEvent(true, null, %d, \"%@\");",
    //                        [LanguageManager getLanguage], eventDataString];    
    NSString *jsCode = [NSString stringWithFormat:@"displayCupGroupResult(true, \"%@\", \"%@\", '%@', %d);", [self.league leagueId], self.currentSeason, self.currentCupMatchType, [LanguageManager getLanguage]];    
    PPDebug(@"<displayEvent> execute JS = %@",jsCode);    
    [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];    
    
    self.dataWebView.hidden = NO;    
    [self hideActivity];
}

- (void)updateGroupPoints
{
    //    NSString *jsCode = [NSString stringWithFormat:@"displayMatchEvent(true, null, %d, \"%@\");",
    //                        [LanguageManager getLanguage], eventDataString];    
    NSString *jsCode = [NSString stringWithFormat:@"displayCupGroupPoints(true, \"%@\", \"%@\", '%@', %d);", [self.league leagueId], self.currentSeason, self.currentCupMatchType, [LanguageManager getLanguage]];    
    PPDebug(@"<displayEvent> execute JS = %@",jsCode);    
    [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];    
    
    self.dataWebView.hidden = NO;    
    [self hideActivity];
}

- (void)updateScheduleResult
{
    //    NSString *jsCode = [NSString stringWithFormat:@"displayMatchEvent(true, null, %d, \"%@\");",
    //                        [LanguageManager getLanguage], eventDataString];    
    NSString *jsCode = [NSString stringWithFormat:@"displayCupScheduleResult(true, \"%@\", \"%@\", '%@', %d);", [self.league leagueId], self.currentSeason, self.currentCupMatchType, [LanguageManager getLanguage]];    
    PPDebug(@"<displayEvent> execute JS = %@",jsCode);    
    [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];    
    
    self.dataWebView.hidden = NO;    
    [self hideActivity];
}
 
// return the view is shown directly or not
- (BOOL)showMatchResult:(BOOL)needReload
{

   [self updateMatchResult];
    return YES;
}

- (BOOL)groupPoints:(BOOL)needReload
{
    
    [self updateGroupPoints];
    return YES;
}

- (BOOL)showScheduleResult:(BOOL)needReload
{
    
    [self updateScheduleResult];
    return YES;
}

- (void)trueShowWebView:(NSNumber*)needReloadValue
{
    BOOL needReload = [needReloadValue boolValue];
    switch (currentSelection) {
        case MATCH_RESLUT_BUTTON_TAG:
            [self showMatchResult:needReload];
            break;
            
        case GROUP_POINT_BUTTON_TAG:
            [self groupPoints:needReload];
            break;
        default:
            [self showScheduleResult:needReload];
            break;
    }
    
    [self hideActivity];
}


- (void)showWebView:(BOOL)needReload
{
    [self showActivityWithText:FNS(@"加载数据中....")];
    [self performSelector:@selector(trueShowWebView:) 
               withObject:[NSNumber numberWithBool:needReload] 
               afterDelay:0.0f];
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
    UIButton* button = (UIButton*)sender;
    int buttonTag = button.tag;
    [self handleClickButton:sender selection:buttonTag];
}

- (void)loadWebViewByHtml:(NSString*)html
{
    self.dataWebView.hidden = NO;
    
    NSURL* url = [FileUtil bundleURL:html];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    PPDebug(@"load webview url = %@", [request description]);
    if (request) {
        [self.dataWebView loadRequest:request];        
    }  
    
    [self showActivityWithText:FNS(@"加载中...")];
}

- (void)selectSeason
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

- (IBAction)showTypeSelectionActionSheet:(id)sender
{
    actionSheetIndex = MATCH_TYPE_SELECTOR;
    UIActionSheet* typeSelector = [[UIActionSheet alloc] initWithTitle:FNS(@"赛事类别选择") 
                                                                delegate:self 
                                                       cancelButtonTitle:nil
                                                  destructiveButtonTitle:nil 
                                                       otherButtonTitles:nil];
    for (CupMatchType* type in self.matchTypesList) {
        [typeSelector addButtonWithTitle:type.matchTypeName];
    }
    [typeSelector addButtonWithTitle:FNS(@"返回")];
    [typeSelector setCancelButtonIndex:[self.matchTypesList count]];
    [typeSelector showFromTabBar:self.tabBarController.tabBar];
    [typeSelector release];
}

- (void)didSelectSeason:(int)index
{
    [GlobalGetRepositoryService() getGroupInfo:[LanguageManager getLanguage] leagueId:self.league.leagueId season:[self.league.seasonList objectAtIndex:index] Delegate:self];
    self.currentSeason = [self.league.seasonList objectAtIndex:index];
}

- (void)didSelectMatchType:(int)index title:(NSString*)title
{
    CupMatchType* currentType = [self.matchTypesList objectAtIndex:index];
    self.currentCupMatchType = currentType.matchTypeId;
    [self.matchTypeSelectButton setTitle:title forState:UIControlStateNormal];
    [self updateView];
    
    
}

- (void)trueSelectButton:(NSNumber*)buttonIndexNumber
{   
    switch (actionSheetIndex) {
        case SEASON_SELECTOR: {
            [self didSelectSeason:[buttonIndexNumber intValue]];
        }
            break;
        case MATCH_TYPE_SELECTOR: {
            CupMatchType* type = [self.matchTypesList objectAtIndex:[buttonIndexNumber intValue]];
            NSString* title = type.matchTypeName;
            [self didSelectMatchType:[buttonIndexNumber intValue] title:title];
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
    [self showActivityWithText:FNS(@"加载中...")];
    [self performSelector:@selector(trueSelectButton:) 
               withObject:[NSNumber numberWithInt:buttonIndex] 
               afterDelay:0.5];
    
}


- (void)updateView
{
    NSString* title = self.matchTypeSelectButton.titleLabel.text;
    if ([title hasSuffix:@"组赛"]) {
        [self updateMatchResult];
        [self.matchResultButton setHidden:NO];
        [self.groupPointsButton setHidden:NO];
        [self.cupScheduleResultTitle setHidden:YES];
    } else {
        [self updateScheduleResult];
        [self.matchResultButton setHidden:YES];
        [self.groupPointsButton setHidden:YES];
        [self.cupScheduleResultTitle setHidden:NO];
    }
    
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
        [self updateView];
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

@end


