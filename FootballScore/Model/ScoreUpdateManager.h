//
//  UpdateScoreManager.h
//  FootballScore
//
//  Created by qqn_pipi on 11-10-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ScoreUpdate;

@interface ScoreUpdateManager : NSObject {
    NSMutableArray *scoreUpdateList;
}

+(ScoreUpdateManager *)defaultManager;

@property (nonatomic, retain) NSMutableArray *scoreUpdateList;

- (void)insertScoreUpdate:(ScoreUpdate *)scoreUpdate;
//- (void)filter

- (id)init;
@end
