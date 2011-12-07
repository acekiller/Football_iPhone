//
//  CupScheduleController.h
//  FootballScore
//
//  Created by Orange on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PPViewController.h"
@class League;

@interface CupScheduleController : PPViewController {
    League* league;
}
@property (retain, nonatomic) League* league;

+ (void)showWithSuperController:(UIViewController*)superController League:(League*)league;
- (id)initWithLeague:(League*)leagueValue;

@end
