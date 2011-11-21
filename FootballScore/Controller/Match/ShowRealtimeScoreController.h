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
    NSTimer *showTimer;
    ScoreUpdate *scoreUpdate;
}

@property(nonatomic,retain)IBOutlet UILabel *leagueNameLabel;
@property(nonatomic,retain)IBOutlet UILabel *startTimeLabel;
@property(nonatomic,retain)IBOutlet UILabel *homeTeamLabel;
@property(nonatomic,retain)IBOutlet UILabel *awayTeamLabel;
@property(nonatomic,retain)IBOutlet UILabel *homeTeamEventLabel;
@property(nonatomic,retain)IBOutlet UILabel *awayTeamEventLabel;

@property(nonatomic,retain) NSTimer *showTimer;
@property(nonatomic,retain) ScoreUpdate *scoreUpdate;



+ (void)show:(ScoreUpdate *)scoreUpdate;
+ (void)show:(UIView*)superView scoreUpdate:(ScoreUpdate *)scoreUpdate;
- (void)updateViewByScoreUpdate:(ScoreUpdate *)newScoreUpdate;
- (void)cancelDisplay;
- (void)createHideTimer;
- (void)removeFromSuperView;

@end
