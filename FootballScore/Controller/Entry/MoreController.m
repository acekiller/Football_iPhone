//
//  MoreController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MoreController.h"
#import "LocaleConstants.h"


@implementation MoreController
@synthesize selectLanguage;

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
    [selectLanguage release];
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
    [self setSelectLanguage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)clickOnSelectLanguage:(id)sender
{
    UIActionSheet *languageTable = [[UIActionSheet alloc]initWithTitle:FNS(@"请选择语言习惯") 
                                                              delegate:self 
                                                     cancelButtonTitle:@"取消" 
                                                destructiveButtonTitle:@"中国大陆" 
                                                     otherButtonTitles:@"廣東/香港", nil];
    
    [languageTable showFromTabBar:self.tabBarController.tabBar];
    [languageTable release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex){
		return;
	}
    
    if (buttonIndex == language){
        // same type, no change, return directly
        return;
    }
    
    language = buttonIndex;
}


@end
