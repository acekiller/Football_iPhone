//
//  ScoreUpdateController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScoreUpdateController : UIViewController <UIActionSheetDelegate>{
    UILabel *statusText;
    NSInteger matchScoreType;
    
}
@property (nonatomic, retain)IBOutlet UILabel *statusText;

- (IBAction)selectMatchType:(id)sender;
- (IBAction)selectLeague:(id)sender;

@end
