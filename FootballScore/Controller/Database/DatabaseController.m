//
//  DatabaseController.m
//  FootballScore
//
//  Created by  on 11-12-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DatabaseController.h"

@implementation DatabaseController

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

- (IBAction)clickContinent:(id)sender {
    
    ContinentType continent = ((UIButton *)sender).tag;
    switch (continent) {
        case AMERICAS:
        {
            NSLog(@"美洲");
        }
            break;
        case AFRICA:
        {
            NSLog(@"非洲");            
        }
            break;
        case ASIA:
        {
            NSLog(@"亚洲");
        }
            break;
        case OCEANIA:
        {
            NSLog(@"大洋洲");
        }
            break;
            
        case EUROPE:
        default:
            NSLog(@"欧洲");
            break;
    }
}
@end
