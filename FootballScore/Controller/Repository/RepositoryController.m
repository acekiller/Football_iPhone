//
//  RepositoryController.m
//  FootballScore
//
//  Created by  on 11-12-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//


#import "RepositoryController.h"
#import "LanguageManager.h"
#import "LocaleConstants.h"
#import "RepositoryManager.h"
#import "Repository.h"
#import "League.h"
#import "ColorManager.h"
#import "LeagueController.h"
#import "PPNetworkRequest.h"
@implementation RepositoryController
@synthesize searchTextField;
@synthesize filterCountryArray;

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
    [filterCountryArray release];
    [searchTextField release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - action method

#define CONTINENT_BASE_BUTTON_TAG 1600
#define CONTINENT_AFRICA_TAG 1605
#define CONTINENT_END_BUTTON_TAG CONTINENT_AFRICA_TAG
#define CONTINENT_OCEANIA_TAG 1604
#define CONTINENT_ASIA_TAG 1603

#define COUNTRY_BUTTON_COUNT_PER_ROW 4
#define SCROLL_VIEW_TAG 2334
#define COUNTRY_ID_BUTTON_OFFSET 3000

- (NSInteger)getButtonTagWithCountry:(Country *)country
{
    return [country.countryId intValue] + COUNTRY_ID_BUTTON_OFFSET;
}

- (Country *)getCountryWithButtonTag:(NSInteger)tag
{
    NSString *countryId = [NSString stringWithFormat:@"%d",tag - COUNTRY_ID_BUTTON_OFFSET];
    return [[RepositoryManager defaultManager] getCountryById:countryId];
}

- (Continent *)getContinentWithButtonTag:(NSInteger)tag
{
    NSString *continentId = [NSString stringWithFormat:@"%d",tag - CONTINENT_BASE_BUTTON_TAG];
    return [[RepositoryManager defaultManager] getContinentById:continentId];
}
-(void) fillContinentButtons
{
    NSArray * continentList = [[RepositoryManager defaultManager]continentArray];
    int tag = CONTINENT_BASE_BUTTON_TAG;
    for (Continent *continent in continentList) {
        if (continent) {
            UIButton *button = (UIButton *)[self.view viewWithTag:(tag++)];
            button.hidden = NO;
            [button setTitle:continent.continentName forState:UIControlStateNormal];
        }
    }
    while (tag <= CONTINENT_END_BUTTON_TAG) {
        [[self.view viewWithTag:(tag++)] setHidden:YES];
    }
}


- (NSString *)getLeagueControllerTitle:(Country *)country
{
    NSString *name = country.countryName;
    NSString *title = @"";
    if (name == nil) {
        return FNS(@"赛事资料库");
    }
    if ([name length] >= 2) {
        NSString *str = [name substringFromIndex:(name.length - 2)];
        if ([str isEqualToString:@"赛事"] || [str isEqualToString:@"賽事"]) {
            title = [NSString stringWithFormat:@"%@%@",name,FNS(@"资料库")];
        }else{
            title = [NSString stringWithFormat:@"%@%@",name,FNS(@"赛事资料库")];
        }
    }else
    {
        title = [NSString stringWithFormat:@"%@%@",name,FNS(@"赛事资料库")];
    }
    return title;
}

- (void)clickCountry:(id)sender
{
    UIButton *button = (UIButton *)sender;
    Country *country = [self getCountryWithButtonTag:button.tag];
    if (country) {
        NSArray *leagueArray = [[RepositoryManager defaultManager] getLeagueArrayByCountryId:country.countryId];
        LeagueController *lc = [[LeagueController alloc]initWithLeagueArray:leagueArray];
        lc.title = [self getLeagueControllerTitle:country];
        [self.navigationController pushViewController:lc animated:YES];
        [lc release];
    }
    
}

- (void)createButtonsBycountryArray:(NSArray*) countryArray action:(SEL)action
{
    [[self.view viewWithTag:SCROLL_VIEW_TAG] removeFromSuperview];
    if ([countryArray count] == 0) {
        return;
    }
    NSMutableArray* buttonArray = [[NSMutableArray alloc] init];
    for (Country* country in countryArray) {
        NSString *title = country.countryName;
        NSInteger tag = [country.countryId intValue] + COUNTRY_ID_BUTTON_OFFSET;
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(160, 160, 72, 32)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitle:title forState:UIControlStateNormal];
        
        [button setBackgroundImage:[UIImage imageNamed:@"data_s_t1.png"] 
                          forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"data_s_t2.png"] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[ColorManager repositoryCountoryUnselectedColor] 
                     forState:UIControlStateNormal];
        
        [button setTag:tag];
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:button];
        [button release];
    }
    
    UIScrollView *buttonScrollView = [PPViewController createButtonScrollViewByButtonArray:buttonArray buttonsPerLine:COUNTRY_BUTTON_COUNT_PER_ROW buttonSeparatorY:8];
    
    [buttonArray release];
    buttonScrollView.tag = SCROLL_VIEW_TAG;     
    [buttonScrollView setFrame:CGRectMake(0, 95, 320, 310)];
    [buttonScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:buttonScrollView];
    
}

- (void) fillCountryButtons
{
    [self createButtonsBycountryArray:self.filterCountryArray
                                   action:@selector(clickCountry:)];
    
}

