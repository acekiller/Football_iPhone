//
//  ScoreIndexTitleCell.h
//  FootballScore
//
//  Created by  on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@interface ScoreIndexTitleCell : PPTableViewCell{
    
}

@property (retain, nonatomic) IBOutlet UIButton *home_big_label;
@property (retain, nonatomic) IBOutlet UIButton *chupan_draw_label;
@property (retain, nonatomic) IBOutlet UIButton *away_small_label;
+ (ScoreIndexTitleCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
- (void)setCellInfo:(int)oddsType;

@end
