//
//  RetryService.h
//  FootballScore
//
//  Created by haodong qiu on 11-11-25.
//  Copyright (c) 2011年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

@interface RetryService : CommonService

- (void)retryFollowMatch:(NSString*)userId matchId:(NSString*)matchId;
- (void)retryUnfollowMatch:(NSString*)userId matchId:(NSString*)matchId;
- (void)retryFollowUnfollowList:(NSString*)userId;

@end