- (IBAction)clickContinent:(id)sender {
    if (sender == nil) {
        return;
    }
    UIButton *button = (UIButton *)sender;
    _selectedContinentButton = button;
    button.selected = YES;
    for (int i = CONTINENT_BASE_BUTTON_TAG; i <= CONTINENT_END_BUTTON_TAG; ++ i) {
        if (i != button.tag) {
            UIButton *unselectedButton = (UIButton *)[self.view viewWithTag:i];
            unselectedButton.selected = NO;
        }
    }
    Continent *continent = [self getContinentWithButtonTag:button.tag];
    selectedContinent = [continent.continentId integerValue];
    self.filterCountryArray = [[RepositoryManager defaultManager] filterCountryArrayWithContinentId:selectedContinent];
    [self fillCountryButtons];
}
     
-(void) clickRefresh
{
    RepositoryService *service = GlobalGetRepositoryService();
    NSInteger lang = [LanguageManager getLanguage];
    [service updateRepository:lang delegate:self];
}

#pragma mark - gesture recognizer

-(void) performPanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    if (_selectedContinentButton == nil) {
        return;
    }
    CGPoint point = [recognizer translationInView:self.view];
    NSInteger tag = _selectedContinentButton.tag;
    UIButton *button = nil;
    if (point.x < 0) {
        switch (tag) {
            case CONTINENT_BASE_BUTTON_TAG:
                break;
            case CONTINENT_AFRICA_TAG:
                button = (UIButton *)[self.view viewWithTag:tag - 2];
                break;
            case CONTINENT_OCEANIA_TAG:
                button = (UIButton *)[self.view viewWithTag:tag + 1];    
                break;
            default:
                button = (UIButton *)[self.view viewWithTag:tag - 1];    
                break;
        }
    }else{
        switch (tag) {
            case CONTINENT_AFRICA_TAG:
                button = (UIButton *)[self.view viewWithTag:tag - 1];
                break;
            case CONTINENT_OCEANIA_TAG:
                break;
            case CONTINENT_ASIA_TAG:
                button = (UIButton *)[self.view viewWithTag:tag + 2];    
                break;
            default:
                button = (UIButton *)[self.view viewWithTag:tag + 1];    
                break;
        }
    }
    [self clickContinent:button];
    
}

#pragma mark - RepositoryService delegate

- (void)willUpdateRepository
{
    [self showActivityWithText:FNS(@"加载数据中...")];
}
- (void)didUpdateRepository:(NSInteger)errorCode
{
    [self hideActivity];
    if (errorCode == ERROR_SUCCESS) {
        [self fillContinentButtons];
        
        self.filterCountryArray = [[RepositoryManager defaultManager] filterCountryArrayWithContinentId:selectedContinent];
        
        [self fillCountryButtons];
        
        // the first time refresh.
        if (selectedContinent < 0) {
            [self clickContinent:[self.view viewWithTag:CONTINENT_BASE_BUTTON_TAG + 1]];
        }
        
    }else{
        [self popupUnhappyMessage:FNS(@"kUnknowFailure") title:nil];
    }


}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setTextColor:[UIColor blackColor]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clickSearch:nil];
    return YES;
}

#pragma mark - View lifecycle

- (void)setLeftBarLogo
{
    UIView *leftTopBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    
    UIImageView *liveLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"data_logo.png"]];
    [leftTopBarView addSubview:liveLogo];
    [liveLogo release];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftTopBarView];
    [leftTopBarView release];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.title = @"";
    [leftBarButton release];
    
}

- (void)setRightBarButton
{
    float buttonHigh = 27.5;
    float buttonLen = 47.5;
    float refeshButtonLen = 32.5;
    float seporator = 5;
    float leftOffest = 20;
    UIView *rightButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3*(buttonLen+seporator), buttonHigh)];
    
    UIButton *refleshButton = [[UIButton alloc]initWithFrame:CGRectMake(leftOffest+(buttonLen+seporator)*2, 0, refeshButtonLen, buttonHigh)];
    [refleshButton setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [refleshButton setTitle:@"" forState:UIControlStateNormal];
    [refleshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [refleshButton addTarget:self action:@selector(clickRefresh) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:refleshButton];
    [refleshButton release];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    [rightButtonView release];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[ColorManager blackGroundColor]];
    [self setLeftBarLogo];
    [self setRightBarButton];
    selectedContinent = -1;
    
    RepositoryService *service = GlobalGetRepositoryService();
    NSArray *data = [service getLocalRepositoryData];
    if (data) {
        NSLog(@"<RepositoryController>:get storage repository data");
        [service dealWithOutputArray:data delegate:self];
    }else{
        NSLog(@"<RepositoryController>:local repository data is empty or timeout, update remote");
        NSInteger lang = [LanguageManager getLanguage];
        [service updateRepository:lang delegate:self];
    }
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(performPanGesture:)];
    [self.view addGestureRecognizer:panRecognizer];
    [panRecognizer release];

}

- (void)viewDidAppear:(BOOL)animated
{
    [self addBlankView:42 currentResponder:self.searchTextField];
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self setSearchTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)clickSearch:(id)sender {
    [self.searchTextField resignFirstResponder];
    NSArray *leagueArray = [[RepositoryManager defaultManager] getLeagueArrayByKey:searchTextField.text];
    LeagueController *lc = [[LeagueController alloc]initWithLeagueArray:leagueArray];
    lc.title = FNS(@"搜索结果");
    [self.navigationController pushViewController:lc animated:YES];
    [lc release];
}
@end
