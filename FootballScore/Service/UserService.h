//
//  UserService.h
//  FootballScore
//
//  Created by Orange on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommonService.h"

@interface UserService : CommonService {
    
}

- (void)userRegisterByToken:(NSString*)token;

- (void)getVersion;

@end
