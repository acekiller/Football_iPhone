//
//  ScoreIndexCell.h
//  FootballScore
//
//  Created by Orange on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"
@class Odds;
@class Company;

@interface ScoreIndexCell : PPTableViewCell
+ (ScoreIndexCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
- (void)setCellInfo:(Odds*)odds company:(Company*)company;

@property (retain, nonatomic) IBOutlet UIButton *companyName;
@property (retain, nonatomic) IBOutlet UIButton *home_homeWin_bigBall_init;
@property (retain, nonatomic) IBOutlet UIButton *chupan_draw_init;
@property (retain, nonatomic) IBOutlet UIButton *away_awayWin_smallBall_init;
@property (retain, nonatomic) IBOutlet UIButton *home_homeWin_bigBall_instant;
@property (retain, nonatomic) IBOutlet UIButton *pankou_draw_instant;
@property (retain, nonatomic) IBOutlet UIButton *away_awayWin_smallBall_instant;

@end
