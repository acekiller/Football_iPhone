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

@implementation RepositoryController
@synthesize repositoryScrollView;
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
    [repositoryScrollView release];
    [filterCountryArray release];
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
#define CONTINENT_END_BUTTON_TAG 1605
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





- (void)clickCountry:(id)sender
{
    UIButton *button = (UIButton *)sender;
    Country *country = [self getCountryWithButtonTag:button.tag];
    if (country) {
        NSLog(@"click country: id = %d, name = %@", [country.countryId integerValue],country.countryName);    
    }
    
}

- (void)createButtonsBycountryArray:(NSArray*) countryArray action:(SEL)action
{
    if ([countryArray count] == 0) {
        return;
    }
    NSMutableArray* buttonArray = [[NSMutableArray alloc] init];
    for (Country* country in countryArray) {
        NSString *title = country.countryName;
        NSInteger tag = [country.countryId intValue] + COUNTRY_ID_BUTTON_OFFSET;
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(160, 160, 72, 32)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button setTitle:title forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"set.png"] 
                          forState:UIControlStateNormal];
        [button setTitleColor:[ColorManager MatchesNameButtonNotChosenColor] 
                     forState:UIControlStateNormal];
        [button setTag:tag];
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:button];
        [button release];
    }
    
    UIScrollView *buttonScrollView = [PPViewController createButtonScrollViewByButtonArray:buttonArray buttonsPerLine:COUNTRY_BUTTON_COUNT_PER_ROW];
    [buttonArray release];
    [[self.view viewWithTag:SCROLL_VIEW_TAG] removeFromSuperview];
    buttonScrollView.tag = SCROLL_VIEW_TAG;     
    [buttonScrollView setFrame:CGRectMake(0, 85, 320, 480-85-55)];
    [self.view addSubview:buttonScrollView];
    
}

- (void) fillCountryButtons
{
    [self createButtonsBycountryArray:self.filterCountryArray
                               action:@selector(clickCountry:)];
}


- (IBAction)clickContinent:(id)sender {
    UIButton *button = (UIButton *)sender;
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



#pragma mark - RepositoryService delegate

- (void)willUpdateRepository
{
    [self showActivityWithText:FNS(@"加载数据中......")];
}
- (void)didUpdateRepository:(NSInteger)errorCode
{
    [self fillContinentButtons];
    
    self.filterCountryArray = [[RepositoryManager defaultManager] filterCountryArrayWithContinentId:selectedContinent];
    
    [self fillCountryButtons];
    [self hideActivity];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationRightButtonWithSystemStyle:UIBarButtonSystemItemRefresh action:@selector(clickRefresh)];
    selectedContinent = 0;
    [self clickRefresh];
}

- (void)viewDidUnload
{
    [self setRepositoryScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
