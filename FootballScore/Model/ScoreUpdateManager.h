//
//  UpdateScoreManager.h
//  FootballScore
//
//  Created by qqn_pipi on 11-10-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScoreUpdate;
@class Match;

@interface ScoreUpdateManager : NSObject {
    NSMutableArray *scoreUpdateList;
}

+(ScoreUpdateManager *)defaultManager;

@property (nonatomic, retain) NSMutableArray *scoreUpdateList;

- (void)insertScoreUpdate:(ScoreUpdate *)scoreUpdate;

//- (void)filter

//- (NSSet *)getScoreUpdateSetWithMatch:(Match *)match homeScore:(NSString *)homeScore 
//              awayScore:(NSString *)awayScore homeRed:(NSString *)homeRed 
//            awayRed:(NSString *)awayRed homeYellow:(NSString *)homeYellow 
//              awayYellow:(NSString *)awayYellow;

- (NSInteger)insertScoreUpdateSet:(NSSet *)scoreUpdateSet;

- (void)removeScoreUpdateAtIndex:(NSUInteger)index;

- (void)removeAllScoreUpdates;

- (id)init;
@end
