//
//  ScoreUpdateCell.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@class ScoreUpdate;
@interface ScoreUpdateCell : PPTableViewCell {
    
    UILabel *leagueName;
    UILabel *startTime;
    UILabel *matchState;
    UILabel *homeTeam;
    UILabel *awayTeam;
    UIButton *homeTeamEvent;
    UIButton *awayTeamEvent;
    UILabel *matchScore;
}
@property (nonatomic, retain) IBOutlet UILabel *leagueName;
@property (nonatomic, retain) IBOutlet UILabel *startTime;
@property (nonatomic, retain) IBOutlet UILabel *matchState;
@property (nonatomic, retain) IBOutlet UILabel *homeTeam;
@property (nonatomic, retain) IBOutlet UILabel *awayTeam;
@property (nonatomic, retain) IBOutlet UIButton *homeTeamEvent;
@property (nonatomic, retain) IBOutlet UIButton *awayTeamEvent;
@property (nonatomic, retain) IBOutlet UILabel *matchScore;

+ (ScoreUpdateCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
- (void)setCellInfo:(ScoreUpdate *)scoreUpdate;
@end
