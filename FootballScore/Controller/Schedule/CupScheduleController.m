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

#define WEB_VIEW_URL @"www/cupRepository.html"

@implementation CupScheduleController
@synthesize groupPointsButton;
@synthesize matchTypeSelectButton;
@synthesize dataWebView;
@synthesize matchResultButton;
@synthesize league;
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
    [self initWebView];
    [self initBarButton];
    [self.dataWebView stringByEvaluatingJavaScriptFromString:@"displayCupScheduleResult(true, \"67\", \"2006-2008\",\"1193\",'0');"];
    [self.dataWebView setHidden:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setDataWebView:nil];
    [self setMatchTypeSelectButton:nil];
    [self setGroupPointsButton:nil];
    [self setMatchResultButton:nil];
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
    NSString *jsCode = [NSString stringWithFormat:@"displayCupGroupResult(reload, \"%@\", \"%@\", '1193', %d);", [self.league leagueId], [self currentSeason], [LanguageManager getLanguage]];    
    PPDebug(@"<displayEvent> execute JS = %@",jsCode);    
    [self.dataWebView stringByEvaluatingJavaScriptFromString:jsCode];    
    
    self.dataWebView.hidden = NO;    
    [self hideActivity];
}

- (void)updateGroupPoints
{
    //    NSString *jsCode = [NSString stringWithFormat:@"displayMatchEvent(true, null, %d, \"%@\");",
    //                        [LanguageManager getLanguage], eventDataString];    
    NSString *jsCode = [NSString stringWithFormat:@"displayCupGroupPoints(reload, \"%@\", \"%@\", '1193', %d);", [self.league leagueId], [self currentSeason], [LanguageManager getLanguage]];    
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
}

#define SEASON_COUNT 5
- (void)selectSeason
{
    UIActionSheet* seasonSelector = [[UIActionSheet alloc] initWithTitle:FNS(@"类型选择") 
                                                                   delegate:self 
                                                          cancelButtonTitle:FNS(@"cancel") 
                                                     destructiveButtonTitle:nil 
                                                          otherButtonTitles:nil];
    for (int i=0; i<SEASON_COUNT; i++) {
        NSString* seasonTitle = [CupScheduleController creatSeasonByYearOffset:i];
        [seasonSelector addButtonWithTitle:seasonTitle];
    }
    [seasonSelector showFromTabBar:self.tabBarController.tabBar];
    [seasonSelector release];
}

- (IBAction)showTypeSelectionActionSheet:(id)sender
{
    UIActionSheet* matchTypeSelector = [[UIActionSheet alloc] initWithTitle:FNS(@"类型选择") 
                                                                   delegate:self 
                                                          cancelButtonTitle:FNS(@"cancel") 
                                                     destructiveButtonTitle:nil 
                                                          otherButtonTitles:FNS(@"分组赛"), FNS(@"十六强"), FNS(@"八强赛强"), FNS(@"准决赛"), FNS(@"决赛"), nil];
    [matchTypeSelector showFromTabBar:self.tabBarController.tabBar];
    [matchTypeSelector release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

+ (NSString *)creatSeasonByYearOffset:(int)offset
{
    NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString* thisYearString = dateToStringByFormat(nowDate, @"YYYY");
    int thisYearNum = [thisYearString intValue];
    
    return [NSString stringWithFormat:@"%d-%d", (thisYearNum-offset-1), (thisYearNum-offset)];
    
}


@end


