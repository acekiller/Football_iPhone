//
//  LeagueController.m
//  FootballScore
//
//  Created by  on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LeagueController.h"
#import "League.h"
#import "LocaleConstants.h"
#import "ColorManager.h"
#import "LeagueScheduleController.h"
#import "CupScheduleController.h"
#import "LogUtil.h"

@implementation LeagueController
@synthesize scheduleController = _scheduleController;
@synthesize cupScheduleController = _cupScheduleController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithLeagueArray:(NSArray *)leagueArray
{
    self = [super init];
    if (self) {
        self.dataList = leagueArray;
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
    NSString * leftButtonName = @"ss.png";    
    [self setNavigationLeftButton:FNS(@"返回") imageName:leftButtonName action:@selector(clickBack:)];
    [self.view setBackgroundColor:[ColorManager blackGroundColor]];
    
    if (dataList == nil || [dataList count] == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 320, 40)];
        [label setText:@"未能搜索到相关信息"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:UITextAlignmentCenter];
        [self.view addSubview:label];
        [label release];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeagueCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setTextColor:[ColorManager repositoryLegueUnselectedColor]];
        //set cell backgroud view
        UIView *bgView = [[UIView alloc] init];
        cell.backgroundView = bgView;
        [bgView release];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"data_s_y1.png"]];
        [bgImageView setFrame:CGRectMake(9, 2, 302, 32)];
        [cell.backgroundView addSubview:bgImageView];
        [bgImageView release];
        
        //set cell selection background view
        UIView *selectionBgView = [[UIView alloc] init];
        cell.selectedBackgroundView = selectionBgView;
        [selectionBgView release];        
        UIImageView *selectionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"data_s_y2.png"]];
        [selectionImageView setFrame:CGRectMake(9, 2, 302, 32)];
        [cell.selectedBackgroundView addSubview:selectionImageView];
        [selectionImageView release];
    }
    //config the cell
    League *league = [dataList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"  %@",league.name];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}
#define LEAGUE_MATCH 1
#define CUP_MATCH 2

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    League* league = [self.dataList objectAtIndex:indexPath.row];
    switch (league.leagueType) {
        case LEAGUE_MATCH: {
            if (self.scheduleController == nil) {
                LeagueScheduleController* vc = [[LeagueScheduleController alloc] initWithLeague:league];
                self.scheduleController = vc;
                [vc release];
            } else {
                [self.scheduleController resetWithLeague:league];
            }
            [self.navigationController pushViewController:self.scheduleController animated:YES];
        }
            break;
        case CUP_MATCH: {
            if (self.cupScheduleController == nil) {
                CupScheduleController* vc = [[CupScheduleController alloc] initWithLeague:league];
                self.cupScheduleController = vc;
                [vc release];
            } else {
                [self.cupScheduleController resetWithLeague:league];
            }
            [self.navigationController pushViewController:self.cupScheduleController animated:YES];
        }
            break;
        default:
            PPDebug(@"<LeagueController> Unrecongnized league type:%d", league.leagueType);
            break;
    }
    
}

@end
