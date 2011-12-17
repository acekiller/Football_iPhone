//
//  UserService.h
//  FootballScore
//
//  Created by Orange on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommonService.h"

#define PUSH_SET_SUCCESS  @"成功"

@protocol UserServiceDelegate <NSObject>

@optional

- (void)getVersionFinish:(int)result data:(NSString*)data;

- (void)sendFeedbackFinish:(int)result data:(NSString*)data;

@end


@interface UserService : CommonService {
    
}

- (void)userRegisterByToken:(NSString*)token;

- (void)getVersion:(id<UserServiceDelegate>)delegate;

- (void)updateUserPushInfo:(NSString*)userId pushType:(int)pushType token:(NSString*)token;

- (void)sendFeedback:(id<UserServiceDelegate>)delegate 
              userId:(NSString*)userId 
             content:(NSString*)content 
             contact:(NSString*)contact;

@end
