//
//  Odds.h
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Odds : NSObject {
    NSString* matchId;
    NSString* commpanyId;
    NSString* oddsId;
    
}

@property (nonatomic, retain) NSString* matchId;
@property (nonatomic, retain) NSString* commpanyId;
@property (nonatomic, retain) NSString* oddsId;

@end
