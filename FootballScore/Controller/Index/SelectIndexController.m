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
#define CONTENT_TYPE_OFFSET 220111109

@implementation SelectIndexController
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

- (id)init
{
    [super init];
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
    
    [self.navigationItem setTitle:@"内容筛选"];
    [self setNavigationLeftButton:FNS(@"返回") imageName:@"ss.png"  action:@selector(clickBack:)];
    [self setNavigationRightButton:fns(@"完成") imageName:@"ss.png" action:@selector(clickBack:)];
       
    
    
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
    [buttonAsianBwin setTag:ASIANBWIN];
    [buttonAsianBwin setBackgroundImage:[UIImage imageNamed:@"set2.png"] forState:UIControlStateNormal];
    [buttonEuropeBwin setTag:EUROPEBWIN];
    [buttonEuropeBwin setBackgroundImage:[UIImage imageNamed:@"set2.png"] forState:UIControlStateNormal];
    [buttonBigandSmall setTag:BIGANDSMALL];
    [buttonBigandSmall setBackgroundImage:[UIImage imageNamed:@"set2.png"] forState:UIControlStateNormal];
    
    
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
    buttonsArray = [[NSMutableArray alloc] init];
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
            [button setBackgroundImage:[UIImage imageNamed:@"set.png"] forState:UIControlStateNormal];
        }
        else {
            [button setSelected:NO];
            [button setBackgroundImage:[UIImage imageNamed:@"set2.png"] forState:UIControlStateNormal];
            [button setTitleColor:[ColorManager MatchesNameButtonNotChosenColor] forState:UIControlStateNormal];
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
    [[CompanyManager defaultCompanyManager].selectedCompany removeAllObjects];
    int i = 0;
    CGSize buttonSize = CGSizeMake(72,37);
    UIImage *selectedImage = [UIImage imageNamed:@"set.png"];
    UIImage *unSelectedImage = [UIImage imageNamed:@"set2.png"];
    [buttonsArray removeAllObjects];
    [selectedBwin removeAllObjects];

    
    for (i = 0; i < [array count]; i++) {
        Company* company = [array objectAtIndex:i];
        NSString *title = company.companyName;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTag:([company.companyId intValue] + COMPANY_ID_BUTTON_OFFSET)];
        if ([selectedArray containsObject:title]) {
            [button setSelected:YES];
        }
        else {
            [button setSelected:NO];
        }
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsArray addObject:button];        
    }
    
    [[self.view viewWithTag:SCROLL_VIEW_TAG] removeFromSuperview];
    UIScrollView* buttonScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 147, 320, 243)];
    buttonScrollView.tag = SCROLL_VIEW_TAG;
    [SelectIndexController showButtonsAtScrollView:buttonScrollView 
                                   withButtonArray:buttonsArray 
                                     selectedImage:selectedImage 
                                   unSelectedImage:unSelectedImage 
                                    buttonsPerLine:3
                                        buttonSize:buttonSize];
    [self.view addSubview:buttonScrollView];
    [buttonScrollView release];
    
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
    float buttonSeparatorY =2*buttonSize.height/buttonsPerLine;
    float buttonLen = buttonSize.width;
    float buttonHigh = buttonSize.height;
    
    for (i = 0; i < [buttonArray count]; i++) {
        rowIndex = i/buttonsPerLine;
        rankIndex = i%buttonsPerLine;
        UIButton *button = [buttonArray objectAtIndex:i];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        if ([button isSelected]) {
            [button setBackgroundImage:selectedImage forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else {
            [button setBackgroundImage:unSelectedImage forState:UIControlStateNormal];
            [button setTitleColor:[ColorManager MatchesNameButtonNotChosenColor] forState:UIControlStateNormal];
        }
        button.frame = CGRectMake(buttonSeparatorX+rankIndex*(buttonSeparatorX+buttonLen), rowIndex*(buttonHigh+buttonSeparatorY), buttonLen, buttonHigh);
        //To set the text Color of the Button 
       // button.titleLabel.textColor=[UIColor blackColor];
                [scrollView addSubview:button];
    }
    [scrollView setContentSize:CGSizeMake(320, ([buttonArray count]/buttonsPerLine+1)*(buttonHigh+buttonSeparatorY))];  
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
        [button setBackgroundImage:[UIImage imageNamed:@"set2.png"] forState:UIControlStateNormal];
        [button setTitleColor:[ColorManager MatchesNameButtonNotChosenColor] forState:UIControlStateNormal];
        [button setSelected:NO];
        [[CompanyManager defaultCompanyManager] unselectCompanyById:[NSString stringWithFormat:@"%d", button.tag - COMPANY_ID_BUTTON_OFFSET]];
        
       

    }
    else {
        if ([selectedBwin count] >= 4) {
            [alert show];
            [alert release];
            return;
        }
        [selectedBwin addObject:title];
        [button setBackgroundImage:[UIImage imageNamed:@"set.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setSelected:YES];
        [[CompanyManager defaultCompanyManager] selectCompanyById:[NSString stringWithFormat:@"%d", button.tag - COMPANY_ID_BUTTON_OFFSET]];
    }

   

}

- (void)clickBack:(id)sender
{
    //CompanyManager* manager = [CompanyManager defaultCompanyManager];
    //here should use CompanyManager to get Odds
}


@end
