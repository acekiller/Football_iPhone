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
#import "LocaleConstants.h"
#import "ColorManager.h"
#import "UITableViewCellUtil.h"
#import "TimeUtils.h"
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
    return 47;
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

- (void)updateBackground:(Match *)match
{
    time_t now = time(0);
    if (now - match.lastScoreTime <= 10) {
        [self setBackgroundImageByName:@"kive_li2.png"];
    }
    else{
        [self setBackgroundImageByName:@"kive_li.png"];
    }
}

- (void)setCellInfo:(Match*)match
{
    [self updateBackground:match];
    
    [self updatePeiLv:match];
    [self updateMatchStatus:match];
    [self updateStartTime:match];
    [self updateMatchInfo:match];
    [self updateCards:match];
    [self updateFollow:match];
    [self updateMatchTypeLabel:match];
    [self positionAdjust];
    
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
    if(match.isFollow == [NSNumber numberWithBool:YES])
        [followButton setBackgroundImage:[UIImage imageNamed:@"star2"] forState:UIControlStateNormal];
    else
        [followButton setBackgroundImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
}

- (void)updateMatchInfo:(Match*)match{

    LeagueManager *league = [LeagueManager defaultManager];
    matchTypeLabel.text = [league getNameById:match.leagueId];

    homeTeamLabel.text = match.homeTeamName;
    awayTeamLabel.text = match.awayTeamName;
}

- (void)updateScores:(Match*)match{
    scoreLabel.text = [NSString stringWithFormat:@"%@:%@", match.homeTeamScore, match.awayTeamScore];
    halfScoreLabel.text = [NSString stringWithFormat:@"(%@:%@)",match.homeTeamFirstHalfScore,match.awayTeamFirstHalfScore];  
}

- (void)updateCards:(Match*)match{
    
    [homeRedCard setBackgroundImage:[UIImage imageNamed:@"redcard"] forState:UIControlStateNormal];
    [awayRedCard setBackgroundImage:[UIImage imageNamed:@"redcard"] forState:UIControlStateNormal];
    [homeYellowCard setBackgroundImage:[UIImage imageNamed:@"yellowcard"] forState:UIControlStateNormal];
    [awayYellowCard setBackgroundImage:[UIImage imageNamed:@"yellowcard"] forState:UIControlStateNormal];
         
    [self setCards:homeRedCard setMatch:match withcardType:HOME_RED];
    [self setCards:homeYellowCard setMatch:match withcardType:HOME_YELLOW];
    [self setCards:awayRedCard setMatch:match withcardType:AWAY_RED];
    [self setCards:awayYellowCard setMatch:match withcardType:AWAY_YELLOW];
}

- (void)updatePeiLv:(Match*)match{
    peilvLabel.text = [DataUtils toChuPanString:[match crownChuPan]];
}

- (void)updateMatchTime:(Match*)match
{    
    [self updateMatchStatus:match];
}

- (void)updateMatchTypeLabel:(Match *)match
{
    LeagueManager *manager = [LeagueManager defaultManager];
    UIColor *labelColor = [manager getLeagueColorById:match.leagueId];
    [matchTypeLabel setTextColor:labelColor];
    
}

- (void)setCards:(UIButton*)card setMatch:(Match*)match withcardType:(int)type{
  
    switch (type) {
        case HOME_RED:
        {
            if (match.homeTeamRed != nil && [match.homeTeamRed intValue] > 0) {
                [card setTitle:match.homeTeamRed forState:UIControlStateNormal];
                [card setHidden:NO];
            }
            else {
                [card setHidden:YES];
            }
        }
            break;
        case HOME_YELLOW:
        { 
            if (match.homeTeamYellow != nil && [match.homeTeamYellow intValue] > 0) {
                [card setTitle:match.homeTeamYellow forState:UIControlStateNormal];
                [card setHidden:NO];
            }
            else {
                [card setHidden:YES];
            }
        }
            break;
        case AWAY_RED:
        {
            if (match.awayTeamRed != nil&& [match.awayTeamRed intValue] > 0) {
                [card setTitle:match.awayTeamRed forState:UIControlStateNormal];
                [card setHidden:NO];

            }
            else {
                [card setHidden:YES];
            }
        }
            break;
        case AWAY_YELLOW:
        {
            if (match.awayTeamYellow != nil && [match.awayTeamYellow intValue] > 0) {
                [card setTitle:match.awayTeamYellow forState:UIControlStateNormal];
                [card setHidden:NO];

            }
            else {
                [card setHidden:YES];
            }  
        }
            break;
        default:
            break;
    }
}

- (void)updateMatchStatus:(Match*)match
{
    MatchManager* manager = [MatchManager defaultManager];
    CGRect middlePosition = CGRectMake(151, 21, 36, 20);
    CGRect originalPosition = CGRectMake(151, 6, 36, 20);
    int matchStatus = [match.status intValue];
    
    switch (matchStatus) {
        case MATCH_STATUS_FIRST_HALF:
        case MATCH_STATUS_SECOND_HALF:
        {
            if (matchStatus == MATCH_STATUS_SECOND_HALF) {
                [halfScoreLabel setHidden:NO];
            }
            else {
                [halfScoreLabel setHidden:YES];
            }  
            [scoreLabel setHidden:NO];
            
            int currentTime = time(0);
            NSString* value = [manager matchMinutesString:match];
            NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:value];
            [attrStr setTextColor:[ColorManager onGoTimeColor]];
            [attrStr setFont:[UIFont systemFontOfSize:13]];
            if (currentTime%2)
                [attrStr setTextColor:[UIColor clearColor] range:[value rangeOfString:@"'"]];
            else
                [attrStr setTextColor:[ColorManager onGoTimeColor] range:[value rangeOfString:@"'"]];  
            matchStatusLabel.attributedText = attrStr; 
            
            [self updateScores:match];
            matchStatusLabel.frame = originalPosition;            
            [scoreLabel setTextColor:[ColorManager onGoScore]];
            [matchStatusLabel setTextAlignment:UITextAlignmentCenter];
        }
            break;
            
        case MATCH_STATUS_MIDDLE:
        {
            [scoreLabel setHidden:NO];
            [halfScoreLabel setHidden:NO];
            NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:FNS(@"中场")];
            matchStatusLabel.attributedText = attrStr;   
            [self updateScores:match];
            matchStatusLabel.frame = originalPosition;
            [matchStatusLabel setTextColor:[ColorManager halfScoreColor]];
            [scoreLabel setTextColor:[ColorManager halfScoreColor]];
            [matchStatusLabel setTextAlignment:UITextAlignmentCenter];
        }
            break;
            
        case MATCH_STATUS_PAUSE:
        {
            [scoreLabel setHidden:NO];
            [halfScoreLabel setHidden:YES];
            NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:FNS(@"中断")];
            matchStatusLabel.attributedText = attrStr;    
            [self updateScores:match];
            matchStatusLabel.frame = originalPosition;
            [matchStatusLabel setTextColor:[ColorManager halfScoreColor]];
            [scoreLabel setTextColor:[ColorManager halfScoreColor]];
            [matchStatusLabel setTextAlignment:UITextAlignmentCenter];
        }
            break;
            
        case MATCH_STATUS_FINISH:
        {
            [scoreLabel setHidden:NO];
            [halfScoreLabel setHidden:NO];
            NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:FNS(@"完")];
            matchStatusLabel.attributedText = attrStr; 
            [self updateScores:match];
            matchStatusLabel.frame = originalPosition;
            [matchStatusLabel setTextColor:[ColorManager finishScoreColor]];
            [scoreLabel setTextColor:[ColorManager finishScoreColor]];
            [matchStatusLabel setTextAlignment:UITextAlignmentCenter];
        }
            break;
            
        case MATCH_STATUS_NOT_STARTED:
        case MATCH_STATUS_TBD:
        case MATCH_STATUS_KILL:
        case MATCH_STATUS_POSTPONE:
        case MATCH_STATUS_CANCEL:
        default:
        {
            NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:FNS(@"未开赛")];
            matchStatusLabel.attributedText = attrStr; 
            [scoreLabel setHidden:YES];
            [halfScoreLabel setHidden:YES];
            matchStatusLabel.frame = middlePosition;
            [matchStatusLabel setTextColor:[UIColor grayColor]];
            [scoreLabel setTextColor:[UIColor grayColor]];
            [matchStatusLabel setTextAlignment:UITextAlignmentCenter];
        }
            break;
            
    }

}

