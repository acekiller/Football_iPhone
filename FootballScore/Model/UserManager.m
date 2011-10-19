//
//  UserManager.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"
#import "User.h"

@implementation UserManager


+ (void)createUser:(NSString*)userId deviceToken:(NSString*)deviceToken
{
    // save to NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userId forKey:USERID];
    [userDefaults setObject:deviceToken forKey:DEVICETOKEN];
    
}

+ (void)saveUser:(User*)user
{
    // save updated user data into NSUserDefaults    
    [UserManager createUser:user.userId deviceToken:user.deviceToken];
    
}

+ (NSString *)getUserId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:USERID];
}

+ (NSString *)getDeviceToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:DEVICETOKEN];
}

+ (User *) getUser
{
    NSString *userId = [UserManager getUserId];
    NSString *deviceToken = [UserManager getDeviceToken];
    if (userId) {
        return [[[User alloc] initWithUserId:userId deviceToken:deviceToken]autorelease];
    }
    return nil;
}

+ (BOOL)isUserExisted
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:USERID];
    if (userId) {
        return true;
    }
    return false;
}

@end
