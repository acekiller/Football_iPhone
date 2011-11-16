//
//  Odds.m
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Odds.h"
#import "OuPei.h"
#import "YaPei.h"
#import "DaXiao.h"
@implementation Odds

@synthesize matchId;
@synthesize commpanyId;
@synthesize oddsId;

- (id)init
{
    self = [super init];
    if (self) {
        self.matchId = [[NSString alloc] init];
        self.commpanyId = [[NSString alloc] init];
        self.oddsId = [[NSString alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self.matchId release];
    [self.commpanyId release];
    [self.oddsId release];
    [super dealloc];
}

-(ODDS_TYPE) oddsType
{
//    if ([self isMemberOfClass:[YaPei class]]) {
//        return ODDS_TYPE_YAPEI;
//    }else if([self isMemberOfClass:[OuPei class]]){
//        return ODDS_TYPE_OUPEI;
//    }else if([self isMemberOfClass:[DaXiao class]]){
//        return ODDS_TYPE_DAXIAO;
//    }
    return ODDS_TYPE_ODDS;
}

@end
