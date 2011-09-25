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


@interface FootballNetworkRequest : NSObject {
    
}

+ (CommonNetworkOutput*)getRealtimeMatch:(int)lang;

@end
