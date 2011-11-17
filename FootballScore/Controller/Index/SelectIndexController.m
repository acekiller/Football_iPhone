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

#define SCROLL_VIEW_TAG 20111109
#define COMPANY_ID_BUTTON_OFFSET 120111109
#define CONTENT_TYPE_OFFSET 220111108

@implementation SelectIndexController
@synthesize buttonAsianBwin;
@synthesize buttonEuropeBwin;
@synthesize buttonBigandSmall;
@synthesize delegate;

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
    asianBwinArray = [[NSMutableArray alloc] init];
    europeBwinArray = [[NSMutableArray alloc] init];
    bigandSmallArray = [[NSMutableArray alloc] init];
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
    
    [self.navigationItem setTitle:@"内容筛选"];
    [self setNavigationLeftButton:FNS(@"返回") imageName:@"ss.png"  action:@selector(clickBack:)];
    [self setNavigationRightButton:fns(@"完成") imageName:@"ss.png" action:@selector(clickDone:)];

    [self dataInit];
    [self buttonsInit];
    
    [self clickContentTypeButton: buttonAsianBwin];

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

- (void)buttonsInit
{
    [buttonAsianBwin setTag:ASIANBWIN];
    [buttonEuropeBwin setTag:EUROPEBWIN];
    [buttonBigandSmall setTag:BIGANDSMALL];
    
    
}

- (void)dataInit
{

    CompanyManager* manager = [CompanyManager defaultCompanyManager];
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
    selectedBwin = [[NSMutableSet alloc] init];
}

- (IBAction)clickContentTypeButton:(id)sender
{
    contentType = [sender tag];
    [[CompanyManager defaultCompanyManager] setSelectedOddsType:(contentType-CONTENT_TYPE_OFFSET)];
    for (int i = ASIANBWIN; i <= BIGANDSMALL; i++) {
        UIButton* button = (UIButton*)[self.view viewWithTag:i];
        if ( contentType== i) {
            [button setSelected:YES];
        }
        else {
            [button setSelected:NO];
        }

    }  
    [selectedBwin removeAllObjects];
    [[CompanyManager defaultCompanyManager].selectedCompany removeAllObjects];
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
    UIButton *button = (UIButton*)sender;
    UILabel *label = [button titleLabel];
    NSString *title = label.text;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FNS(@"最多只能选四个") 
                                                    message:FNS(@"") 
                                                   delegate:nil 
                                          cancelButtonTitle:FNS(@"好了，我知道了") 
                                          otherButtonTitles: nil];
    
    if ([selectedBwin containsObject:title]) {
        [selectedBwin removeObject:title];
        [button setSelected:NO];
        [[CompanyManager defaultCompanyManager] unselectCompanyById:[NSString stringWithFormat:@"%d", button.tag - COMPANY_ID_BUTTON_OFFSET]];

    }
    else {
        if ([selectedBwin count] > 40000) {
            [alert show];
            [alert release];
            return;
        }
        [selectedBwin addObject:title];
        [button setSelected:YES];
        [[CompanyManager defaultCompanyManager] selectCompanyById:[NSString stringWithFormat:@"%d", button.tag - COMPANY_ID_BUTTON_OFFSET]];
    }
}

- (void)clickBack:(id)sender
{
    //CompanyManager* manager = [CompanyManager defaultCompanyManager];
    //here should use CompanyManager to get Odds
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickDone:(id)sender
{
    CompanyManager* manager = [CompanyManager defaultCompanyManager];
    if (delegate && [delegate respondsToSelector:@selector(SelectCompanyFinish)]) {
        [delegate SelectCompanyFinish];
    }
    //here should use CompanyManager to get Odds
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark test new static method to build buttons

+ (UIScrollView*)createButtonScrollViewByButtonArray:(NSArray*)buttons 
                             buttonsPerLine:(int)buttonsPerLine 
{
    float buttonLen;
    float buttonHeight;
    int fitButtonsPerLine;
    int rowIndex;
    int columnIndex;
    UIScrollView* scrollView = [[[UIScrollView alloc] init] autorelease];
    
    UIButton* button1 = [buttons objectAtIndex:0];
    buttonLen = button1.frame.size.width;
    buttonHeight = button1.frame.size.height;
    fitButtonsPerLine = 320/buttonLen;
      
    if (buttonLen*buttonsPerLine <=  320 && buttonsPerLine >= 0) {
        fitButtonsPerLine = buttonsPerLine;
    } 
      
    float buttonSeparatorX = (320-fitButtonsPerLine*buttonLen)/(fitButtonsPerLine+1);
    float buttonSeparatorY =2*buttonHeight/fitButtonsPerLine;
      
    for (int i=0; i<[buttons count]; i++) {
        //
        rowIndex = i/buttonsPerLine;
        columnIndex = i%buttonsPerLine;
        UIButton *button = [buttons objectAtIndex:i];
        button.frame = CGRectMake(buttonSeparatorX+columnIndex*(buttonSeparatorX+buttonLen), rowIndex*(buttonHeight+buttonSeparatorY),buttonLen, buttonHeight);
        [scrollView addSubview:button];
        }
    [scrollView setContentSize:CGSizeMake(320, ([buttons count]/fitButtonsPerLine+1)*(buttonHeight+buttonSeparatorY))];
    return scrollView;   
}

- (void)createButtonsByArray:(NSArray*)array
{
    NSMutableArray* buttonArray = [[NSMutableArray alloc] init];
    for (Company* company in array) {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(160, 160, 72, 37)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button setTitle:company.companyName forState:UIControlStateNormal];
        [button setTitle:company.companyName forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"set2.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"set.png"] forState:UIControlStateSelected];
        [button setTitleColor:[ColorManager MatchesNameButtonNotChosenColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTag:([company.companyId intValue] + COMPANY_ID_BUTTON_OFFSET)];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if ([[CompanyManager defaultCompanyManager].selectedCompany containsObject:company]) {
            [button setSelected:YES];
        }
        else {
            [button setSelected:NO];
        }
        [buttonArray addObject:button];
        [button release];
    }
    UIScrollView* buttonScrollView = [SelectIndexController createButtonScrollViewByButtonArray:buttonArray buttonsPerLine:3];
    [buttonArray release];
    [[self.view viewWithTag:SCROLL_VIEW_TAG] removeFromSuperview];
    buttonScrollView.tag = SCROLL_VIEW_TAG;     
    [buttonScrollView setFrame:CGRectMake(0, 147, 320, 243)];
    [self.view addSubview:buttonScrollView];

}

@end
