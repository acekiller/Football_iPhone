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



+ (LeagueManager*)defaultManager; // for match

+ (LeagueManager*)defaultIndexManager;  //for match index 
+ (LeagueManager*)defaultScheduleManager;





// parse league from request string
+ (NSArray*)fromString:(NSArray*)stringArray;

// parse index league from request string
+ (NSArray*)fromIndexString:(NSArray*)stringArray;




// update league data (array/dict)
- (void)updateLeague:(NSArray*)updateArray;

// get league name by league ID
- (NSString*)getNameById:(NSString*)leagueId;

- (UIColor*)getLeagueColorById:(NSString*)leagueId;

@end


extern LeagueManager* GlobalLeagueManager(); //for  match 
extern LeagueManager* GlobalLeagueIndexManager(); // for match index 
extern LeagueManager* GlobalLeagueScheduleManager();