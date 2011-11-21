//
//  ShowRealtimeScoreController.h
//  FootballScore
//
//  Created by haodong qiu on 11-11-10.
//  Copyright (c) 2011年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Match;
@class ScoreUpdate;
@interface ShowRealtimeScoreController : UIViewController
{
    UILabel *leagueNameLabel;
    UILabel *startTimeLabel;
    UILabel *homeTeamLabel;
    UILabel *awayTeamLabel;
    UILabel *homeTeamEventLabel;
    UILabel *awayTeamEventLabel;
    Match *match;
    NSTimer *showTimer;
}

@property(nonatomic,retain)IBOutlet UILabel *leagueNameLabel;
@property(nonatomic,retain)IBOutlet UILabel *startTimeLabel;
@property(nonatomic,retain)IBOutlet UILabel *homeTeamLabel;
@property(nonatomic,retain)IBOutlet UILabel *awayTeamLabel;
@property(nonatomic,retain)IBOutlet UILabel *homeTeamEventLabel;
@property(nonatomic,retain)IBOutlet UILabel *awayTeamEventLabel;
@property(nonatomic,retain) Match *match;
@property(nonatomic,retain) NSTimer *showTimer;


//+ (void)show:(UIView*)superView match:(Match*)match;
//+ (void)show:(Match *)match;
+ (void)show:(ScoreUpdate *)scoreUpdate;
+ (void)show:(UIView*)superView scoreUpdate:(ScoreUpdate *)scoreUpdate;
- (void)updateViewByMatch:(Match*)newMatch;
- (void)cancelDisplay;
- (void)createHideTimer;
- (void)removeFromSuperView;

@end
