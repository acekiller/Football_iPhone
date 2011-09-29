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
#import "DataUtils.h"

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
    int localLanguage = LANG_CANTON;
    scoreLabel.text = [NSString stringWithFormat:@"%@ : %@", match.homeTeamScore, match.awayTeamScore];
    halfScoreLabel.text = [NSString stringWithFormat:@"%@: %@",match.homeTeamFirstHalfScore,match.awayTeamFirstHalfScore];
    
    [homeRedCard setTitle:match.homeTeamRed forState:UIControlStateNormal];
    [homeYellowCard setTitle:match.homeTeamYellow forState:UIControlStateNormal];
    [awayRedCard setTitle:match.awayTeamRed forState:UIControlStateNormal];
    [awayYellowCard setTitle:match.awayTeamYellow forState:UIControlStateNormal];
    
    peilvLabel.text = [DataUtils toChuPanString:[match crownChuPan] language:localLanguage];
    //TODO:localLanguage should get from app

    homeTeamLabel.text = match.homeTeamName;
    awayTeamLabel.text = match.awayTeamName;
    
    LeagueManager *league = [LeagueManager defaultManager];
    matchTypeLabel.text = [league getNameById:match.leagueId];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSString *dateString = [NSString stringWithFormat:@""];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    if(nil !=[formatter stringFromDate:match.date])
        dateString = [formatter stringFromDate:match.date];
    startTimeLabel.text = dateString;
     [formatter release];
    
        
    [awayRedCard setTitle:match.awayTeamRed forState:UIControlStateNormal];
    [homeRedCard setTitle:match.homeTeamRed forState:UIControlStateNormal];

   
    
}

- (IBAction)clickFollowButton:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(didClickFollowButton:atIndex:)]){
        [delegate didClickFollowButton:sender atIndex:indexPath];
    }
}

- (void)updateMatchTime
{    
//    NSLog(@"update match time");
}

@end
