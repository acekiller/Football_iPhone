//
//  MatchStat.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MatchStat.h"


@implementation MatchStat

@synthesize type;
@synthesize homeValue;
@synthesize awayValue;

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return  self;
}

- (void)dealloc
{
    [homeValue release];
    [awayValue release];
    [super dealloc];
}

@end
