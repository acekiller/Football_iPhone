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
            [self.home_homeWin_bigBall_init setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[yapei.homeTeamChupan floatValue]]] forState:UIControlStateNormal];
            
            NSNumber *chupan = [NSNumber numberWithFloat:[yapei.chupan floatValue]];
            [self.chupan_draw_init setTitle:[DataUtils toChuPanString:chupan] forState:UIControlStateNormal];
            
            
            [self.away_awayWin_smallBall_init setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[yapei.awayTeamChupan floatValue]]] forState:UIControlStateNormal];
            [self.home_homeWin_bigBall_instant setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[yapei.homeTeamOdds floatValue]]] forState:UIControlStateNormal];
            
            NSNumber *pankou = [NSNumber numberWithFloat:[yapei.instantOdds floatValue]];
            [self.pankou_draw_instant setTitle:[DataUtils toChuPanString:pankou] forState:UIControlStateNormal];

            [self.away_awayWin_smallBall_instant setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[yapei.awayTeamOdds floatValue]]] forState:UIControlStateNormal];
            
        }
            break;
        case ODDS_TYPE_OUPEI: {
            OuPei* oupei = (OuPei*)odds;
            [self.home_homeWin_bigBall_init setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[oupei.homeWinInitOdds floatValue]]] forState:UIControlStateNormal];
            
            [self.chupan_draw_init setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[oupei.drawInitOdds floatValue]]] forState:UIControlStateNormal];;
            
            [self.away_awayWin_smallBall_init setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[oupei.awayWinInitOdds floatValue]]] forState:UIControlStateNormal];
            [self.home_homeWin_bigBall_instant setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[oupei.homeWinInstantOdds floatValue]]] forState:UIControlStateNormal];
            
            [self.pankou_draw_instant setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[oupei.drawInstantOdds floatValue]]] forState:UIControlStateNormal];

            [self.away_awayWin_smallBall_instant setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[oupei.awayWinInstantsOdds floatValue]]] forState:UIControlStateNormal];
            
        }
            break;
        case ODDS_TYPE_DAXIAO: {
            DaXiao* daxiao = (DaXiao*)odds;
            [self.home_homeWin_bigBall_init setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[daxiao.bigBallChupan floatValue]]] forState:UIControlStateNormal];
            
            [self.chupan_draw_init setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[daxiao.chupan floatValue]]] forState:UIControlStateNormal];
            
            [self.away_awayWin_smallBall_init setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[daxiao.smallBallChupan floatValue]]] forState:UIControlStateNormal];
            [self.home_homeWin_bigBall_instant setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[daxiao.bigBallOdds floatValue]]] forState:UIControlStateNormal];
            
            [self.pankou_draw_instant setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[daxiao.instantOdds floatValue]]] forState:UIControlStateNormal];

            [self.away_awayWin_smallBall_instant setTitle:[NSString stringWithFormat:@"%@",[NSString floatToStringWithoutZeroTail:[daxiao.smallBallOdds floatValue]]] forState:UIControlStateNormal];
            
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
