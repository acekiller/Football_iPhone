//
//  ScoreIndexCell.m
//  FootballScore
//
//  Created by Orange on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ScoreIndexCell.h"
#import "Company.h"
#import "Odds.h"
#import "YaPei.h"
#import "OuPei.h"
#import "DaXiao.h"
#import "StringUtil.h"
#import "ColorManager.h"
#import "DataUtils.h"

@implementation ScoreIndexCell
@synthesize companyName;
@synthesize home_homeWin_bigBall_init;
@synthesize chupan_draw_init;
@synthesize away_awayWin_smallBall_init;
@synthesize home_homeWin_bigBall_instant;
@synthesize pankou_draw_instant;
@synthesize away_awayWin_smallBall_instant;

+ (ScoreIndexCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ScoreIndexCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ScoreIndexCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((ScoreIndexCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (ScoreIndexCell*)[topLevelObjects objectAtIndex:0];
}

+ (NSString*)getCellIdentifier
{
    return @"ScoreIndexCell";
}

+ (CGFloat)getCellHeight
{
    return 50.0f;
}

- (NSString*)oddsNumberDisplay:(NSNumber*)oddsNumber
{
    NSString *numberString = [NSString floatToStringWithoutZeroTail:[oddsNumber floatValue]];
    
    if ([numberString rangeOfString:@"."].location == NSNotFound) 
        return [NSString stringWithFormat:@"%@.0",numberString];
    else
        return numberString;
}

- (void)setCellInfo:(Odds*)odds company:(Company*)company
{
    [self.contentView setBackgroundColor:[ColorManager scoreIndexCellBackgroundColor]];
    [self.companyName setTitle:[NSString stringWithFormat:@"%@", company.companyName] forState:UIControlStateNormal];
    if (odds == nil) {
        return;
    }
    
    switch ([odds oddsType]) {
        case ODDS_TYPE_YAPEI: {
            YaPei* yapei = (YaPei*)odds;
            [self.home_homeWin_bigBall_init setTitle:[self oddsNumberDisplay:yapei.homeTeamChupan] forState:UIControlStateNormal];
            
            NSNumber *chupan = [NSNumber numberWithFloat:[yapei.chupan floatValue]];
            [self.chupan_draw_init setTitle:[DataUtils toChuPanString:chupan] forState:UIControlStateNormal];
            
            
            [self.away_awayWin_smallBall_init setTitle:[self oddsNumberDisplay:yapei.awayTeamChupan] forState:UIControlStateNormal];
            
            [self.home_homeWin_bigBall_instant setTitle:[self oddsNumberDisplay:yapei.homeTeamOdds] forState:UIControlStateNormal];
            
            NSNumber *pankou = [NSNumber numberWithFloat:[yapei.instantOdds floatValue]];
            [self.pankou_draw_instant setTitle:[DataUtils toChuPanString:pankou] forState:UIControlStateNormal];

            [self.away_awayWin_smallBall_instant setTitle:[self oddsNumberDisplay:yapei.awayTeamOdds] forState:UIControlStateNormal];
            
        }
            break;
        case ODDS_TYPE_OUPEI: {
            OuPei* oupei = (OuPei*)odds;
            [self.home_homeWin_bigBall_init setTitle:[self oddsNumberDisplay:oupei.homeWinInitOdds] forState:UIControlStateNormal];
            
            [self.chupan_draw_init setTitle:[self oddsNumberDisplay:oupei.drawInitOdds] forState:UIControlStateNormal];;
            
            [self.away_awayWin_smallBall_init setTitle:[self oddsNumberDisplay:oupei.awayWinInitOdds] forState:UIControlStateNormal];
            [self.home_homeWin_bigBall_instant setTitle:[self oddsNumberDisplay:oupei.homeWinInstantOdds] forState:UIControlStateNormal];
            
            [self.pankou_draw_instant setTitle:[self oddsNumberDisplay:oupei.drawInstantOdds] forState:UIControlStateNormal];

            [self.away_awayWin_smallBall_instant setTitle:[self oddsNumberDisplay:oupei.awayWinInstantsOdds] forState:UIControlStateNormal];
            
        }
            break;
        case ODDS_TYPE_DAXIAO: {
            DaXiao* daxiao = (DaXiao*)odds;
            [self.home_homeWin_bigBall_init setTitle:[self oddsNumberDisplay:daxiao.bigBallChupan] forState:UIControlStateNormal];
            
            [self.chupan_draw_init setTitle:[self oddsNumberDisplay:daxiao.chupan] forState:UIControlStateNormal];
            
            [self.away_awayWin_smallBall_init setTitle:[self oddsNumberDisplay:daxiao.smallBallChupan] forState:UIControlStateNormal];
            [self.home_homeWin_bigBall_instant setTitle:[self oddsNumberDisplay:daxiao.bigBallOdds] forState:UIControlStateNormal];
            
            [self.pankou_draw_instant setTitle:[self oddsNumberDisplay:daxiao.instantOdds] forState:UIControlStateNormal];

            [self.away_awayWin_smallBall_instant setTitle:[self oddsNumberDisplay:daxiao.smallBallOdds] forState:UIControlStateNormal];
            
        }
            break;            
        default:
            break;
    }
    
    if (odds && (time(0) - odds.lastModifyTime < 10)) {
        //home odds
        if ([odds homeTeamOddsFlag] == ODDS_INCREASE) {
            [self.home_homeWin_bigBall_instant setBackgroundColor:[ColorManager oddsIncreaseColor]];
        }else if([odds homeTeamOddsFlag] == ODDS_DECREASE){
            [self.home_homeWin_bigBall_instant setBackgroundColor:[ColorManager oddsDecreaseColor]];
        }else{
            [self.home_homeWin_bigBall_instant setBackgroundColor:[ColorManager oddsUnchangeColor]];
        }
        
        //away odds
        if ([odds awayTeamOddsFlag] == ODDS_INCREASE) {
            [self.away_awayWin_smallBall_instant setBackgroundColor:[ColorManager oddsIncreaseColor]];
        }else if([odds awayTeamOddsFlag] == ODDS_DECREASE){
            [self.away_awayWin_smallBall_instant setBackgroundColor:[ColorManager oddsDecreaseColor]];
        }else{
            [self.away_awayWin_smallBall_instant setBackgroundColor:[ColorManager oddsUnchangeColor]];
        }
        
        //pankou
        if ([odds pankouFlag] == ODDS_INCREASE) {
            [self.pankou_draw_instant setBackgroundColor:[ColorManager oddsIncreaseColor]];
        }else if([odds homeTeamOddsFlag] == ODDS_DECREASE){
            [self.pankou_draw_instant setBackgroundColor:[ColorManager oddsDecreaseColor]];
        }else{
            [self.pankou_draw_instant setBackgroundColor:[ColorManager oddsUnchangeColor]];
        }
        
    }
    
}

- (void)dealloc {
    [companyName release];
    [home_homeWin_bigBall_init release];
    [chupan_draw_init release];
    [away_awayWin_smallBall_init release];
    [home_homeWin_bigBall_instant release];
    [pankou_draw_instant release];
    [away_awayWin_smallBall_instant release];
    [super dealloc];
}
@end
