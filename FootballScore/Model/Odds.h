//
//  Odds.h
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum ODDS_TYPE {
    
    ODDS_TYPE_INVALIDE = -1,
    ODDS_TYPE_ODDS = 0,
    ODDS_TYPE_YAPEI = 1,
    ODDS_TYPE_OUPEI = 2,
    ODDS_TYPE_DAXIAO = 3
}ODDS_TYPE;


typedef enum ODDS_INCREASE_FLAG{
    ODDS_INCREASE = 1,
    ODDS_DECREASE = -1,
    ODDS_UNCHANGE = 0
    
}ODDS_INCREASE_FLAG;

@interface Odds : NSObject {
    NSString* matchId;
    NSString* commpanyId;
    NSString* oddsId;
    time_t lastModifyTime;
}

@property (nonatomic, retain) NSString* matchId;
@property (nonatomic, retain) NSString* commpanyId;
@property (nonatomic, retain) NSString* oddsId;
@property (nonatomic, assign) time_t lastModifyTime;
@property (nonatomic, assign) ODDS_INCREASE_FLAG homeTeamOddsFlag;
@property (nonatomic, assign) ODDS_INCREASE_FLAG pankouFlag;
@property (nonatomic, assign) ODDS_INCREASE_FLAG awayTeamOddsFlag;
-(ODDS_TYPE) oddsType;
-(NSNumber *)getNumber:(NSString *)stringValue;


@end
