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
#define TIME_ZONE_GMT @"Asia/Shanghai"

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
@synthesize followButton;
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
    [followButton release];
    [super dealloc];
}

- (void)setCellInfo:(Match*)match
{

    [self updatePeiLv:match];
    [self updateScores:match];
    [self updateStartTime:match];
    [self updateCards:match];
    [self updateMatchInfo:match];
    [self updateFollow:match];
    
}

- (IBAction)clickFollowButton:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(didClickFollowButton:atIndex:)]){
        [delegate didClickFollowButton:sender atIndex:indexPath];
    }
}

- (void)updateStartTime:(Match*)match{   
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSString *dateString = [NSString stringWithFormat:@""];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:TIME_ZONE_GMT]];
    if(nil !=[formatter stringFromDate:match.date])
        dateString = [formatter stringFromDate:match.date];
    startTimeLabel.text = dateString;
    [formatter release];
    }

-(void)updateFollow:(Match*)match{
    if([match isFollow])
        [followButton setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    else
        [followButton setBackgroundImage:[UIImage imageNamed:@"unSelected"] forState:UIControlStateNormal];
}

- (void)updateMatchInfo:(Match*)match{
    LeagueManager *league = [LeagueManager defaultManager];
    matchTypeLabel.text = [league getNameById:match.leagueId];
    
    homeTeamLabel.text = match.homeTeamName;
    awayTeamLabel.text = match.awayTeamName;
}

- (void)updateScores:(Match*)match{
    scoreLabel.text = [NSString stringWithFormat:@"%@ : %@", match.homeTeamScore, match.awayTeamScore];
    halfScoreLabel.text = [NSString stringWithFormat:@"%@: %@",match.homeTeamFirstHalfScore,match.awayTeamFirstHalfScore];  
}

- (void)updateCards:(Match*)match{
    [self setCards:homeRedCard setTitle:match.homeTeamRed];
    [self setCards:homeYellowCard setTitle:match.homeTeamYellow];
    [self setCards:awayRedCard setTitle:match.awayTeamRed];
    [self setCards:awayYellowCard setTitle:match.awayTeamYellow];
}

- (void)updatePeiLv:(Match*)match{
    int localLanguage = LANG_CANTON; 
    peilvLabel.text = [DataUtils toChuPanString:[match crownChuPan] language:localLanguage];
}

- (void)updateMatchTime
{
    //NSLog(@"update match time");

}

- (void)setCards:(UIButton*)card setTitle:(NSString*)title{
    if(title == nil || [title intValue] <= 0){
        [card setHidden:YES];
    }
    else{
        [card setTitle:title forState:UIControlStateNormal];
        [card setHidden:NO];
    }
}
@end
