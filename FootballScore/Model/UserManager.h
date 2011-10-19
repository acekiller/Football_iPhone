//
//  UserManager.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USERID @"footballUserId"
#define DEVICETOKEN @"deviceToken"

@class User;

@interface UserManager : NSObject {
    
}

+ (void)createUser:(NSString*)userId;

+ (void)saveUser:(User*)user;

+ (BOOL)isUserExisted;

+ (NSString *)getUserId;

+ (User *) getUser;

@end
