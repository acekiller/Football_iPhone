//
//  UpdateScore.h
//  FootballScore
//
//  Created by qqn_pipi on 11-10-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Match;

@interface ScoreUpdate : NSObject {
    Match *match;
    NSInteger homeRedFlag;
    NSInteger awayRedFlag;
    NSInteger homeYellowFlag;
    NSInteger awayYelloFlag;
}

@property (nonatomic, retain)Match *match;
@property (nonatomic, assign) NSInteger homeRedFlag;
@property (nonatomic, assign) NSInteger awayRedFlag;
@property (nonatomic, assign) NSInteger homeYellowFlag;
@property (nonatomic, assign) NSInteger awayYelloFlag;

- (NSInteger)state;
- (NSString *)homeTeamName;
- (NSString *)awayTeamName;
- (NSDate *)startTime;
- (NSString *)matchTimeString;
- (NSString *)leagueName;
- (NSString *)homeTeamScore;
- (NSString *)awayTeamScore;

@end
