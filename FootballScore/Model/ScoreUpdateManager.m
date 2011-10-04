//
//  UpdateScoreManager.m
//  FootballScore
//
//  Created by qqn_pipi on 11-10-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ScoreUpdateManager.h"

ScoreUpdateManager* scoreUpdateManager;

ScoreUpdateManager* GlobalGetScoreUpdateManager()
{
    if (scoreUpdateManager == nil){
        scoreUpdateManager = [[ScoreUpdateManager alloc] init];
    }
    return scoreUpdateManager;
}


@implementation ScoreUpdateManager

@synthesize scoreUpdateList;

- (id)init
{
    self = [super init];
    if (self) {
        self.scoreUpdateList = [[NSMutableArray alloc] init];
    }
    return self;
}

+(ScoreUpdateManager *)defaultManager
{
    return GlobalGetScoreUpdateManager();
}

- (void)insertScoreUpdate:(ScoreUpdate *)scoreUpdate
{
    [self.scoreUpdateList insertObject:scoreUpdateList atIndex:0];
}

- (void)dealloc
{
    [scoreUpdateList release];
    [super dealloc];
}

@end
