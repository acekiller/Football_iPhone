//
//  ScoreIndexTitleCell.m
//  FootballScore
//
//  Created by  on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ScoreIndexTitleCell.h"
#import "Odds.h"
#import "LocaleConstants.h"

@implementation ScoreIndexTitleCell
@synthesize home_big_label;
@synthesize chupan_draw_label;
@synthesize away_small_label;

+ (ScoreIndexTitleCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ScoreIndexTitleCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ScoreIndexTitleCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((ScoreIndexTitleCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (ScoreIndexTitleCell*)[topLevelObjects objectAtIndex:0];
}

+ (NSString*)getCellIdentifier
{
    return @"ScoreIndexTitleCell";
}

- (void)setCellInfo:(int)oddsType
{
    switch (oddsType) {
        case ODDS_TYPE_YAPEI: {
            [self.home_big_label setTitle:FNS(@"上盘") forState:UIControlStateNormal];
            [self.chupan_draw_label setTitle:FNS(@"盘口") forState:UIControlStateNormal];
            [self.away_small_label setTitle:FNS(@"下盘") forState:UIControlStateNormal];
        }
            break;
        case ODDS_TYPE_OUPEI: {
            [self.home_big_label setTitle:FNS(@"主胜") forState:UIControlStateNormal];
            [self.chupan_draw_label setTitle:FNS(@"和") forState:UIControlStateNormal];
            [self.away_small_label setTitle:FNS(@"客胜") forState:UIControlStateNormal];
        }
            break;
        case ODDS_TYPE_DAXIAO: {
            [self.home_big_label setTitle:FNS(@"大球") forState:UIControlStateNormal];
            [self.chupan_draw_label setTitle:FNS(@"盘口") forState:UIControlStateNormal];
            [self.away_small_label setTitle:FNS(@"小球") forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

+ (CGFloat)getCellHeight
{
    return 26.0f;
}
- (void)dealloc {
    [home_big_label release];
    [chupan_draw_label release];
    [away_small_label release];
    [super dealloc];
}
@end
