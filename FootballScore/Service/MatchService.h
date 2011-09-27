//
//  MatchService.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

@protocol MatchServiceDelegate <NSObject>

@optional
- (void)getRealtimeMatchFinish:(int)result;

@end

@interface MatchService : CommonService {
    
}

- (void)getRealtimeMatch:(id<MatchServiceDelegate>)delegate;

@end

extern MatchService *GlobalGetMatchService();