//
//  AboutController.m
//  FootballScore
//
//  Created by  on 11-11-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AboutController.h"
#import "LocaleConstants.h"

@implementation AboutController
@synthesize versionLabel;
@synthesize customerServiceLabel;
@synthesize webSiteAddressLabel;
@synthesize copyrightLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.navigationItem.title = FNS(@"关于彩客网");	
    [self setNavigationLeftButton:FNS(@"返回") imageName:@"ss.png"
                           action:@selector(clickBack:)];
    
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *versionTitle = FNS(@"版本");
    versionLabel.text = [NSString stringWithFormat:@"%@:%@" , versionTitle,versionString];
    
    NSString *customerServiceTitle = FNS(@"客服电话");
    customerServiceLabel.text  = [NSString stringWithFormat:@"%@:0758-2512562",customerServiceTitle];
    
    NSString *webSiteAddressTitle = FNS(@"网站网址");
    webSiteAddressLabel.text = [NSString stringWithFormat:@"%@:www.titan007.com",webSiteAddressTitle];
    
    copyrightLabel.text = FNS(@"版权所有:肇庆市创威发展有限公司");
}

- (void)viewDidUnload
{
    [self setVersionLabel:nil];
    [self setCustomerServiceLabel:nil];
    [self setWebSiteAddressLabel:nil];
    [self setCopyrightLabel:nil];
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
    [versionLabel release];
    [customerServiceLabel release];
    [webSiteAddressLabel release];
    [copyrightLabel release];
    [super dealloc];
}
@end
