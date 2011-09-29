//
//  SelectLeagueController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectLeagueController : UIViewController {

    
    UILabel *promptLabel;
    UIButton *topLeagueButton;
    UIScrollView *scrollView;
    UIButton *selectNoneButton;
    UIButton *selectAllButton;
    
    NSMutableArray *buttonTagsArray;
    NSArray *buttonNamesArray;
    NSArray *topLeagueArray;
    int buttonNumbers;
}

-(IBAction)selectAll:(id)sender;
-(IBAction)selectNone:(id)sender;
-(IBAction)selectTopLeague:(id)sender;
@property (nonatomic, retain) IBOutlet UILabel *promptLabel;

@property (nonatomic, retain) IBOutlet UIButton *topLeagueButton;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *selectNoneButton;
@property (nonatomic, retain) IBOutlet UIButton *selectAllButton;
@end
