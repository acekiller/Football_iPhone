//
//  ScheduleService.h
//  FootballScore
//
//  Created by Orange on 11-12-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommonService.h"

@protocol ScheduleServiceDelegate <NSObject>

- (void)getMatchScheduleFinish;

@end

@interface ScheduleService : CommonService {
    
}
- (void)getSchedule:(id<ScheduleServiceDelegate>)scheduleDelegate date:(NSDate*)date;
@end

extern ScheduleService *GlobalGetScheduleService();