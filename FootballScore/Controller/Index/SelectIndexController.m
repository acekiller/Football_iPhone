//
//  SelectIndexController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-10-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SelectIndexController.h"


@implementation SelectIndexController
@synthesize buttonScrollView;
@synthesize buttonAsianBwin;
@synthesize buttonEuropeBwin;
@synthesize buttonBigandSmall;

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
    [buttonScrollView release];
    [buttonAsianBwin release];
    [buttonEuropeBwin release];
    [buttonBigandSmall release];
    [asianBwinArray release];
    [europeBwinArray release];
    [bigandSmallArray release];
    [buttonsArray release];
    [selectedBwin release];
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
    [self dataInit];
    [self buttonsInit];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setButtonScrollView:nil];
    [self setButtonAsianBwin:nil];
    [self setButtonEuropeBwin:nil];
    [self setButtonBigandSmall:nil];
    buttonsArray = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)buttonsInit
{
    [buttonAsianBwin setTag:11];
    [buttonAsianBwin setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [buttonEuropeBwin setTag:12];
    [buttonEuropeBwin setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [buttonBigandSmall setTag:13];
    [buttonBigandSmall setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    
    
}

- (void)dataInit
{
    asianBwinArray = [[NSArray arrayWithObjects:@"亚洲1", @"亚洲2", @"亚洲3", @"亚洲4", @"亚洲5", @"亚洲6", nil] retain];
    europeBwinArray = [[NSArray arrayWithObjects:@"欧洲1", @"欧洲2", @"欧洲3", @"欧洲4", @"欧洲5", @"欧洲6", nil] retain];
    bigandSmallArray = [[NSArray arrayWithObjects:@"大小1", @"大小2", @"大小3", @"大小4", @"大小5", @"大小6", nil] retain] ;
    buttonsArray = [[NSMutableArray alloc] init];
    selectedBwin = [[NSMutableSet alloc] init];
}

- (IBAction)clickContentTypeButton:(id)sender
{
    contentType = [sender tag];
    for (int i = ASIANBWIN; i <= BIGANDSMALL; i++) {
        UIButton* button = (UIButton*)[self.view viewWithTag:i];
        if ( contentType== i) {
            [button setSelected:YES];
            [button setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        }
        else {
            [button setSelected:NO];
            [button setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        }

    }
    
    switch (contentType) {
        case ASIANBWIN: {
            [self showButtonsWithArray:asianBwinArray selectedArray:selectedBwin];
            break;
        }
        case EUROPEBWIN: {
            [self showButtonsWithArray:europeBwinArray selectedArray:selectedBwin];
            break;
        }
        case BIGANDSMALL: {
            [self showButtonsWithArray:bigandSmallArray selectedArray:selectedBwin];
            break;
        }
      
        default:
            break;
    }
}

- (void)showButtonsWithArray:(NSArray*)array selectedArray:(NSMutableSet*)selectedArray
{
    int i = 0;
    CGSize buttonSize = CGSizeMake(70, 50);
    UIImage *selectedImage = [UIImage imageNamed:@"selected"];
    UIImage *unSelectedImage = [UIImage imageNamed:@"unselected"];
    [buttonsArray removeAllObjects];

    
    for (i = 0; i < [array count]; i++) {
        NSString *title = [array objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:title forState:UIControlStateNormal];
        if ([selectedArray containsObject:title]) {
            [button setSelected:YES];
        }
        else {
            [button setSelected:NO];
        }
        button.tag = i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsArray addObject:button];        
    }

    [SelectIndexController showButtonsAtScrollView:buttonScrollView withButtonArray:buttonsArray selectedImage:selectedImage unSelectedImage:unSelectedImage buttonsPerLine:4 buttonSize:buttonSize];
}

+ (void)showButtonsAtScrollView:(UIScrollView*)scrollView 
                withButtonArray:(NSMutableArray*)buttonArray
              selectedImage:(UIImage*)selectedImage 
                unSelectedImage:(UIImage*)unSelectedImage 
                 buttonsPerLine:(int)buttonsPerLine 
                     buttonSize:(CGSize)buttonSize
{
    int i = 0;
    int rowIndex;
    int rankIndex;
    float buttonSeparatorX = (320-buttonsPerLine*buttonSize.width)/(buttonsPerLine+1);
    float buttonSeparatorY = buttonSize.height/3;
    float buttonLen = buttonSize.width;
    float buttonHigh = buttonSize.height;
    
    for (i = 0; i < [buttonArray count]; i++) {
        rowIndex = i/4;
        rankIndex = i%4;
        UIButton *button = [buttonArray objectAtIndex:i];
        if ([button isSelected]) {
            [button setBackgroundImage:selectedImage forState:UIControlStateNormal];
        }
        else {
            [button setBackgroundImage:unSelectedImage forState:UIControlStateNormal];
        }
        button.frame = CGRectMake(buttonSeparatorX+rankIndex*(buttonSeparatorX+buttonLen), rowIndex*(buttonHigh+buttonSeparatorY), buttonLen, buttonHigh);
        [scrollView addSubview:button];
    }
}

- (void)buttonClicked:(id)sender 
{
    UIButton *button = (UIButton*)sender;
    UILabel *label = [button titleLabel];
    NSString *title = label.text;
    
    if ([selectedBwin containsObject:title]) {
        [selectedBwin removeObject:title];
        [button setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [button setSelected:NO];
    }
    else {
        [selectedBwin addObject:title];
        [button setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [button setSelected:YES];
    }

    
}

@end
