//
//  DataBaseService.h
//  FootballScore
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
@protocol DataBaseDelegate <NSObject>

@optional
- (void)willUpdateDataBase;
- (void)didUpdateDataBase:(NSInteger)errorCode;

@end

@interface DataBaseService : CommonService
{

}

- (void) updateDataBase:(NSInteger)language delegate:(id<DataBaseDelegate>)aDelegate;
@end
