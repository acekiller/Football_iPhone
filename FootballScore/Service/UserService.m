//
//  UserService.m
//  FootballScore
//
//  Created by Orange on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserService.h"
#import "FootballNetworkRequest.h"
#import "UserManager.h"
#import "LogUtil.h"
#import "RetryManager.h"

@implementation UserService

- (void)userRegisterByToken:(NSString*)token
{    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CommonNetworkOutput *output = [FootballNetworkRequest getRegisterUserId:1 token:token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.textData != nil) {
                [UserManager createUser:output.textData];
                PPDebug(@"<UserService>)userRegisterByToken: Created User <%@>",output.textData);
            }
            else {
                PPDebug(@"<UserService>)userRegisterByToken:　Get User ID faild");
            }
            
        });                        
    });    
}

- (void)getVersion:(id<UserServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  
     ^{
        CommonNetworkOutput* output = [FootballNetworkRequest getVersion];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (delegate && [delegate respondsToSelector:@selector(getVersionFinish: data:)]) {
                [delegate getVersionFinish:output.resultCode data:output.textData];
            }
        });
    });
}

- (void)updateUserPushInfo:(NSString*)userId pushType:(int)pushType token:(NSString*)token
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest updateUserPushInfo:userId pushType:pushType token:token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([output.textData isEqualToString:PUSH_SET_SUCCESS])
            {
                PPDebug(@"<UserService>)update push set success");
            }
            else
            {
                [[RetryManager defaultManager] saveNeedRetryPushSet:YES];
                PPDebug(@"<UserService>)update push set failed");
            }
        });
    });
}

- (void)sendFeedback:(id<UserServiceDelegate>)delegate 
              userId:(NSString*)userId 
             content:(NSString*)content 
             contact:(NSString*)contact
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest sendFeedbackByUserId:userId content:content contact:contact];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(output.resultCode == ERROR_SUCCESS)
            {
                PPDebug(@"<UserService>)send feekback success");
            }
            else
            {
                PPDebug(@"<UserService>)send feekback failed , error = %d",output.resultCode);
            }
            
            if (delegate && [delegate respondsToSelector:@selector(sendFeedbackFinish: data:)]) {
                [delegate sendFeedbackFinish:output.resultCode data:output.textData];
            }
            
        });
    });
}

@end
