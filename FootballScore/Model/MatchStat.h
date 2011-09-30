//
//  MatchStat.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MatchStat : NSObject {
    
    int         type;
    NSString    *homeValue;
    NSString    *awayValue;
}
@property (nonatomic, assign)int type;
@property (nonatomic, retain)NSString *homeValue;
@property (nonatomic, retain)NSString *awayValue;


@end
