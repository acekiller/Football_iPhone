//
//  ScheduleController.h
//  FootballScore
//
//  Created by Orange on 11-12-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import "PPTableViewController.h"
#import "ScheduleService.h"
@class Match;

@interface ScheduleController : PPTableViewController <ScheduleServiceDelegate, UIActionSheetDelegate>{
    
}
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;

+ (void)showScheduleWithSuperController:(UIViewController*)superViewController;
+ (void)showFinishedMatchWithSuperController:(UIViewController*)superViewController;
- (IBAction)clicksSelectDateButton:(id)sender;
- (NSString*)convertMatchStartTime:(NSDate*)date;
- (NSString*)convertStatus:(Match*)match;
- (void)initCell:(UITableViewCell*)cell;
- (void)setCell:(UITableViewCell*)cell withMatch:(Match*)match;
@property (retain, nonatomic) IBOutlet UIButton *selectedDateButton;

@end
