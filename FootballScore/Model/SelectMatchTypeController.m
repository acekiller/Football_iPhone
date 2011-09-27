//
//  SelectMatchTypeController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SelectMatchTypeController.h"


@implementation SelectMatchTypeController
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

-(IBAction)integrityScore:(id)sender{
    NSString *title = [sender titleForState:UIControlStateNormal ];
    NSString *newText = [[NSString alloc] initWithFormat:@"%@",title];
    statusText.text = title;
    [newText release];
    //全部赛事
}

-(IBAction)singleMatchScore:(id)sender{
    NSString *title = [sender titleForState:UIControlStateNormal ];
    NSString *newText = [[NSString alloc] initWithFormat:@"%@",title];
    statusText.text = title;
    [newText release];
    //单场赛事
}

-(IBAction)lottery:(id)sender{
    NSString *title = [sender titleForState:UIControlStateNormal ];
    NSString *newText = [[NSString alloc] initWithFormat:@"%@",title];
    statusText.text = title;
    [newText release];
    //足彩赛事
}

-(IBAction)smg:(id)sender{
    NSString *title = [sender titleForState:UIControlStateNormal ];
    NSString *newText = [[NSString alloc] initWithFormat:@"%@",title];
    statusText.text = title;
    [newText release];
    //竞彩赛事
}

-(IBAction)topGame:(id)sender{
    NSString *title = [sender titleForState:UIControlStateNormal ];
    NSString *newText = [[NSString alloc] initWithFormat:@"%@",title];
    statusText.text = title;
    [newText release];
    //一级赛事
}



@end
