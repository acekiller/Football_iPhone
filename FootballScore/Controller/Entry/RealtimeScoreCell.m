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
#import "MatchManager.h"
#import "DataUtils.h"
#define TIME_ZONE_GMT @"Asia/Shanghai"
#import "LocaleConstants.h"

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

enum cardType{
    HOME_RED = 1,
    HOME_YELLOW,
    AWAY_RED,
    AWAY_YELLOW,
};

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
    [self updateMatchStatus:match];
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
    
    NSDate* startDate;    
    if (match.firstHalfStartDate != nil)
        startDate = match.firstHalfStartDate;
    else
        startDate = match.date;
    
    if (nil !=[formatter stringFromDate:startDate]){
        dateString = [formatter stringFromDate:startDate];
    }
    
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
    halfScoreLabel.text = [NSString stringWithFormat:@"(%@:%@)",match.homeTeamFirstHalfScore,match.awayTeamFirstHalfScore];  
}

- (void)updateCards:(Match*)match{
     
    [self setCards:homeRedCard setMatch:match withcardType:HOME_RED];
    [self setCards:homeYellowCard setMatch:match withcardType:HOME_YELLOW];
    [self setCards:awayRedCard setMatch:match withcardType:AWAY_RED];
    [self setCards:awayYellowCard setMatch:match withcardType:AWAY_YELLOW];
}

- (void)updatePeiLv:(Match*)match{
    int localLanguage = LANG_CANTON; 
    peilvLabel.text = [DataUtils toChuPanString:[match crownChuPan] language:localLanguage];
}

- (void)updateMatchTime:(Match*)match
{    
    [self updateMatchStatus:match];
}

- (void)setCards:(UIButton*)card setMatch:(Match*)match withcardType:(int)type{
    
    float cardWidth = 15;
    float titlewidth;
    float leftSide = 155;
    float rightSide = 205;
    float maxTitleLen = 85;
    CGSize titleSize;
    CGRect cardPos = CGRectMake(0, 30, 15, 20);
    UIFont *titleFont = [UIFont systemFontOfSize:16];
    
    switch (type) {
        case HOME_RED:
            if(match.homeTeamRed != nil && [match.homeTeamRed intValue] > 0){
                titleSize = [match.homeTeamName sizeWithFont:titleFont];
                titlewidth = MIN(titleSize.width,maxTitleLen);
                cardPos.origin.x = leftSide-titlewidth-cardWidth;
                [card setFrame:cardPos];
                [card setTitle:match.homeTeamRed forState:UIControlStateNormal];
                [card setHidden:NO];
                NSLog(@"team name is %@, lenght is %D",match.homeTeamName,titleSize.width);
            }
            else{
                [card setHidden:YES];
            }
            break;
        case HOME_YELLOW:
            if(match.homeTeamYellow != nil&& [match.homeTeamYellow intValue] > 0){
                titleSize = [match.homeTeamName sizeWithFont:titleFont];
                titlewidth = MIN(titleSize.width,maxTitleLen);
                if([[self homeRedCard]isHidden]){
                cardPos.origin.x = leftSide-titlewidth;
                }
                else{
                    cardPos.origin.x = leftSide-titlewidth-cardWidth*2;
                }
                [card setFrame:cardPos];
                [card setTitle:match.homeTeamYellow forState:UIControlStateNormal];
                [card setHidden:NO];
            }
            else{
                [card setHidden:YES];
            }
            break;
        case AWAY_RED:
            if(match.awayTeamRed != nil&& [match.awayTeamRed intValue] > 0){
                titleSize = [match.awayTeamName sizeWithFont:titleFont];
                titlewidth = MIN(titleSize.width,maxTitleLen);
                cardPos.origin.x = rightSide+titlewidth;
                [card setFrame:cardPos];
                [card setTitle:match.awayTeamRed forState:UIControlStateNormal];
                [card setHidden:NO];
               // NSLog(@"team name is %@, lenght is %D",awayTeamLabel.text,titleSize.width);
            }
            else{
                [card setHidden:YES];
            }
            break;
        case AWAY_YELLOW:
            if(match.awayTeamYellow != nil && [match.awayTeamYellow intValue] > 0){
                titleSize = [match.awayTeamName sizeWithFont:titleFont];
                titlewidth = MIN(titleSize.width,maxTitleLen);
                if([[self homeRedCard]isHidden]){
                    cardPos.origin.x = rightSide+titlewidth;
                }
                else{
                    cardPos.origin.x = rightSide+titlewidth+cardWidth;
                }
                [card setFrame:cardPos];
                [card setTitle:match.awayTeamYellow forState:UIControlStateNormal];
                [card setHidden:NO];
               // NSLog(@"team name is %@, lenght is %D",awayTeamLabel.text,titleSize.width);
            }
            else{
                [card setHidden:YES];
            }            
            break;
        default:
            break;
    }
}

