//
//  MoreController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@interface MoreController : PPTableViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{

    NSArray *listData;
    UITableView *moreOptionList;
}

@property (nonatomic, retain) NSArray *listData;
@property (nonatomic, retain) IBOutlet UITableView *moreOptionList;

- (void)optionListInit;

- (void)showScoreAlert;
- (void)showFeedback;
- (void)showLanguageSelection;
- (void)showRecommendation;
- (void)showAbout;
- (void)quitApplication;

@end
