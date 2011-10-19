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

+ (void)createUser:(NSString*)userId deviceToken:(NSString*)deviceToken;

+ (void)saveUser:(User*)user;

+ (BOOL)isUserExisted;

+ (NSString *)getUserId;

+ (NSString *)getDeviceToken;

+ (User *) getUser;
@end
