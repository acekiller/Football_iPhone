//
//  League.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "League.h"


@implementation League

@synthesize name;
@synthesize leagueId;
@synthesize isTop;

- (id)initWithName:(NSString*)na
          leagueId:(NSString*)lid
             isTop:(BOOL)it
{
    self = [super init];
    self.name = na;
    self.leagueId = lid;
    self.isTop = it;
    
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"[name=%@, id=%@, isTop=%d", 
            name, leagueId, isTop];
}

- (void)dealloc
{
    [name release];
    [leagueId release];
    [super dealloc];
}

@end