- (void)positionAdjust
{
    float maxWidth = 110;
    float cardWidth = 13;
    float cardTitleSpace = 4;
    int leftCard = 0;
    int rightCard = 0;
    float homeTitleWidth;
    float awayTitleWidth;
    UIFont *titleFont = [UIFont systemFontOfSize:14];
 
    homeTitleWidth = [homeTeamLabel.text sizeWithFont:titleFont].width;
    awayTitleWidth = [awayTeamLabel.text sizeWithFont:titleFont].width;
    if (![homeRedCard isHidden]) {
        leftCard ++;
    }
    if (![homeYellowCard isHidden]) {
        leftCard ++;
    }
    if (![awayRedCard isHidden]) {
        rightCard ++;
    }
    if (![awayYellowCard isHidden]) {
        rightCard ++;
    }
    
    if ((homeTitleWidth+cardTitleSpace+cardWidth*leftCard) > maxWidth) {
        [homeTeamLabel setFrame:CGRectMake(36+cardWidth*leftCard+cardTitleSpace, 
                                          21, 
                                          maxWidth-cardTitleSpace-cardWidth*leftCard, 
                                          20)];
        [homeRedCard setFrame:CGRectMake(36+cardWidth*(leftCard-1)+cardTitleSpace, 
                                        23, 
                                        cardWidth, 
                                        16)];
        [homeYellowCard setFrame:CGRectMake(36+cardTitleSpace, 
                                            23, 
                                            cardWidth, 
                                            16)];
    } else {
        [homeTeamLabel setFrame:CGRectMake(36, 
                                           21, 
                                           maxWidth, 
                                           20)];
        [homeRedCard setFrame:CGRectMake(146-homeTitleWidth-cardWidth-cardTitleSpace, 
                                         23, 
                                         cardWidth, 
                                         16)];
        [homeYellowCard setFrame:CGRectMake(146-homeTitleWidth-cardWidth*leftCard-cardTitleSpace,
                                            23, 
                                            cardWidth, 
                                            16)];
    }
    
    if ((awayTitleWidth+cardTitleSpace+cardWidth*rightCard) > maxWidth) {
        [awayTeamLabel setFrame:CGRectMake(192,
                                           21, 
                                           maxWidth-cardTitleSpace-cardWidth*rightCard, 
                                           20)];
        [awayRedCard setFrame:CGRectMake(192+maxWidth-cardWidth*rightCard-cardTitleSpace, 
                                         23, 
                                         cardWidth, 
                                         16)];
        [awayYellowCard setFrame:CGRectMake(192+maxWidth-cardWidth*(rightCard-1)-cardTitleSpace, 
                                            23, 
                                            cardWidth, 
                                            16)];
    } else {
        [awayTeamLabel setFrame:CGRectMake(192, 
                                           21, 
                                           maxWidth, 
                                           20)];
        [awayRedCard setFrame:CGRectMake(192+awayTitleWidth+cardTitleSpace, 
                                         23, 
                                         cardWidth, 
                                         16)];
        [awayYellowCard setFrame:CGRectMake(192+awayTitleWidth+cardTitleSpace+cardWidth*(rightCard-1),
                                            23, 
                                            cardWidth, 
                                            16)];
    }

    
    
}
@end
