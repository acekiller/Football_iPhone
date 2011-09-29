//
//  FootballNetworkRequest.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPNetworkRequest.h"

typedef void (^FootballNetworkResponseBlock)(NSString* data, CommonNetworkOutput* output);


enum{
    REALTIME_MATCH_SERVER_TIMESTAMP = 0,
    REALTIME_MATCH_LEAGUE,
    REALTIME_MATCH_DATA,
    REALTIME_MATCH_SEGMENT
};


@interface FootballNetworkRequest : NSObject {
    
}

+ (NSArray*)parseSegment:(NSString*)data;
+ (NSArray*)parseRecord:(NSString*)data;
+ (NSArray*)parseField:(NSString*)data;

+ (CommonNetworkOutput*)getRealtimeMatch:(int)lang scoreType:(int)scoreType;

@end
