//
//  ScoreUpdateController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ScoreUpdateController.h"
#import "SelectMatchTypeController.h"
#import "SelectLeagueController.h"
#import "LocaleConstants.h"

@implementation ScoreUpdateController
@synthesize statusText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)selectMatchType:(id)sender
{
    SelectMatchTypeController* vc = [[SelectMatchTypeController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

-(IBAction)selectLeague:(id)sender{
//    SelectLeagueController *leagueController = [[SelectLeagueController alloc] init];
//    [self.navigationController pushViewController:leagueController animated:YES];
//    [leagueController release];

    SelectLeagueController* vc = [[SelectLeagueController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction) showActionSheet: (id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:FNS(@"比分类型")
                                  delegate:self
								  cancelButtonTitle:FNS(@"返回")
								  destructiveButtonTitle:nil
								  otherButtonTitles:FNS(@"一级赛事"), FNS(@"全部比分"), 
                                    FNS(@"单场比分"), FNS(@"足彩比分"), FNS(@"竞彩比分"), nil
                                  ];
	
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (buttonIndex == actionSheet.cancelButtonIndex) {
		return;
	}
    matchScoreType = buttonIndex;
}

@end
