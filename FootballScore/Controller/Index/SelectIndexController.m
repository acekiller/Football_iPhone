//
//  SelectIndexController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-10-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SelectIndexController.h"
#import "LocaleConstants.h"
#import "CompanyManager.h"
#import "Company.h"
#import "ColorManager.h"

typedef enum ODDS_TYPE {
    ODDS_TYPE_YAPEI = 1,
    ODDS_TYPE_DAXIAO = 3,
    ODDS_TYPE_OUPEI = 2
}ODDS_TYPE;

#define SCROLL_VIEW_TAG 20111109
#define COMPANY_ID_BUTTON_OFFSET 120111109
#define CONTENT_TYPE_OFFSET 220111108

@implementation SelectIndexController
@synthesize buttonAsianBwin;
@synthesize buttonEuropeBwin;
@synthesize buttonBigandSmall;
@synthesize delegate;
@synthesize selectedCompanySet;
@synthesize selectedOddsType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        asianBwinArray = [[NSMutableArray alloc] init];
        europeBwinArray = [[NSMutableArray alloc] init];
        bigandSmallArray = [[NSMutableArray alloc] init];
        selectedCompanySet = [[NSMutableSet alloc] init];  
    }
    return self;
}

- (void)dealloc
{
    [buttonAsianBwin release];
    [buttonEuropeBwin release];
    [buttonBigandSmall release];
    [asianBwinArray release];
    [europeBwinArray release];
    [bigandSmallArray release];
    [selectedCompanySet release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)contentTypeButtonInit
{
    CompanyManager* manager = [CompanyManager defaultCompanyManager];
    
    //backup the company manager data
    self.selectedOddsType = manager.selectedOddsType;
    [self.selectedCompanySet removeAllObjects];
    for (Company* company in [manager.selectedCompany allObjects]) {
        [self.selectedCompanySet addObject:company];
    }
    for (Company* company in manager.allCompany) {
        if (company.hasAsianOdds) {
            [asianBwinArray addObject:company];
        }
        if (company.hasEuropeOdds) {
            [europeBwinArray addObject:company];
        }
        if (company.hasDaXiao) {
            [bigandSmallArray addObject:company];
        }
    }
    
    switch (manager.selectedOddsType) {
        case ODDS_TYPE_YAPEI:
            [buttonAsianBwin setSelected:YES];
            [self createButtonsByArray:asianBwinArray];
            break;
        case ODDS_TYPE_DAXIAO:
            [buttonBigandSmall setSelected:YES];
            [self createButtonsByArray:bigandSmallArray];
            break;
        case ODDS_TYPE_OUPEI:
            [buttonEuropeBwin setSelected:YES];
            [self createButtonsByArray:europeBwinArray];
            break;
        default:
            break;
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{   
    
    [self.navigationItem setTitle:@"内容筛选"];
    [self setNavigationLeftButton:FNS(@"返回") imageName:@"ss.png"  action:@selector(clickBack:)];
    [self setNavigationRightButton:fns(@"完成") imageName:@"ss.png" action:@selector(clickDone:)];
    [buttonAsianBwin setTag:ASIANBWIN];
    [buttonEuropeBwin setTag:EUROPEBWIN];
    [buttonBigandSmall setTag:BIGANDSMALL];
    
    [self contentTypeButtonInit];

    [self.view setBackgroundColor:[ColorManager scrollViewBackgroundColor]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (void)viewDidUnload
{
    [self setButtonAsianBwin:nil];
    [self setButtonEuropeBwin:nil];
    [self setButtonBigandSmall:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

+ (SelectIndexController*)show:(UIViewController<SeclectIndexControllerDelegate>*)superController
{
    SelectIndexController* vc = [[SelectIndexController alloc] init];
    vc.delegate = superController;
    [superController.navigationController pushViewController:vc animated:YES];
    [vc release];
    return vc;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)clickContentTypeButton:(id)sender
{
    contentType = [sender tag];
    [self.selectedCompanySet removeAllObjects];
    [self setSelectedOddsType:(contentType-CONTENT_TYPE_OFFSET)];
    for (int i = ASIANBWIN; i <= BIGANDSMALL; i++) {
        UIButton* button = (UIButton*)[self.view viewWithTag:i];
        if ( contentType== i) {
            [button setSelected:YES];
        }
        else {
            [button setSelected:NO];
        }

    }  
    switch (contentType) {
        case ASIANBWIN: {
            [self createButtonsByArray:asianBwinArray];
            break;
        }
        case EUROPEBWIN: {
            [self createButtonsByArray:europeBwinArray];
            break;
        }
        case BIGANDSMALL: {
            [self createButtonsByArray:bigandSmallArray];
            break;
        }
        default:
            break;
    }
}


- (IBAction)buttonClicked:(id)sender 
{
    CompanyManager* manager = [CompanyManager defaultCompanyManager];
    UIButton *button = (UIButton*)sender;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FNS(@"最多只能选四个") 
                                                    message:FNS(@"") 
                                                   delegate:nil 
                                          cancelButtonTitle:FNS(@"好了，我知道了") 
                                          otherButtonTitles: nil];
    
    if ([self.selectedCompanySet containsObject:[manager getCompanyById:[NSString stringWithFormat:@"%d", button.tag - COMPANY_ID_BUTTON_OFFSET]]]) {
        [button setSelected:NO];
        [self.selectedCompanySet removeObject:[manager getCompanyById:[NSString stringWithFormat:@"%d", button.tag - COMPANY_ID_BUTTON_OFFSET]]];

    }
    else {
        if ([[self selectedCompanySet] count] >= 4) {
            [alert show];
            [alert release];
            return;
        }
        [button setSelected:YES];
        [self.selectedCompanySet addObject:[manager getCompanyById:[NSString stringWithFormat:@"%d", button.tag - COMPANY_ID_BUTTON_OFFSET]]];
    }
}

- (void)clickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickDone:(id)sender
{
    CompanyManager* manager = [CompanyManager defaultCompanyManager];
    if ([[self selectedCompanySet] count] <= 0) {  
        [self popupMessage:@"至少选择一间赔率公司" title:nil];
        return;
    }
    manager.selectedOddsType = self.selectedOddsType;
    manager.selectedCompany = self.selectedCompanySet;
    if (delegate && [delegate respondsToSelector:@selector(SelectCompanyFinish)]) {
        [delegate SelectCompanyFinish];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

    
//}

// the funcition is wait to implement .
//
//-(void)companybuttonClicked:(id)sender{
//    
//    UIButton* button = (UIButton*)sender;
//    NSString* OddsCompanyId = [NSString stringWithInt:button.tag];
//    
//    if ([self isOddsCompanySelected:OddsCompanyId]){
//        [self deSelectOddsCompany:OddsCompanyId];
//    }
//    else{
//        [self selectOddsCompany:OddsCompanyId];
//    }    
//    
//    
//    
//}
//
//- (BOOL)isOddsCompanySelected:(NSString*)OddsCompanyId
//{
//    return [selectedBwin containsObject:OddsCompanyId];
//}
//
//
//- (void)selectOddsCompany:(NSString*)OddsCompanyId
//{
//    [selectedBwin addObject:OddsCompanyId];
  //UIView* v= [self.view viewWithTag:SCROLL_VIEW_TAG]
//    
//    UIButton* button = (UIButton*)[v viewWithTag:[OddsCompanyId intValue]];
//    [button setBackgroundImage:[UIImage imageNamed:@"set.png"] forState:UIControlStateNormal];
//    
//}
//
//
//- (void)deSelectOddsCompany:(NSString*)OddsCompanyId
//{
//    [selectedBwin removeObject:OddsCompanyId];
//    
//    UIButton* button = (UIButton*)[buttonScrollView viewWithTag:[OddsCompanyId intValue]];
//    [button setBackgroundImage:[UIImage imageNamed:@"set2.png"] forState:UIControlStateNormal];
//    
//        
//}
//



#pragma mark -
#pragma mark these codes used to draw scrollView 



- (void)createButtonsByArray:(NSArray*)array
{
    NSMutableArray* buttonArray = [[NSMutableArray alloc] init];
    for (Company* company in array) {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(160, 160, 72, 32)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button setTitle:company.companyName forState:UIControlStateNormal];
        [button setTitle:company.companyName forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"set2.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"set.png"] forState:UIControlStateSelected];
        [button setTitleColor:[ColorManager MatchesNameButtonNotChosenColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTag:([company.companyId intValue] + COMPANY_ID_BUTTON_OFFSET)];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.selectedCompanySet containsObject:company]) {
            [button setSelected:YES];
        }
        else {
            [button setSelected:NO];
        }
        [buttonArray addObject:button];
        [button release];
    }
    
    UIScrollView *buttonScrollView = [PPViewController createButtonScrollViewByButtonArray:buttonArray buttonsPerLine:3 buttonSeparatorY:-1];
    
    [buttonArray release];
    [[self.view viewWithTag:SCROLL_VIEW_TAG] removeFromSuperview];
    buttonScrollView.tag = SCROLL_VIEW_TAG;     
    [buttonScrollView setFrame:CGRectMake(0, 143, 320, 243)];
    [self.view addSubview:buttonScrollView];

}



@end
