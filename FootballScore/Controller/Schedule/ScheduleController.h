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
    @private
    int _scheduleType;
    int _dayDirection;
    NSDate* _initDate;
 
}
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (assign, nonatomic) int scheduleType;
@property (assign, nonatomic) int dayDirection;
@property (retain, nonatomic) NSDate* initDate;

+ (void)showScheduleWithSuperController:(UIViewController*)superViewController;
+ (void)showFinishedMatchWithSuperController:(UIViewController*)superViewController;
- (IBAction)clicksSelectDateButton:(id)sender;
- (NSString*)convertMatchStartTime:(NSDate*)date;
- (NSString*)convertStatus:(Match*)match;
- (void)initCell:(UITableViewCell*)cell;
- (void)setCell:(UITableViewCell*)cell withMatch:(Match*)match;
- (id)initWithType:(int)scheduleType initDate:(NSDate*)initDate title:(NSString*)title dayDirection:(int)dayDirection;
@property (retain, nonatomic) IBOutlet UIButton *selectedDateButton;

@end
