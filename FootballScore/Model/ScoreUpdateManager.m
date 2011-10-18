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
    
   // [self.scoreUpdateList removeObject:[self.scoreUpdateList objectAtIndex:index]];
    
}

//- (NSSet *)getScoreUpdateSetWithMatch:(Match *)match homeScore:(NSString *)homeScore 
//              awayScore:(NSString *)awayScore homeRed:(NSString *)homeRed 
//                awayRed:(NSString *)awayRed homeYellow:(NSString *)homeYellow 
//              awayYellow:(NSString *)awayYellow
//
//{
//    MatchManager *matchManager = [MatchManager defaultManager];
//    
//    NSMutableSet *retSet = [[[NSMutableSet alloc] init]autorelease];
//    //home team score update
//    int increase = [homeScore intValue] - [matchManager getHomeTeamScore:match];
//    if (increase > 0) {
//        ScoreUpdate *homeScoreUpdate = [[ScoreUpdate alloc] initWithMatch:match ScoreUpdateType:HOMETEAMSCORE];
////        [self insertScoreUpdate:homeScoreUpdate];
//        [retSet addObject:homeScoreUpdate];
//        [homeScoreUpdate release];
//    }
//    
//    //away team score update
//    increase = [awayScore intValue] - [matchManager getAwayTeamScore:match];
//    if (increase > 0) {
//        ScoreUpdate *awayScoreUpdate = [[ScoreUpdate alloc] initWithMatch:match ScoreUpdateType:AWAYTEAMSCORE];
////        [self insertScoreUpdate:awayScoreUpdate];
//        [retSet addObject:awayScoreUpdate];
//        [awayScoreUpdate release];
//    }
//    
//    //home team red card update
//    increase = [homeRed intValue] - [matchManager getHomeTeamRedCount:match];
//    if (increase > 0) {
//        ScoreUpdate *homeRedUpdate = [[ScoreUpdate alloc] initWithMatch:match ScoreUpdateType:HOMETEAMRED];
////        [self insertScoreUpdate:homeRedUpdate];
//        [retSet addObject:homeRedUpdate];
//        [homeRedUpdate release];
//    }
//    
//    //away team red card update
//    increase = [awayRed intValue] - [matchManager getAwayTeamRedCount:match];
//    if (increase > 0) {
//        ScoreUpdate *awayRedUpdate = [[ScoreUpdate alloc] initWithMatch:match ScoreUpdateType:AWAYTEAMRED];
////        [self insertScoreUpdate:awayRedUpdate];
//        [retSet addObject:awayRedUpdate];
//        [awayRedUpdate release];
//        
//    }
//    
//    //home team yellow card update
//    increase = [homeYellow intValue] - [matchManager getHomeTeamYellowCount:match];
//    if (increase > 0) {
//        ScoreUpdate *homeYellowUpdate = [[ScoreUpdate alloc] initWithMatch:match ScoreUpdateType:HOMETEAMYELLOW];
////        [self insertScoreUpdate:homeYellowUpdate];
//        [retSet addObject:homeYellowUpdate];
//        [homeYellowUpdate release];
//    }
//    
//    //away team yellow card update
//    increase = [awayYellow intValue] - [matchManager getAwayTeamYellowCount:match];
//    if (increase > 0) {
//        ScoreUpdate *awayYellowUpdate = [[ScoreUpdate alloc] initWithMatch:match ScoreUpdateType:AWAYTEAMYELLOW];
////        [self insertScoreUpdate:awayYellowUpdate];
//        [retSet addObject:awayYellowUpdate];
//        [awayYellowUpdate release];
//    }
//    return retSet;
//}



- (void)dealloc
{
    [scoreUpdateList release];
    [super dealloc];
}

@end
