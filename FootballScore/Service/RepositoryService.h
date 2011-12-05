//
//  RepositoryService.h
//  FootballScore
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
@protocol RepositoryDelegate <NSObject>

@optional
- (void)willUpdateRepository;
- (void)didUpdateRepository:(NSInteger)errorCode;

@end

@interface RepositoryService : CommonService
{

}

- (void) updateRepository:(NSInteger)language delegate:(id<RepositoryDelegate>)aDelegate;
@end
