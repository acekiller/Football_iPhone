//
//  User.m
//  FootballScore
//
//  Created by qqn_pipi on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "User.h"


@implementation User

@synthesize userId;
@synthesize deviceToken;

- (id)initWithUserId:(NSString *)aUserId deviceToken:(NSString *)aDeviceToken
{
    self = [super init];
    if (self) {
        self.userId = aUserId;
        self.deviceToken = aDeviceToken;
    }
    return self;
}
- (void)dealloc
{
    [userId release];
    [deviceToken release];
    [super dealloc];
}

@end
