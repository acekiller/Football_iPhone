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
@synthesize yapeiSelectedCompanySet = _yapeiSelectedCompanySet;
@synthesize oupeiSelectedCompanySet = _oupeiSelectedCompanySet;
@synthesize daxiaoSelectedCompanySet = _daxiaoSelectedCompanySet;
@synthesize selectedOddsType;

- (id)init
{
    self = [super init];
    if (self) {
        asianBwinArray = [[NSMutableArray alloc] init];
        europeBwinArray = [[NSMutableArray alloc] init];
        bigandSmallArray = [[NSMutableArray alloc] init];
        _yapeiSelectedCompanySet = [[NSMutableSet alloc] init];  
        _oupeiSelectedCompanySet = [[NSMutableSet alloc] init];
        _daxiaoSelectedCompanySet = [[NSMutableSet alloc] init];
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
    [_yapeiSelectedCompanySet release];
    [_oupeiSelectedCompanySet release];
    [_daxiaoSelectedCompanySet release];
    
    [super dealloc];
}


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

- (void)contentTypeButtonInit
{
    CompanyManager* manager = [CompanyManager defaultCompanyManager];
    
    //backup the company manager data
    self.selectedOddsType = manager.selectedOddsType;
    for (Company* company in manager.allCompany) {
        if (company.hasAsianOdds) {
            [asianBwinArray addObject:company.companyId];
        }
        if (company.hasEuropeOdds) {
            [europeBwinArray addObject:company.companyId];
        }
        if (company.hasDaXiao) {
            [bigandSmallArray addObject:company.companyId];
        }
    }
    
    switch (manager.selectedOddsType) {
        case ODDS_TYPE_YAPEI:
            [buttonAsianBwin setSelected:YES];
            contentType = ASIANBWIN;
            [self.yapeiSelectedCompanySet removeAllObjects];
            for (Company* company in [manager.selectedCompany allObjects]) {
                [self.yapeiSelectedCompanySet addObject:company.companyId];
            }
            [self createButtonsByArray:asianBwinArray selectedCompanySet:self.yapeiSelectedCompanySet];
            break;
        case ODDS_TYPE_DAXIAO:
            [buttonBigandSmall setSelected:YES];
            contentType = BIGANDSMALL;
            [self.daxiaoSelectedCompanySet removeAllObjects];
            for (Company* company in [manager.selectedCompany allObjects]) {
                [self.daxiaoSelectedCompanySet addObject:company.companyId];
            }
            [self createButtonsByArray:bigandSmallArray selectedCompanySet:self.daxiaoSelectedCompanySet];
            break;
        case ODDS_TYPE_OUPEI:
            [self.oupeiSelectedCompanySet removeAllObjects];
            for (Company* company in [manager.selectedCompany allObjects]) {
                [self.oupeiSelectedCompanySet addObject:company.companyId];
            }
            [buttonEuropeBwin setSelected:YES];
            contentType = EUROPEBWIN;
            [self createButtonsByArray:europeBwinArray selectedCompanySet:self.oupeiSelectedCompanySet];
            break;
        default:
            break;
    }
    
}

#pragma mark - View lifecycle



- (void)viewDidLoad
{   
    [super viewDidLoad];
    [self.navigationItem setTitle:@"内容筛选"];
    [self setNavigationLeftButton:FNS(@"返回") imageName:@"ss.png"  action:@selector(clickBack:)];
    [self setNavigationRightButton:FNS(@"完成") imageName:@"ss.png" action:@selector(clickDone:)];
    [buttonAsianBwin setTag:ASIANBWIN];
    [buttonEuropeBwin setTag:EUROPEBWIN];
    [buttonBigandSmall setTag:BIGANDSMALL];
    [self contentTypeButtonInit];
    [self.view setBackgroundColor:[ColorManager scrollViewBackgroundColor]];
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
            [self createButtonsByArray:asianBwinArray selectedCompanySet:self.yapeiSelectedCompanySet];
            break;
        }
        case EUROPEBWIN: {
            [self createButtonsByArray:europeBwinArray selectedCompanySet:self.oupeiSelectedCompanySet];
            break;
        }
        case BIGANDSMALL: {
            [self createButtonsByArray:bigandSmallArray selectedCompanySet:self.daxiaoSelectedCompanySet];
            break;
        }
        default:
            break;
    }
}

