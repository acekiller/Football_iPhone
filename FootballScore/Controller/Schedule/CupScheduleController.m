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

@implementation CupScheduleController
@synthesize groupPointsButton;
@synthesize groupMatchButton;
@synthesize dataWebView;
@synthesize matchResultButton;
@synthesize league;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setDataWebView:nil];
    [self setGroupMatchButton:nil];
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
    [groupMatchButton release];
    [groupPointsButton release];
    [matchResultButton release];
    [super dealloc];
}

- (void)buttonTagInit
{

}

- (void)initWebView
{
    [self loadWebViewByHtml:@"www/repository.html"];
    [self showActivityWithText:@"loading"];
}


- (IBAction)buttonClick:(id)sender
{

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

- (void)setScoreCommand:(id<CommonCommandDelegate>)command forKey:(int)Key
{
    
}

- (void)showTypeSelectionActionSheet
{
    
}


@end


