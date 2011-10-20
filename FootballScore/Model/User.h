//
//  User.h
//  FootballScore
//
//  Created by qqn_pipi on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
    
}

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *deviceToken;


- (id)initWithUserId:(NSString *)aUserId;
@end
