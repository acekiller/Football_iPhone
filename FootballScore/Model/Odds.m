//
//  Odds.m
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Odds.h"

@implementation Odds

@synthesize matchId;
@synthesize commpanyId;
@synthesize oddsId;

- (id)init
{
    [super init];
    self.matchId = [[NSString alloc] init];
    self.commpanyId = [[NSString alloc] init];
    self.oddsId = [[NSString alloc] init];
    return self;
}

- (void)dealloc
{
    [self.matchId release];
    [self.commpanyId release];
    [self.oddsId release];
    [super dealloc];
}

@end
