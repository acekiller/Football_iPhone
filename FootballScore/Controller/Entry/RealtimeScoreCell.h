//
//  RealtimeScoreCell.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@class Match;

@protocol RealtimeScoreCell <NSObject>

- (void)didClickFollowButton:(id)sender atIndex:(NSIndexPath*)indexPath;

@end

@interface RealtimeScoreCell : PPTableViewCell {
    
    UILabel *matchTypeLabel;
    UILabel *startTimeLabel;
    UILabel *matchStatusLabel;
    UILabel *awayTeamLabel;
    UILabel *homeTeamLabel;
    UILabel *peilvLabel;
    UILabel *halfScoreLabel;
    UILabel *scoreLabel;
    UIButton *awayRedCard;
    UIButton *awayYellowCard;
    UIButton *homeRedCard;
    UIButton *homeYellowCard;
    UIImageView *followStatus;
}

// copy and override three methods below

+ (RealtimeScoreCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
- (void)setCellInfo:(Match*)match;

@property (nonatomic, retain) IBOutlet UILabel *matchTypeLabel;
@property (nonatomic, retain) IBOutlet UILabel *startTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *matchStatusLabel;
@property (nonatomic, retain) IBOutlet UILabel *awayTeamLabel;
@property (nonatomic, retain) IBOutlet UILabel *homeTeamLabel;
@property (nonatomic, retain) IBOutlet UILabel *peilvLabel;
@property (nonatomic, retain) IBOutlet UILabel *halfScoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;

@property (nonatomic, retain) IBOutlet UIButton *awayRedCard;
@property (nonatomic, retain) IBOutlet UIButton *awayYellowCard;
@property (nonatomic, retain) IBOutlet UIButton *homeRedCard;
@property (nonatomic, retain) IBOutlet UIButton *homeYellowCard;

@property (nonatomic, retain) IBOutlet UIImageView *followStatus;

- (IBAction)clickFollowButton:(id)sender;

@end