#define OVER_SELECT -1
#define SUCCESS_SELECT 0
- (int)selectCompanyToSet:(NSMutableSet*)selectedCompanySet companyId:(int)companyIdInt
{
    CompanyManager* manager = [CompanyManager defaultCompanyManager];
    Company* company = [manager getCompanyById:[NSString stringWithFormat:@"%d", companyIdInt]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FNS(@"最多只能选四个") 
                                                    message:FNS(@"") 
                                                   delegate:nil 
                                          cancelButtonTitle:FNS(@"好了，我知道了") 
                                          otherButtonTitles: nil];
    if ([selectedCompanySet containsObject:company.companyId]) {
        [selectedCompanySet removeObject:company.companyId];
        
    }
    else {
        if ([selectedCompanySet count] >= 4) {
            [alert show];
            [alert release];
            return OVER_SELECT;
        }
        [selectedCompanySet addObject:company.companyId];
    }
    return SUCCESS_SELECT;
}


- (IBAction)buttonClicked:(id)sender 
{
    UIButton *button = (UIButton*)sender;
    int companyIdInt = button.tag - COMPANY_ID_BUTTON_OFFSET;
    int result; 
    switch (contentType) {
        case ASIANBWIN: {
            result = [self selectCompanyToSet:self.yapeiSelectedCompanySet companyId:companyIdInt];
            break;
        }
        case EUROPEBWIN: {
            result = [self selectCompanyToSet:self.oupeiSelectedCompanySet companyId:companyIdInt];
            break;
        }
        case BIGANDSMALL: {
            result = [self selectCompanyToSet:self.daxiaoSelectedCompanySet companyId:companyIdInt];
            break;
        }
        default:
            break;
    }
    if (result == OVER_SELECT) {
        return;
    }
    if ([button isSelected]) {
        [button setSelected:NO];
    } else {
        [button setSelected:YES];
    }
    
}

- (void)clickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickDone:(id)sender
{
    CompanyManager* manager = [CompanyManager defaultCompanyManager];
    
    manager.selectedOddsType = self.selectedOddsType;
    [manager.selectedCompany removeAllObjects];
    switch (contentType) {
        case ASIANBWIN: {
            for (NSString* companyId in [self.yapeiSelectedCompanySet allObjects]) {
                Company* company = [manager getCompanyById:companyId];
                [manager.selectedCompany addObject:company];
            }
            break;
        }
        case EUROPEBWIN: {
            for (NSString* companyId in [self.oupeiSelectedCompanySet allObjects]) {
                Company* company = [manager getCompanyById:companyId];
                [manager.selectedCompany addObject:company];
            }
            break;
        }
        case BIGANDSMALL: {
            for (NSString* companyId in [self.daxiaoSelectedCompanySet allObjects]) {
                Company* company = [manager getCompanyById:companyId];
                [manager.selectedCompany addObject:company];
            }
            break;
        }
        default:
            break;
    }
    if ([[manager selectedCompany] count] <= 0) {  
        [self popupMessage:@"至少选择一间赔率公司" title:nil];
        return;
    }
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


- (void)createButtonsByArray:(NSArray*)array selectedCompanySet:(NSMutableSet*)selectedCompanySet
{
    NSMutableArray* buttonArray = [[NSMutableArray alloc] init];
    for (NSString* companyId in array) {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(160, 160, 72, 32)];
        Company* company = [[CompanyManager defaultCompanyManager] getCompanyById:companyId];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button setTitle:company.companyName forState:UIControlStateNormal];
        [button setTitle:company.companyName forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"set2.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"set.png"] forState:UIControlStateSelected];
        [button setTitleColor:[ColorManager MatchesNameButtonNotChosenColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTag:([company.companyId intValue] + COMPANY_ID_BUTTON_OFFSET)];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if ([selectedCompanySet containsObject:company.companyId]) {
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
