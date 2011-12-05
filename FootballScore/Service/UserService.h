//
//  UserService.h
//  FootballScore
//
//  Created by Orange on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommonService.h"

@protocol UserServiceDelegate <NSObject>

@optional

- (void)getVersionFinish:(int)result data:(NSString*)data;

@end

@interface UserService : CommonService {
    
}

- (void)userRegisterByToken:(NSString*)token;

- (void)getVersion:(id<UserServiceDelegate>)delegate;

@end
