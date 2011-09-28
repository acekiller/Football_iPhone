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
}

@property (nonatomic, retain) NSString    *leagueId;
@property (nonatomic, retain) NSString    *name;
@property (nonatomic, assign) BOOL        isTop;


- (id)initWithName:(NSString*)name
          leagueId:(NSString*)name
             isTop:(BOOL)isTop;



@end
