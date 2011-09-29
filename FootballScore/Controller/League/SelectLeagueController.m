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
@synthesize selectNoneButton;
@synthesize selectAllButton;


const float buttonLen = 70;
const float buttonHigh = 50;
const float buttonSepratorX = 8;
const float buttonSepratorY = 10;
const int buttonsPerLine = 4;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
    buttonNamesArray = [NSArray arrayWithObjects:@"英超", @"意甲", @"西甲", @"法甲", @"德甲", @"荷甲", @"欧冠", @"国王杯", @"联赛杯", nil];
    buttonNumbers = [buttonNamesArray count];
    buttonTagsArray = [[NSMutableArray alloc]initWithCapacity:[buttonNamesArray count]];
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
    [buttonTagsArray release];
    [selectAllButton release];
    [selectNoneButton release];
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
    

    
    UIView * rightButtonParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    rightButtonParentView.backgroundColor = [UIColor clearColor];
     
    
    int buttonSize = 32;
    int rightOffset = 20;
    UIButton * setButton = [[UIButton alloc] initWithFrame:CGRectMake(rightButtonParentView.frame.size.width - buttonSize - rightOffset, 6, buttonSize, buttonSize)];
    [rightButtonParentView addSubview:setButton];
    [setButton release];
    
    UIButton * searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 6, buttonSize, buttonSize)];
    [rightButtonParentView addSubview:searchButton];
    [searchButton release];
    
    
    UIBarButtonItem * rightButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:rightButtonParentView];
    [rightButtonParentView release];                            
    self.navigationItem.rightBarButtonItem = rightButtonItem2;
    [rightButtonItem2 release];
  
    int i;
    int rowIndex;
    int rankIndex;
    for (i=0 ; i<buttonNumbers; i++){
        NSString *title = [buttonNamesArray objectAtIndex:i];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:title forState:UIControlStateNormal];
        
        rowIndex = i/buttonsPerLine;
        rankIndex = i%buttonsPerLine;
        button.frame = CGRectMake(buttonSepratorX+rankIndex*(buttonSepratorX+buttonLen), rowIndex*(buttonHigh+buttonSepratorY), buttonLen, buttonHigh);
        [button setTag:i+1];
        [button setBackgroundImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];
        [button setSelected:NO];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
    }
    scrollView.contentSize = CGSizeMake(320, ([buttonNamesArray count]/4+1)*(buttonHigh+buttonSepratorY));
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPromptLabel:nil];
    [self setScrollView:nil];
    [self setTopLeagueButton:nil];
    [self setSelectAllButton:nil];
    [self setSelectNoneButton:nil];
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
    UIButton *selectedButton;
    NSNumber *findNum;
    int i = 0;
    for(i=1;i<=buttonNumbers;i++){
        selectedButton = [scrollView viewWithTag:i];
        [selectedButton setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        
        findNum = [NSNumber numberWithInt:i];
        if(NSNotFound == [buttonTagsArray indexOfObject:findNum]){
            [buttonTagsArray addObject:findNum];
        }
    }   
        
}

-(IBAction)selectNone:(id)sender{
    UIButton *selectedButton;
    NSNumber *findNum;
    int i = 0;
    for(i=1;i<=buttonNumbers;i++){
        selectedButton = [scrollView viewWithTag:i];
        [selectedButton setBackgroundImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];

        }  
    buttonTagsArray = nil;
    
}

-(IBAction)selectTopLeague:(id)sender{
    UIButton *selectedButton;
    NSNumber *findNum;
    NSString *buttonTitle;
    NSArray *topLeagueArray = [NSArray arrayWithObjects:@"英超", @"意甲", @"法甲", nil];
    int i = 0;
    for(i=1;i<=buttonNumbers;i++){
        selectedButton = [scrollView viewWithTag:i];
        buttonTitle = [selectedButton titleForState:UIControlStateNormal];
        
        if(NSNotFound != [topLeagueArray indexOfObject:buttonTitle]){
            [selectedButton setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
            findNum = [NSNumber numberWithInt:i];
            if(NSNotFound == [buttonTagsArray indexOfObject:findNum]){
                [buttonTagsArray addObject:findNum];
            }
        }
    }   
    
}

-(void)buttonClicked:(id)sender{
    BOOL buttonState = [sender isSelected];
    [sender setSelected: !buttonState];
    NSNumber *tagNumber;
    tagNumber = [[NSNumber alloc]initWithInt:[sender tag]];
    
    if([sender isSelected]){
        [sender setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        if(NSNotFound == [buttonTagsArray indexOfObject:tagNumber])
        [buttonTagsArray addObject:tagNumber];
    } 
    else{
        [sender setBackgroundImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];
        if(NSNotFound != [buttonTagsArray indexOfObject:tagNumber])
            [buttonTagsArray removeObject:tagNumber];
    }

}

@end
