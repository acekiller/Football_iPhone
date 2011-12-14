//
//  ShowRealtimeScoreController.h
//  FootballScore
//
//  Created by haodong qiu on 11-11-10.
//  Copyright (c) 2011年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

enum{
    HOMETEAM_GOALS = 0,
    AWAYTEAM_GOALS = 1,
    BOTH_GOALS = 2
};


@class Match;
@interface ShowRealtimeScoreController : UIViewController
{
    UILabel *leagueNameLabel;
    UILabel *startTimeLabel;
    UILabel *homeTeamLabel;
    UILabel *awayTeamLabel;
    UILabel *homeTeamEventLabel;
    UILabel *awayTeamEventLabel;
    NSTimer *showTimer;
    Match   *match;
    AVAudioPlayer	*player;
}

@property(nonatomic,retain)IBOutlet UILabel *leagueNameLabel;
@property(nonatomic,retain)IBOutlet UILabel *startTimeLabel;
@property(nonatomic,retain)IBOutlet UILabel *homeTeamLabel;
@property(nonatomic,retain)IBOutlet UILabel *awayTeamLabel;
@property(nonatomic,retain)IBOutlet UILabel *homeTeamEventLabel;
@property(nonatomic,retain)IBOutlet UILabel *awayTeamEventLabel;

@property(nonatomic,retain) NSTimer *showTimer;
@property(nonatomic,retain) Match   *match;
@property(nonatomic,retain) AVAudioPlayer *player;


+ (void)show:(Match *)newMatch 
   goalsTeam:(int)goalsTeam
 isVibration:(BOOL)isVibration 
    hasSound:(BOOL)hasSound;

+ (void)show:(UIView*)superView 
 scoreUpdate:(Match *)newMatch
   goalsTeam:(int)goalsTeam
 isVibration:(BOOL)isVibration 
    hasSound:(BOOL)hasSound;

- (void)updateViewByMatche:(Match *)newMatche;
- (void)cancelDisplay;
- (void)createHideTimer;
- (void)removeFromSuperView;
- (void)playeSound:(NSString*)soundFile;
- (void)updateEventLabelColor:(int)goalsTeam;

@end
