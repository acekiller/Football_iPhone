//
//  RealtimeScoreCell.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RealtimeScoreCell.h"
#import "Match.h"
#import "LeagueManager.h"

@implementation RealtimeScoreCell
@synthesize matchTypeLabel;
@synthesize startTimeLabel;
@synthesize matchStatusLabel;
@synthesize awayTeamLabel;
@synthesize homeTeamLabel;
@synthesize peilvLabel;
@synthesize halfScoreLabel;
@synthesize scoreLabel;
@synthesize awayRedCard;
@synthesize awayYellowCard;
@synthesize homeRedCard;
@synthesize homeYellowCard;
@synthesize followStatus;

// just replace PPTableViewCell by the new Cell Class Name
+ (RealtimeScoreCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RealtimeScoreCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <PPTableViewCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((PPTableViewCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (RealtimeScoreCell*)[topLevelObjects objectAtIndex:0];
}

+ (NSString*)getCellIdentifier
{
    return @"RealtimeScoreCell";
}

+ (CGFloat)getCellHeight
{
    return 62.0f;
}

- (void)dealloc {
    [matchTypeLabel release];
    [startTimeLabel release];
    [matchStatusLabel release];
    [awayTeamLabel release];
    [homeTeamLabel release];
    [peilvLabel release];
    [halfScoreLabel release];
    [scoreLabel release];
    [awayRedCard release];
    [awayYellowCard release];
    [homeRedCard release];
    [homeYellowCard release];
    [followStatus release];
    [super dealloc];
}

- (void)setCellInfo:(Match*)match
{
    scoreLabel.text = [NSString stringWithFormat:@"%@ : %@", match.homeTeamScore, match.awayTeamScore];

    homeTeamLabel.text = match.homeTeamName;
    awayTeamLabel.text = match.awayTeamName;
    
    LeagueManager *league = [LeagueManager defaultManager];
    matchTypeLabel.text = [league getNameById:match.leagueId];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    startTimeLabel.text = [NSString stringWithFormat:@"t%@",[formatter stringFromDate:match.date]];
        
    [awayRedCard setTitle:match.awayTeamRed forState:UIControlStateNormal];
    [homeRedCard setTitle:match.homeTeamRed forState:UIControlStateNormal];

    [formatter release];
    
}

- (IBAction)clickFollowButton:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(didClickFollowButton:atIndex:)]){
        [delegate didClickFollowButton:sender atIndex:indexPath];
    }
}

@end
