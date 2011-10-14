//
//  MoreController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MoreController : UIViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>{

    int language;
    NSArray *listData;
    UITableView *moreOptionList;
}

@property (nonatomic, retain) NSArray *listData;
@property (nonatomic, retain) IBOutlet UITableView *moreOptionList;

- (void)optionListInit;

- (void)showScoreAlert;
- (void)showFeedback;
- (void)showLanguageSelection;

@end
