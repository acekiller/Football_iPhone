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

@implementation UserService

- (void)userRegisterByToken:(NSString*)token
{
    NSOperationQueue* queue = [self getOperationQueue:@"GET_USER_ID"];
    [queue cancelAllOperations];
    
    [queue addOperationWithBlock:^{
        
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
    }];
    
}



@end
