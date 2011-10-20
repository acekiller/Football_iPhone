//
//  UpdateScore.h
//  FootballScore
//
//  Created by qqn_pipi on 11-10-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum ScoreUpdateType{
    HOMETEAMSCORE = 0,
    AWAYTEAMSCORE = 1,
    HOMETEAMRED = 2,
    AWAYTEAMRED = 3,
    HOMETEAMYELLOW = 4,
    AWAYTEAMYELLOW = 5,
    TYPECOUNT = 6
};

@class Match;

@interface ScoreUpdate : NSObject {
    
    Match *match;
    NSInteger scoreUpdateType;
    NSString *updateMinute;
//    NSInteger homeRedFlag;
//    NSInteger awayRedFlag;
//    NSInteger homeYellowFlag;
//    NSInteger awayYelloFlag;
    
}

@property (nonatomic, retain) Match *match;
@property (nonatomic, assign) NSInteger scoreUpdateType;
@property (nonatomic, retain) NSString *updateMinute;
//@property (nonatomic, assign) NSInteger homeRedFlag;
//@property (nonatomic, assign) NSInteger awayRedFlag;
//@property (nonatomic, assign) NSInteger homeYellowFlag;
//@property (nonatomic, assign) NSInteger awayYelloFlag;

-(id)initWithMatch:(Match *)aMatch ScoreUpdateType:(int)type;
- (NSInteger)state;
- (NSString *)homeTeamName;
- (NSString *)awayTeamName;
- (NSDate *)startTime;
- (NSString *)matchTimeString;
- (NSString *)leagueName;
- (NSString *)homeTeamScore;
- (NSString *)awayTeamScore;
- (NSString *)homeTeamRedcard;
- (NSString *)awayTeamRedcard;
- (NSString *)homeTeamYellowcard;
- (NSString *)awayTeamYellowcard;
@end
