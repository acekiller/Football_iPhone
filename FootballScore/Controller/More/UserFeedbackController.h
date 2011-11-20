//
//  UserFeedbackController.h
//  FootballScore
//
//  Created by Orange on 11-10-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

@protocol UserFeedbackControllerDelegate <NSObject>

- (void)sendFeedbackMessage:(NSString*)message witchUserNick:(NSString*)userNick;
@end

@interface UserFeedbackController : PPViewController
{    
    id<UserFeedbackControllerDelegate> delegate;
}

- (IBAction)clickOnSendButton:(id)sender;

@end
