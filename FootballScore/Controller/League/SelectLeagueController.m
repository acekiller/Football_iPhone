//
//  SelectLeagueController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SelectLeagueController.h"
#import "League.h"
//#import "LeagueManager.h"
//#import "MatchManager.h"
#import "StringUtil.h"
#import "LocaleConstants.h"
#import "ColorManager.h"


@implementation SelectLeagueController
@synthesize promptLabel;
@synthesize topLeagueButton;
@synthesize scrollView;
@synthesize selectNoneButton;
@synthesize selectAllButton;
@synthesize hideMatchesUpDateInf;
@synthesize hideMatchesLabel1;
@synthesize hideMatchesLabel2;

@synthesize delegate;
@synthesize selectLeagueIdArray;





@synthesize leagueArray;
@synthesize filterLeagueIdList;





const float buttonLen = 72;
const float buttonHigh = 32;
const float buttonSepratorX = 6;
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
    [hideMatchesUpDateInf release];
    [hideMatchesLabel1 release];
    [hideMatchesLabel2 release];
    [leagueArray release];
    [filterLeagueIdList release];
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
//    LeagueManager* manager = [LeagueManager defaultManager];
//    int leagueNumber = [manager.leagueArray count];
    
       int leagueNumber = [leagueArray count];
    
    int i=0;
    int rowIndex;
    int rankIndex;
//    for (League* league in manager.leagueArray){
       for (League* league in leagueArray){

    
        NSString *title = league.name;
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:title forState:UIControlStateNormal];
        
        rowIndex = i/buttonsPerLine;
        rankIndex = i%buttonsPerLine;
        button.frame = CGRectMake(buttonSepratorX+rankIndex*(buttonSepratorX+buttonLen), rowIndex*(buttonHigh+buttonSepratorY), buttonLen, buttonHigh);
        [button setTag:[league.leagueId intValue]];
        
        if ([self isLeagueSelected:league.leagueId]){
            [button setBackgroundImage:[UIImage imageNamed:@"set.png"] forState:UIControlStateNormal];  
            
            // change color to White  , when the Button is  pressed .
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];  
            

        }
        else{
            [button setBackgroundImage:[UIImage imageNamed:@"set2.png"] forState:UIControlStateNormal];
            
            
            // change color to  #666666 , when the Button is  pressed .
            [button setTitleColor:[ColorManager MatchesNameButtonNotChosenColor ] forState:UIControlStateNormal];

        }
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        i++;
    }
    scrollView.contentSize = CGSizeMake(320, (leagueNumber/4+1)*(buttonHigh+buttonSepratorY));
    
    //set the scrollView background Color 
    [scrollView setBackgroundColor:[ColorManager scrollViewBackgroundColor]];
    
    
    
       
    
}

- (void)viewDidLoad
{  
    //Set the matches chosen buttons title color to #245393
    [topLeagueButton setTitleColor:[ColorManager ToChooseTheMatchesButtonColor] forState:UIControlStateNormal];
    [selectAllButton setTitleColor:[ColorManager ToChooseTheMatchesButtonColor] forState:UIControlStateNormal];
    [ selectNoneButton setTitleColor:[ColorManager ToChooseTheMatchesButtonColor] forState:UIControlStateNormal];  
    
    
    [self.navigationItem setTitle:@"赛事筛选"];
    [self setNavigationLeftButton:FNS(@"返回") imageName:@"ss.png" action:@selector(clickBack:)];
    
   [self setNavigationRightButton:FNS(@"确定") imageName:@"ss.png" action:@selector(clickDone:)];
    
    
    
//    [selectLeagueIdArray addObjectsFromArray:[[[MatchManager defaultManager] filterLeagueIdList] allObjects]];
    
      [selectLeagueIdArray addObjectsFromArray: [filterLeagueIdList allObjects]];

    
    
    
    
    
    [self updateHiddenMatchInfo];
    
    //set the colors of the hided matches' text color 
    self.hideMatchesUpDateInf.textColor =[ColorManager HideMatchesInforNumColor];
    self.hideMatchesLabel1.textColor=[ColorManager HideMatchesInforColor];
    self.hideMatchesLabel2.textColor=[ColorManager HideMatchesInforColor];
    
    
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
    [self setHideMatchesUpDateInf :nil];
    [self setHideMatchesLabel1:nil];
    [self setHideMatchesLabel2: nil];
    
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)selectLeague:(NSString*)leagueId //isUpdateHiddenInfo:(BOOL)isUpdateHiddenInfo
{
    [selectLeagueIdArray addObject:leagueId];
    
    UIButton* button = (UIButton*)[scrollView viewWithTag:[leagueId intValue]];
    [button setBackgroundImage:[UIImage imageNamed:@"set.png"] forState:UIControlStateNormal];
    
    // change color to White  , when the Button is  pressed .
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];          
}