- (void)updateMatchStatus:(Match*)match
{
    MatchManager* manager = [MatchManager defaultManager];
    CGRect middlePosition = CGRectMake(160, 30, 40, 20);
    CGRect originalPosition = CGRectMake(160, 10, 40, 20);
    UIColor *green = [UIColor colorWithRed:0 green:255 blue:0 alpha:255];
    UIColor *blue = [UIColor colorWithRed:0 green:0 blue:255 alpha:255];
    UIColor *red = [UIColor colorWithRed:255 green:0 blue:0 alpha:255];
    UIColor *gray = [UIColor grayColor]; 
    
    
    switch (match.status) {
        case MATCH_STATUS_FIRST_HALF:
        {
            [scoreLabel setHidden:NO];
            [halfScoreLabel setHidden:YES];
            NSString* value = [manager matchMinutesString:match];
            matchStatusLabel.text = value; 
            [self updateScores:match];
            matchStatusLabel.frame = originalPosition;
            [matchStatusLabel setTextColor:red];
            [scoreLabel setTextColor:green];
        }
            break;
        case MATCH_STATUS_SECOND_HALF:
        {
            [scoreLabel setHidden:NO];
            [halfScoreLabel setHidden:NO];
            NSString* value = [manager matchMinutesString:match];
            matchStatusLabel.text = value;    
            [self updateScores:match];
            matchStatusLabel.frame = originalPosition;
            [matchStatusLabel setTextColor:red];
            [scoreLabel setTextColor:green];
        }
            break;
            
        case MATCH_STATUS_MIDDLE:
        {
            [scoreLabel setHidden:NO];
            [halfScoreLabel setHidden:NO];
            matchStatusLabel.text = FNS(@"中场");  
            [self updateScores:match];
            matchStatusLabel.frame = originalPosition;
            [matchStatusLabel setTextColor:blue];
            [scoreLabel setTextColor:blue];
        }
            break;
            
        case MATCH_STATUS_PAUSE:
        {
            [scoreLabel setHidden:NO];
            [halfScoreLabel setHidden:YES];
            matchStatusLabel.text = FNS(@"中断");   
            [self updateScores:match];
            matchStatusLabel.frame = originalPosition;
            [matchStatusLabel setTextColor:blue];
            [scoreLabel setTextColor:blue];
        }
            break;
            
        case MATCH_STATUS_FINISH:
        {
            [scoreLabel setHidden:NO];
            [halfScoreLabel setHidden:NO];
            matchStatusLabel.text = FNS(@"已完场"); 
            [self updateScores:match];
            matchStatusLabel.frame = originalPosition;
            [matchStatusLabel setTextColor:red];
            [scoreLabel setTextColor:red];
        }
            break;
            
        case MATCH_STATUS_NOT_STARTED:
        case MATCH_STATUS_TBD:
        case MATCH_STATUS_KILL:
        case MATCH_STATUS_POSTPONE:
        case MATCH_STATUS_CANCEL:
        default:
        {
            matchStatusLabel.text = FNS(@"未开赛");
            [scoreLabel setHidden:YES];
            [halfScoreLabel setHidden:YES];
            matchStatusLabel.frame = middlePosition;
            [matchStatusLabel setTextColor:gray];
            [scoreLabel setTextColor:gray];
        }
            break;
            
    }

}
@end
