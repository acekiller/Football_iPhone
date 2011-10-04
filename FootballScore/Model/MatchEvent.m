//
//  MatchEvent.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MatchEvent.h"


@implementation MatchEvent

@synthesize homeAwayFlag;
@synthesize type;
@synthesize minutes;
@synthesize player;

-(id)init
{
    self = [super init];
    return self;
}

-(void)dealloc
{
    [player release];
    [super dealloc];
}

- (NSString *)toString
{
    return [NSString stringWithFormat:@"homeAwayFlag=%d, type=%d, minutes=%d, player=%@",homeAwayFlag,type,minutes,player];
}

- (NSString *)toJsonString;
{
    if (self.player) {
        return [NSString stringWithFormat:@"{homeAwayFlag:%d, type:%d, minutes:%d, player:'%@'}",self.homeAwayFlag,self.type,self.minutes,self.player];
    }else{
        return [NSString stringWithFormat:@"{homeAwayFlag:%d, type:%d, minutes:%d}",self.homeAwayFlag,self.type,self.minutes];        
    }

}

@end