- (void)deselectLeague:(NSString*)leagueId // isUpdateHiddenInfo:(BOOL)isUpdateHiddenInfo
{
    [selectLeagueIdArray removeObject:leagueId];

    UIButton* button = (UIButton*)[scrollView viewWithTag:[leagueId intValue]];
    [button setBackgroundImage:[UIImage imageNamed:@"set2.png"] forState:UIControlStateNormal];
    
    
    // change color to  #666666 , when the Button is  pressed .
    [button setTitleColor:[ColorManager MatchesNameButtonNotChosenColor ] forState:UIControlStateNormal];        
}

- (BOOL)isLeagueSelected:(NSString*)leagueId
{
    return [selectLeagueIdArray containsObject:leagueId];
}

-(IBAction)selectAll:(id)sender{
    
//    LeagueManager* manager = [LeagueManager defaultManager];
//    for (League* league in manager.leagueArray){
//        [self selectLeague:league.leagueId];
//        
        
    for (League* league in leagueArray){
        [self selectLeague:league.leagueId];
    }
    
    //click the button and get the hided matches 
    [self updateHiddenMatchInfo];

}

-(IBAction)selectNone:(id)sender{
    
//    LeagueManager* manager = [LeagueManager defaultManager];
//    for (League* league in manager.leagueArray){
//        [self deselectLeague:league.leagueId];
//    }    
    
    for (League* league in leagueArray){
        [self deselectLeague:league.leagueId];
    }    

    
    //click the button and get the hided matches 
    [self updateHiddenMatchInfo];

}

-(IBAction)selectTopLeague:(id)sender{
    
    //Remove other matches except for the top league
    [self selectNone:sender];        
    
    for (League* league in leagueArray){
        if ([league isTop]){
           [self selectLeague:league.leagueId];
                 }
    }  
    
    //click the button and get the hided matches 
    [self updateHiddenMatchInfo];

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
        
    //click the button and get the hided matches 
    [self updateHiddenMatchInfo];
}

+(SelectLeagueController*)show:(UIViewController<SelectLeagueControllerDelegate>*)superController
                leagueIdArray :(NSArray *)LeagueaArray   
           filterLeagueIdList :(NSMutableSet*)filterLeagueIdList

{
    SelectLeagueController* vc = [[SelectLeagueController alloc] init];
    vc.delegate = superController;
    
    vc.leagueArray = LeagueaArray;
    vc.filterLeagueIdList = filterLeagueIdList;
    
    
    [superController.navigationController pushViewController:vc animated:YES];
    [vc release];
    return vc;
}




- (void)updateHiddenMatchInfo{
    
    int count = 0;    
    if ([delegate respondsToSelector:@selector(calculateHiddenMatchCount:)]){
        count = [delegate calculateHiddenMatchCount:selectLeagueIdArray];
    }
    
    
    NSString *buttonTitle = [NSString stringWithFormat:@"%d",count];
 
    // set the hideMatchUpdate button title     
    [hideMatchesUpDateInf setText:buttonTitle];
}






//The done button implementations

- (void)clickDone:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(didSelectLeague:)]){
        [delegate didSelectLeague:selectLeagueIdArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
