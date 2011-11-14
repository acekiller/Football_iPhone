//
//  RealtimeIndexController.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RealtimeIndexController.h"
#import "SelectIndexController.h"
#import "StatusView.h"
#import "ScoreIndexCell.h"
#import "OddsManager.h"
#import "Odds.h"

@implementation RealtimeIndexController
@synthesize matchOddsArray;

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
    [super viewDidLoad];
    OddsService* service = [[OddsService alloc] init];
    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
    [service getOddsListByDate:nil companyIdArray:array language:0 matchType:1 oddsType:1];
    
    OddsManager* manager = [OddsManager defaultManager];
    self.matchOddsArray  = [[NSMutableDictionary alloc] init];
    for (Odds* odds in manager.yapeiArray) {
        [self.matchOddsArray setObject:odds forKey:odds.matchId];
    }
    self.dataList = [matchOddsArray allKeys];
    [self.dataTableView reloadData];
    
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)clickContentFilterButton:(id)sender
{
    SelectIndexController *vc = [[SelectIndexController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma table view delegate
#pragma -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [ScoreIndexCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [ScoreIndexCell getCellIdentifier];
	ScoreIndexCell *cell = (ScoreIndexCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [ScoreIndexCell createCell:self];				
		cell.selectionStyle = UITableViewCellSelectionStyleNone;			        
	}		
    
    cell.indexPath = indexPath;
    
//    Match* match = [self.dataList objectAtIndex:indexPath.row];
//    [cell setCellInfo:match];
	
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma remote request delegate
#pragma -

- (void)getOddsListFinish:(NSMutableArray*)leagues matchArray:(NSMutableArray*)matches oddsArray:(NSMutableArray*)oddsList
{
    OddsManager* manager = [OddsManager defaultManager];
    manager.leagueArray = leagues;
    manager.matchArray = matches;
    manager.yapeiArray = oddsList;
    
}

@end
