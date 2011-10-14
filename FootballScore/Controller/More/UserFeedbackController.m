//
//  UserFeedbackController.m
//  FootballScore
//
//  Created by Orange on 11-10-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserFeedbackController.h"

@implementation UserFeedbackController
@synthesize versionInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) init{
    self = [super init];
    if(self){
        
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
    [self versionInfoInit];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setVersionInfo:nil];
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
    [versionInfo release];
    [super dealloc];
}

- (void)versionInfoInit
{
    versionInfo.text = [NSString stringWithFormat:@"比分客户端\n版本号\n版本信息\n"];
}

- (IBAction)clickOnSendButton:(id)sender
{
    
}

@end
