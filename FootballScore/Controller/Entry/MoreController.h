//
//  MoreController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "UserService.h"

@interface MoreController : PPTableViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UserServiceDelegate >{

    NSArray *listData;
    UITableView *moreOptionList;
    int whichAcctionSheet;
}

@property (nonatomic, retain) NSArray *listData;
@property (nonatomic, retain) IBOutlet UITableView *moreOptionList;

- (void)optionListInit;

- (void)showScoreAlert;
- (void)showFeedback;
- (void)showLanguageSelection;
- (void)showRecommendation;
- (void)showAbout;
- (void)updateApplication;
- (void)quitApplication;

- (void)sendSMS;
- (void)displaySMSComposerSheet;
- (void)sendEmail;
- (void)displayComposeEmail;
- (void)launchMailAppOnDevice;

@end
