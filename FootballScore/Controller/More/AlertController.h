//
//  AlertController.h
//  FootballScore
//
//  Created by Orange on 11-10-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
@protocol AlertControllerDelegate <NSObject>

- (void)setSoundSwitch:(int)soundSwitch shakingswitch:(int)shakingSwitch pushType:(int)pushType;

@end

@interface AlertController : PPViewController<UITableViewDataSource,UITableViewDelegate> {
   
    int pushType;
    
    
    NSDictionary *  alertTitles;
    NSArray  * alertGroupsInfor;
    
   
    NSArray  *array;
    NSDictionary *dictionary;
    
    UISlider *timeIntervalSlider;
    UILabel *sliderValueLable;
    UILabel *secondLable;
}



@property(nonatomic,retain)    NSDictionary *  alertTitles;
@property(nonatomic,retain)  NSArray  * alertGroupsInfor;


@property(nonatomic,retain)NSArray *array;
@property(nonatomic,retain)NSDictionary *dictionary;

@property (nonatomic, assign) int pushType;

@property(nonatomic,retain)UISlider *timeIntervalSlider;
@property(nonatomic,retain)UILabel *sliderValueLable;
@property(nonatomic,retain)UILabel *secondLable;

@end
