//
//  FootballNetworkRequest.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPNetworkRequest.h"

#define FOLLOW_MATCH_TYPE      @"true"
#define UNFOLLOW_MATCH_TYPE    @"false"

typedef void (^FootballNetworkResponseBlock)(NSString* data, CommonNetworkOutput* output);


enum{
    REALTIME_MATCH_SERVER_TIMESTAMP = 0,
    REALTIME_MATCH_LEAGUE,
    REALTIME_MATCH_DATA,
    REALTIME_MATCH_SEGMENT
};


enum{
    MATCH_EVENT = 0,
    MATCH_TECHNICAL_STATISTICS,
    MATCH_EVENT_SEGMENT
};

enum{
    MATCH_DETAIIL_HEADER_SEGMENT = 1
};

@interface FootballNetworkRequest : NSObject {
    
}

+ (NSArray*)parseSegment:(NSString*)data;
+ (NSArray*)parseRecord:(NSString*)data;
+ (NSArray*)parseField:(NSString*)data;

+ (CommonNetworkOutput*)getRealtimeMatch:(int)lang scoreType:(int)scoreType;
+ (CommonNetworkOutput*)getRealtimeScore;
+ (CommonNetworkOutput*)getMatchDetail:(int)lang matchId:(NSString *)matchId;
+ (CommonNetworkOutput*)getMatchDetailHeader:(NSString *)matchId;

+ (CommonNetworkOutput*)getMatchOupei:(NSString*)matchId;
+ (CommonNetworkOutput*)getMatchOupeiDetail:(NSString*)OddsId;
+ (CommonNetworkOutput*)getMatchYapei:(NSString*)matchId;
+ (CommonNetworkOutput*)getMatchYapeiDetail:(NSString*)OddsId;
+ (CommonNetworkOutput*)getMatchDaxiao:(NSString*)matchId;
+ (CommonNetworkOutput*)getMatchDaxiaoDetail:(NSString *)OddsId;
+ (CommonNetworkOutput*)getBetCompanyList;
+ (CommonNetworkOutput*)getRegisterUserId:(int)registerType token:(NSString*)token;
+ (CommonNetworkOutput*)updateUserPushInfo:(int)userId pushType:(int)pushType token:(NSString*)token;
+ (CommonNetworkOutput*)getPlayersList:(NSString*)matchId lanaguage:(int)language;
+ (CommonNetworkOutput*)getRealtimeOdds:(NSInteger)oddsType;
+ (CommonNetworkOutput*)getOddsListByDate:(NSDate*)date 
                           companyIdArray:(NSArray*)companyIdAray 
                                 language:(int)language 
                                matchType:(int)matchType 
                                 oddsType:(int)oddsType;

+ (CommonNetworkOutput*)followUnfollowMatch:(NSString*)userId
                                    matchId:(NSString*)matchId
                                       type:(NSString*)type;
+ (CommonNetworkOutput*)getWeeklyScheduleByDate:(NSDate*)date 
                                       language:(int)language; 

+ (CommonNetworkOutput*)getVersion;

@end
