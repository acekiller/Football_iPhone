//
//  MoreController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MoreController.h"
#import "LocaleConstants.h"
#import "AlertController.h"
#import "UserFeedbackController.h"
#import "ShowRealtimeScoreController.h"
#import "MatchManager.h"
#import "UITableViewCellUtil.h"
#import "AboutController.h"
//#import "FootballScoreAppDelegate.h"
//@class FootballScoreAppDelegate;

@implementation MoreController
@synthesize listData;
@synthesize moreOptionList;

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
    [listData release];
    [moreOptionList release];
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
    [self optionListInit];  
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:0xE3/255.0 green:0xE8/255.0 blue:0xEA/255.0 alpha:1.0];
}

- (void)viewDidUnload
{
    [self setListData:nil];
    [self setMoreOptionList:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)optionListInit
{
    NSArray *array = [[NSArray alloc] initWithObjects:FNS(@"完整比分"), FNS(@"一周赛程"), FNS(@"比分提示设置"), FNS(@"语言简繁设置"), FNS(@"信息反馈"), FNS(@"推荐给好友"), FNS(@"关于彩客网"), FNS(@"客户端更新"), FNS(@"退出客户端"),  nil];
    self.listData = array;
    [array release];
}

#pragma mark -
#pragma mark delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex){
		return;
	}
    
    if (buttonIndex == language){
        // same type, no change, return directly
        return;
    }
    
    language = buttonIndex;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37.0f;	
}	

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return NO; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"more"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"more"] autorelease];
        cell.textLabel.text = [listData objectAtIndex:[indexPath row]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        cell.textLabel.textColor=[UIColor colorWithRed:0x46/255.0 green:0x46/255.0 blue:0x46/255.0 alpha:1.0];
        
        UIImage* image = [UIImage imageNamed:@"szicon_a.png"];
        UIImageView* cellAccessoryView = [[UIImageView alloc] initWithImage:image];
        cell.accessoryView = cellAccessoryView;
        [cellAccessoryView release];
        
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0x2F/255.0 green:0x76/255.0 blue:0xB9/255.0 alpha:1.0];
        
        
    }
    
    UIImage *image = nil;
    switch ([indexPath row]) {
        case 0:
            image = [UIImage imageNamed:@"szicon1.png"];
            break;
        case 1:
            image = [UIImage imageNamed:@"szicon2.png"];
            break;
        case 2:
            image = [UIImage imageNamed:@"szicon3.png"];
            break;
        case 3:
            image = [UIImage imageNamed:@"szicon4.png"];
            break;
        case 4:
            image = [UIImage imageNamed:@"szicon5.png"];
            break;
        case 5:
            image = [UIImage imageNamed:@"szicon6.png"];
            break;
        case 6:
            image = [UIImage imageNamed:@"szicon7.png"];
            break;
        case 7:
            image = [UIImage imageNamed:@"szicon8.png"];
            break;
        case 8:
            image = [UIImage imageNamed:@"szicon9.png"];
            break;
        default:
            break;
    }
    
    cell.imageView.image = image;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];	
    
    
    //set backgroudView
    UIImageView *imageView = nil;
    
    if (0 == [indexPath row] )
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"helptable_top.png"]];
    else if (8 == [indexPath row])
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"helptable_bottom.png"]];
    else
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"helptable_middle.png"]];
    
    cell.backgroundView=imageView;
    cell.backgroundView.backgroundColor = [UIColor clearColor];
        
    [imageView release];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *rowValue = [listData objectAtIndex:row];
    
    if ([rowValue isEqualToString:FNS(@"语言简繁设置")])
        [self showLanguageSelection];
  
    if ([rowValue isEqualToString:FNS(@"比分提示设置")])
        [self showScoreAlert];

    if ([rowValue isEqualToString:FNS(@"信息反馈")])
        [self showFeedback];
    
    if ([rowValue isEqualToString:FNS(@"推荐给好友")])
        [self showRecommendation];

    if ([rowValue isEqualToString:FNS(@"关于彩客网")])
        [self showAbout];

    if ([rowValue isEqualToString:FNS(@"退出客户端")]){
    }

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark optionsSelection

- (void)showLanguageSelection
{
    UIActionSheet *languageTable = [[UIActionSheet alloc]initWithTitle:FNS(@"请选择语言习惯") 
                                                              delegate:self 
                                                     cancelButtonTitle:FNS(@"取消") 
                                                destructiveButtonTitle:FNS(@"国语") 
                                                     otherButtonTitles:FNS(@"粤语"),FNS(@"简体"), nil];
    
    [languageTable showFromTabBar:self.tabBarController.tabBar];
    [languageTable release];
}

- (void)showFeedback
{
     UserFeedbackController *fb = [[UserFeedbackController alloc] init];
    [self.navigationController pushViewController:fb animated:YES];
    [fb release];
}

- (void)showScoreAlert
{
    AlertController *vc = [[AlertController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
}

- (void)showRecommendation
{
//    NSArray* matchArray = [[MatchManager defaultManager] matchArray];
//    int index = rand() % [matchArray count];
//    Match* match = [matchArray objectAtIndex:index];
//    [ShowRealtimeScoreController show:match];
}

- (void)showAbout
{
    AboutController *ac = [[AboutController alloc] init];
    [self.navigationController pushViewController:ac animated:YES];
    [ac release];
}

@end
