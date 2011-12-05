//
//  League.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface League : NSObject {
    
    int         sportsType;                 // football, basketball, etc

    NSString    *leagueId;
    NSString    *name;    
    BOOL        isTop;
    
    NSString *countryId;
    NSInteger leagueType;
    NSArray *seasonList;
    
}

@property (nonatomic, retain) NSString    *leagueId;
@property (nonatomic, retain) NSString    *name;
@property (nonatomic, assign) BOOL        isTop;
@property(nonatomic, retain) NSString *countryId;
@property(nonatomic, assign) NSInteger leagueType;
@property(nonatomic, retain) NSArray *seasonList;

- (id)initWithName:(NSString*)name
          leagueId:(NSString*)name
             isTop:(BOOL)isTop;
- (id)initWithLeagueId: (NSString *)lId leagueName:(NSString *)lName 
             countryId:(NSString *)cId leagueType:(NSInteger)lType 
            seasonList:(NSArray *)sList;


@end
