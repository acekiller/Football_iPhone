//
//  ScheduleController.m
//  FootballScore
//
//  Created by Orange on 11-12-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ScheduleController.h"
#import "LocaleConstants.h"
#import "MatchManager.h"
#import "Match.h"
#import "LeagueManager.h"
#import "TimeUtils.h"

@implementation ScheduleController
@synthesize dateLabel;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setDateLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - PPTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20.0f;	
}	

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:@"test"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"] autorelease];
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:10]];
        cell.textLabel.textColor=[UIColor colorWithRed:0x46/255.0 green:0x46/255.0 blue:0x46/255.0 alpha:1.0];

    }
    Match* match = [self.dataList objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@ vs %@ ",[[LeagueManager defaultScheduleManager] getNameById:match.leagueId ], match.homeTeamName, match.awayTeamName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return NO; 
}

#pragma mark - ScheduleDelegate
- (void)getMatchScheduleFinish
{
    [self hideActivity];
    self.dataList = [[MatchManager defaultMatchScheduleManager] matchArray];
    [self.dateLabel setText:dateToString([MatchManager defaultMatchScheduleManager].serverDate)];
    [self.dataTableView reloadData];
}

+ (void)showWithSuperController:(UIViewController*)superViewController
{
    ScheduleController* vc = [[ScheduleController alloc] init];
    [superViewController.navigationController pushViewController:vc animated:YES];
    [GlobalGetScheduleService() getSchedule:vc date:nil];
    [vc showActivityWithText:FNS(@"loading")];
    [vc release];
}

- (IBAction)clicksSelectDateButton:(id)sender
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    UIActionSheet *dateActionSheet = [[UIActionSheet alloc]initWithTitle:FNS(@"历史回查") 
                                                                delegate:self 
                                                       cancelButtonTitle:FNS(@"返回")
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:nil];
    
    int i;
    NSTimeInterval interval;
    NSString *dateString = nil;
    NSDate *beforeDate=[NSDate date];
    
    for (i = 0 ; i<7 ;i++)
    {
        interval = 24*60*60*i;
        beforeDate = [date dateByAddingTimeInterval:-interval];
        dateString = [df stringFromDate:beforeDate];
        [dateActionSheet addButtonWithTitle: dateString];
    }
    
    [dateActionSheet showFromTabBar:self.tabBarController.tabBar];
    
    [dateActionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)dealloc {
    [dateLabel release];
    [super dealloc];
}
@end
