//
//  AlertController.h
//  FootballScore
//
//  Created by Orange on 11-10-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertControllerDelegate <NSObject>

- (void)setSoundSwitch:(int)soundSwitch shakingswitch:(int)shakingSwitch pushType:(int)pushType;

@end

@interface AlertController : UIViewController {
    UISwitch *soundSwitch;
    UISwitch *shakingSwitch;
    int pushType;
}

@property (nonatomic, retain) IBOutlet UISwitch *soundSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *shakingSwitch;
@property (nonatomic, assign) int pushType;

@end
