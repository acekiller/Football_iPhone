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

- (IBAction)clickOnSendButton:(id)sender;

@end
