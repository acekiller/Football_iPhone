//
//  LeagueManager.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LeagueManager : NSObject {
    
    NSMutableArray* leagueArray;
    NSMutableDictionary* leagueData;
}

@property (nonatomic, retain) NSMutableArray* leagueArray;
@property (nonatomic, retain) NSMutableDictionary* leagueData;

// parse league from request string
+ (NSArray*)fromString:(NSArray*)stringArray;

// update league data (array/dict)
- (void)updateLeague:(NSArray*)updateArray;

// get league name by league ID
- (NSString*)getNameById:(NSString*)leagueId;

@end

extern LeagueManager* GlobalLeagueManager();