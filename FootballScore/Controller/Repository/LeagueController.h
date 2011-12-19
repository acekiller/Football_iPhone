//
//  LeagueController.h
//  FootballScore
//
//  Created by  on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
@class LeagueScheduleController;
@class CupScheduleController;

@interface LeagueController : PPTableViewController
{
    LeagueScheduleController* _scheduleController;
    CupScheduleController* _cupScheduleController;
    
}
@property (retain, nonatomic) LeagueScheduleController* scheduleController;
@property (retain, nonatomic) CupScheduleController*    cupScheduleController;


- (id)initWithLeagueArray:(NSArray *)leagueArray;
@end
