//
//  Odds.h
//  FootballScore
//
//  Created by Orange on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum ODDS_TYPE {
    ODDS_TYPE_INVALIDE = -1,
    ODDS_TYPE_YAPEI = 1,
    ODDS_TYPE_OUPEI = 2,
    ODDS_TYPE_DAXIAO = 3
}ODDS_TYPE;


@interface Odds : NSObject {
    NSString* matchId;
    NSString* commpanyId;
    NSString* oddsId;
    
}

@property (nonatomic, retain) NSString* matchId;
@property (nonatomic, retain) NSString* commpanyId;
@property (nonatomic, retain) NSString* oddsId;
-(ODDS_TYPE) oddsType;
@end
