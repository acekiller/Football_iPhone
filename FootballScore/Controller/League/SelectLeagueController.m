//
//  SelectLeagueController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SelectLeagueController.h"


@implementation SelectLeagueController
@synthesize promptLabel;
@synthesize topLeagueButton;
@synthesize scrollView;


const float buttonLen = 73;
const float buttonHigh = 50;
const float buttonSepratorX = 5;
const float buttonSepratorY = 10;
const int buttonsPerLine = 4;

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
    [promptLabel release];
    [scrollView release];
    [topLeagueButton release];
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

    UIColor *noColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:255];
    NSArray *newArray;
    newArray = [NSArray arrayWithObjects:@"英超", @"意甲", @"西甲", @"法甲", @"德甲", @"荷甲", @"欧冠", @"国王杯", @"联赛杯", nil];
    
    int i;
    int rowIndex;
    int rankIndex;
    for (i=0 ; i<[newArray count]; i++){
        NSString *title = [newArray objectAtIndex:i];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:title forState:UIControlStateNormal];
        
        rowIndex = i/buttonsPerLine;
        rankIndex = i%buttonsPerLine;
        button.frame = CGRectMake(buttonSepratorX+rankIndex*(buttonSepratorX+buttonLen), rowIndex*(buttonHigh+buttonSepratorY), buttonLen, buttonHigh);
        [button setTag:i];
        [button setSelected:NO];
        [button setTitleColor:noColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
    }
    scrollView.contentSize = CGSizeMake(320, ([newArray count]/4+1)*(buttonHigh+buttonSepratorY));
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPromptLabel:nil];
    [self setScrollView:nil];
    [self setTopLeagueButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)selectAll:(id)sender{
    
}

-(IBAction)selectNone:(id)sender{
    
}

-(IBAction)selectTopLeague:(id)sender{
    
}

-(id)buttonClicked:(id)sender{
    BOOL buttonState = [sender isSelected];
    [sender setSelected: !buttonState];
    UIColor *yesColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:255];
    UIColor *noColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:255];
    
    if([sender isSelected]){
        [sender setTitleColor:yesColor forState:UIControlStateNormal];
    } 
    else{
        [sender setTitleColor:noColor forState:UIControlStateNormal];
    }
}

@end
