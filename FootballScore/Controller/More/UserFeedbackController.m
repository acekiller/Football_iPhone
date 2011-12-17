//
//  UserFeedbackController.m
//  FootballScore
//
//  Created by Orange on 11-10-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserFeedbackController.h"
#import "LocaleConstants.h"
#import "ColorManager.h"
#import "UserService.h"
#import "UserManager.h"

@implementation UserFeedbackController
@synthesize content;
@synthesize contact;

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[ColorManager blackGroundColor]];
    self.navigationItem.title = FNS(@"信息反馈");	
    [self setNavigationLeftButton:FNS(@"返回") imageName:@"ss.png"
                           action:@selector(clickBack:)];
}

- (void)viewDidUnload
{
    [self setContent:nil];
    [self setContact:nil];
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
    [content release];
    [contact release];
    [super dealloc];
}


- (IBAction)clickOnSendButton:(id)sender
{
    [content resignFirstResponder];
    [contact resignFirstResponder];
    
    NSString *contentString = content.text;
    NSString *contactString = contact.text;
    
    if ([contentString length] == 0) {
        [self popupHappyMessage:FNS(@"反馈内容不能为空") title:nil];
    }
    else
    {
        UserService *userService = [[[UserService alloc] init] autorelease];
        [userService sendFeedback:self userId:[UserManager getUserId] content:contentString contact:contactString];
    }
}

- (void)sendFeedbackFinish:(int)result data:(NSString *)data
{
    if (result == 0) {
        content.text = @"";
        contact.text = @"";
        
        [self popupHappyMessage:FNS(@"提交成功") title:nil];
    }
    else
    {
        [self popupUnhappyMessage:FNS(@"提交失败") title:nil];
    }
}

@end
