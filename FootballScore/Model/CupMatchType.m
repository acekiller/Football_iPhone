//
//  CupMatchType.m
//  FootballScore
//
//  Created by Orange on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CupMatchType.h"

@implementation CupMatchType
@synthesize matchTypeId;
@synthesize matchTypeName;
@synthesize isCurrentType;

- (id)initWithId:(NSString *)idValue name:(NSString *)name isCurrentType:(NSString*)isCurrent
{
    self = [super init];
    if (self) {
        self.matchTypeId = idValue;
        self.matchTypeName = name;
        self.isCurrentType = isCurrent;
    }
    return self;
    
}

@end
