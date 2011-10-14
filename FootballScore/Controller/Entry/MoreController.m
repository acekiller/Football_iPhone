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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"more"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"more"] autorelease];
        cell.textLabel.text = [listData objectAtIndex:[indexPath row]];
        
    }
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

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark optionsSelection

- (void)showLanguageSelection
{
    UIActionSheet *languageTable = [[UIActionSheet alloc]initWithTitle:FNS(@"请选择语言习惯") 
                                                              delegate:self 
                                                     cancelButtonTitle:@"取消" 
                                                destructiveButtonTitle:@"中国大陆" 
                                                     otherButtonTitles:@"廣東/香港", nil];
    
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

@end
