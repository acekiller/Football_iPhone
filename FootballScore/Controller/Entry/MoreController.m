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
#import "UITableViewCellUtil.h"
#import "AboutController.h"
#import "LanguageManager.h"
#import "ScheduleController.h"
#import "UserService.h"
#import "UIUtils.h"
#import "FootballScoreAppDelegate.h"


enum actionsheetNumber{
    LANGUAGE_SELECTION,
    RECOMMENDATION,
};



typedef enum {
    SIMPLIFY_MANADRIN = 1,
    SIMPLIFY_CANTONESE,
    TRADITIONAL_CANTONESE
    } LANGUAGE_TYPE;

typedef enum {
    COMPLETE_SCORE = 0,
    WEEK_SCHEDUAL,
    SCORE_NOTICE_SETTING,
    LANGUAGE_SETTING,
    FEEDBACK,
    RECOMMEND,
    ABOUT,
    UPDATE,
    QUIT
    } MORE_SELECTION;

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
        case COMPLETE_SCORE:
            image = [UIImage imageNamed:@"szicon1.png"];
            break;
        case WEEK_SCHEDUAL:
            image = [UIImage imageNamed:@"szicon2.png"];
            break;
        case SCORE_NOTICE_SETTING:
            image = [UIImage imageNamed:@"szicon3.png"];
            break;
        case LANGUAGE_SETTING:
            image = [UIImage imageNamed:@"szicon4.png"];
            break;
        case FEEDBACK:
            image = [UIImage imageNamed:@"szicon5.png"];
            break;
        case RECOMMEND:
            image = [UIImage imageNamed:@"szicon6.png"];
            break;
        case ABOUT:
            image = [UIImage imageNamed:@"szicon7.png"];
            break;
        case UPDATE:
            image = [UIImage imageNamed:@"szicon8.png"];
            break;
        case QUIT:
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
    switch (row) {
        case COMPLETE_SCORE:
            [ScheduleController showFinishedMatchWithSuperController:self];
            break;
        case WEEK_SCHEDUAL:
            [ScheduleController showScheduleWithSuperController:self];
            break;
        case SCORE_NOTICE_SETTING:
            [self showScoreAlert];
            break;
        case LANGUAGE_SETTING:
            [self showLanguageSelection];
            break;
        case FEEDBACK:
            [self showFeedback];
            break;
        case RECOMMEND:
            [self showRecommendation];
            break;
        case ABOUT:
            [self showAbout];
            break;
        case UPDATE:
            [self updateApplication];
            break;
        case QUIT:
            [self quitApplication];
            break;
        default:
            break;
    }

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (LANGUAGE_SELECTION == whichAcctionSheet) 
    {
        if (buttonIndex == actionSheet.cancelButtonIndex){
            return;
        }
        
        [LanguageManager setLanguage:buttonIndex];
        
    }
    else if (RECOMMENDATION == whichAcctionSheet)
    {
        if (buttonIndex == actionSheet.cancelButtonIndex){
            return;
        }
        else if (buttonIndex == 0)
        {
            [self sendSms:@"" body:FNS(@"朋友，我正在用球探彩客网的比分客户端看即时比分、赔率、分析数据，感觉很不错，下载地址是xxxxxxxxx")];
        }
        else if (buttonIndex == 1)
        {
            [self sendEmailTo:nil 
                 ccRecipients:nil 
                bccRecipients:nil 
                      subject:FNS(@"向你推荐彩客网的比分客户端") 
                         body:FNS(@"朋友，我正在用球探彩客网的比分客户端看即时比分、赔率、分析数据，感觉很不错，下载地址是xxxxxxxxx") 
                       isHTML:NO 
                     delegate:self];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            exit(0);
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark optionsSelection

- (void)showLanguageSelection
{
    whichAcctionSheet = LANGUAGE_SELECTION;
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
    whichAcctionSheet = RECOMMENDATION;
    UIActionSheet *share = [[UIActionSheet alloc] initWithTitle:FNS(@"请选择推荐方式") 
                                                       delegate:self 
                                              cancelButtonTitle:FNS(@"取消") 
                                         destructiveButtonTitle:FNS(@"短信") 
                                              otherButtonTitles:FNS(@"邮件"), nil];
    [share showFromTabBar:self.tabBarController.tabBar];
    [share release];
}

- (void)showAbout
{
    AboutController *ac = [[AboutController alloc] init];
    [self.navigationController pushViewController:ac animated:YES];
    [ac release];
}

- (void)updateApplication
{
//    [self showActivityWithText:@"正在检查版本..."];
    UserService *userService = [[[UserService alloc] init] autorelease];
    [userService getVersion:self];
    
}

- (void)getVersionFinish:(int)result data:(NSString*)data
{
//    [self hideActivity];
    if (0 == result) 
    {
        NSString *latestVersion = data;
        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if ([latestVersion isEqualToString:localVersion]) 
        {
            [self popupHappyMessage:FNS(@"已经是最新版本") title:nil];
        }
        else
        {
            [UIUtils openApp:kAppId];  //跳到更新页面
        }
    }
    else
    {
        [self popupUnhappyMessage:FNS(@"查询版本失败") title:nil];
    }
}

- (void)quitApplication
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:FNS(@"确定退出客户端吗?") 
                                                  delegate:self 
                                         cancelButtonTitle:FNS(@"取消")  
                                         otherButtonTitles:FNS(@"确定") , nil];
    [alert show];
    [alert release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
            [self popupHappyMessage:FNS(@"邮件取消") title:nil];
			break;
		case MFMailComposeResultSaved:
            [self popupHappyMessage:FNS(@"邮件已保存") title:nil];
			break;
		case MFMailComposeResultSent:
            [self popupHappyMessage:FNS(@"邮件已发送") title:nil];
			break;
		case MFMailComposeResultFailed:
            [self popupUnhappyMessage:FNS(@"邮件发送失败") title:nil];
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

@end
