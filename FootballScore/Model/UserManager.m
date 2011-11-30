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


+ (void)createUser:(NSString*)userId
{
    // save to NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userId forKey:USERID];
    
}

+ (void)saveUser:(User*)user
{
    // save updated user data into NSUserDefaults    
    [UserManager createUser:user.userId];
    
}

+ (NSString *)getUserId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:USERID];
}


+ (User *) getUser
{
    NSString *userId = [UserManager getUserId];
    if (userId) {
        return [[[User alloc] initWithUserId:userId] autorelease];
    }
    return nil;
}

+ (BOOL)isUserExisted
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:USERID];
    if (userId) {
        return YES ;
    }
    return NO;
}

+ (void)saveIsPush:(BOOL)isPush
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isPush forKey:ISPUSH];
}

+ (BOOL)getIsPush
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:ISPUSH];
}

@end
