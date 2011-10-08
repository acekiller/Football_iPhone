//
//  UserManager.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface UserManager : NSObject {
    
}

+ (User*)getUser;

+ (void)createUser:(NSString*)userId deviceToken:(NSString*)deviceToken;

+ (void)saveUser:(User*)user;

@end
