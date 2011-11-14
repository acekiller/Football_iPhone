//
//  OddsManager.h
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YaPei;
@class OuPei;
@class DaXiao;

@interface OddsManager : NSObject {
    NSMutableArray *leagueArray;
    NSMutableArray *matchArray;
    NSMutableArray *yapeiArray;
    NSMutableArray *oupeiArray;
    NSMutableArray *daxiaoArray;
    
}

@property (nonatomic, retain) NSMutableArray* matchArray;
@property (nonatomic, retain) NSMutableArray* leagueArray;
@property (nonatomic, retain) NSMutableArray* yapeiArray;
@property (nonatomic, retain) NSMutableArray* oupeiArray;
@property (nonatomic, retain) NSMutableArray* daxiaoArray;

+ (OddsManager*)defaultManager;

@end
