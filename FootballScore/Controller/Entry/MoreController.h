//
//  MoreController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MoreController : UIViewController <UIActionSheetDelegate>{
    
    UIButton *selectLanguage;
    int language;
}
@property (nonatomic, retain) IBOutlet UIButton *selectLanguage;

- (IBAction)clickOnSelectLanguage:(id)sender;

@end
