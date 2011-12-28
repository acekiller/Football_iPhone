//
//  UserFeedbackController.h
//  FootballScore
//
//  Created by Orange on 11-10-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "UserService.h"

@interface UserFeedbackController : PPViewController <UserServiceDelegate>

@property (retain, nonatomic) IBOutlet UITextView *content;
@property (retain, nonatomic) IBOutlet UITextField *contact;

@property (retain, nonatomic) IBOutlet UILabel *appNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *versionLabel;
@property (retain, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (retain, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (retain, nonatomic) IBOutlet UILabel *disclaimerLabel;

@property (retain, nonatomic) IBOutlet UIButton *updateAppButton;

- (IBAction)clickOnSendButton:(id)sender;

@end
