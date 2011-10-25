//
//  UpdateScoreManager.m
//  FootballScore
//
//  Created by qqn_pipi on 11-10-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ScoreUpdateManager.h"
#import "MatchManager.h"
#import "ScoreUpdate.h"

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
    [self.scoreUpdateList insertObject:scoreUpdate atIndex:0];
}

- (NSInteger)insertScoreUpdateSet:(NSSet *)scoreUpdateSet
{
    int count = 0;
    if (scoreUpdateSet == nil || [scoreUpdateSet count] == 0) {
        return 0;
    }
    for (ScoreUpdate *scoreUpdate in scoreUpdateSet) {
        if (scoreUpdate) {
            
            [self.scoreUpdateList insertObject:scoreUpdate atIndex:0];
            ++count;
        }
    }
    return count;
}

- (void)removeAllScoreUpdates
{
    [self.scoreUpdateList removeAllObjects];
}

- (void)removeScoreUpdateAtIndex:(NSUInteger)index
{
    [self.scoreUpdateList removeObjectAtIndex:index];
    
}


- (void)dealloc
{
    [scoreUpdateList release];
    [super dealloc];
}

@end
