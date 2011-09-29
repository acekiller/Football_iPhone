//
//  SelectLeagueController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SelectLeagueController.h"
#import "League.h"
#import "LeagueManager.h"
#import "MatchManager.h"
#import "StringUtil.h"
#import "LocaleConstants.h"

@implementation SelectLeagueController
@synthesize promptLabel;
@synthesize topLeagueButton;
@synthesize scrollView;
@synthesize selectNoneButton;
@synthesize selectAllButton;
@synthesize delegate;
@synthesize selectLeagueIdArray;


const float buttonLen = 70;
const float buttonHigh = 50;
const float buttonSepratorX = 8;
const float buttonSepratorY = 10;
const int buttonsPerLine = 4;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
//    buttonNamesArray = [NSArray arrayWithObjects:@"英超", @"意甲", @"西甲", @"法甲", @"德甲", @"荷甲", @"欧冠", @"国王杯", @"联赛杯", nil];    
//    buttonNumbers = [buttonNamesArray count];

    selectLeagueIdArray = [[NSMutableSet alloc] init];
    
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
    [selectLeagueIdArray release];
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

- (void)createLeagueButtons
{
    LeagueManager* manager = [LeagueManager defaultManager];
    int leagueNumber = [manager.leagueArray count];
    
    int i=0;
    int rowIndex;
    int rankIndex;
    for (League* league in manager.leagueArray){
        NSString *title = league.name;
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:title forState:UIControlStateNormal];
        
        rowIndex = i/buttonsPerLine;
        rankIndex = i%buttonsPerLine;
        button.frame = CGRectMake(buttonSepratorX+rankIndex*(buttonSepratorX+buttonLen), rowIndex*(buttonHigh+buttonSepratorY), buttonLen, buttonHigh);
        [button setTag:[league.leagueId intValue]];
        
        if ([self isLeagueSelected:league.leagueId]){
            [button setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];            
        }
        else{
            [button setBackgroundImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];            
        }
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        i++;
    }
    scrollView.contentSize = CGSizeMake(320, (leagueNumber/4+1)*(buttonHigh+buttonSepratorY));
    
}

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
  
    [self setNavigationLeftButton:FNS(@"返回") action:@selector(clickBack:)];
    [self setNavigationRightButton:FNS(@"完成") action:@selector(clickDone:)];
    
    [selectLeagueIdArray addObjectsFromArray:[[[MatchManager defaultManager] filterLeagueIdList] allObjects]];
    [self createLeagueButtons];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSelectLeagueIdArray:nil];
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



- (void)selectLeague:(NSString*)leagueId
{
    [selectLeagueIdArray addObject:leagueId];

    UIButton* button = (UIButton*)[scrollView viewWithTag:[leagueId intValue]];
    [button setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
}

- (void)deselectLeague:(NSString*)leagueId
{
    [selectLeagueIdArray removeObject:leagueId];

    UIButton* button = (UIButton*)[scrollView viewWithTag:[leagueId intValue]];
    [button setBackgroundImage:[UIImage imageNamed:@"unSelected.png"] forState:UIControlStateNormal];
}

- (BOOL)isLeagueSelected:(NSString*)leagueId
{
    return [selectLeagueIdArray containsObject:leagueId];
}

-(IBAction)selectAll:(id)sender{
    
    LeagueManager* manager = [LeagueManager defaultManager];
    for (League* league in manager.leagueArray){
        [self selectLeague:league.leagueId];
    }
}

-(IBAction)selectNone:(id)sender{
    
    LeagueManager* manager = [LeagueManager defaultManager];
    for (League* league in manager.leagueArray){
        [self deselectLeague:league.leagueId];
    }    
}

-(IBAction)selectTopLeague:(id)sender{
    
    LeagueManager* manager = [LeagueManager defaultManager];
    for (League* league in manager.leagueArray){
        if ([league isTop]){
            [self selectLeague:league.leagueId];
        }
    }        
}

-(void)buttonClicked:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    NSString* leagueId = [NSString stringWithInt:button.tag];
    
    if ([self isLeagueSelected:leagueId]){
        [self deselectLeague:leagueId];
    }
    else{
        [self selectLeague:leagueId];
    }    
}

+ (SelectLeagueController*)show:(UIViewController<SelectLeagueControllerDelegate>*)superController
{
    SelectLeagueController* vc = [[SelectLeagueController alloc] init];
    vc.delegate = superController;
    [superController.navigationController pushViewController:vc animated:YES];
    [vc release];
    return vc;
}

- (void)clickDone:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(didSelectLeague:)]){
        [delegate didSelectLeague:selectLeagueIdArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
