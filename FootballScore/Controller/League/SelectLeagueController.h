//
//  SelectLeagueController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

@protocol SelectLeagueControllerDelegate <NSObject>

- (void)didSelectLeague:(NSSet*)selectedLeagueArray;

@end

@interface SelectLeagueController : PPViewController {

    
    UILabel *promptLabel;
    UIButton *topLeagueButton;
    UIScrollView *scrollView;
    UIButton *selectNoneButton;
    UIButton *selectAllButton;
    UILabel  *hideMatchesUpDateInf;
    
    UILabel *hideMatchesLabel1;
    UILabel *hideMatchesLabel2;
    
    
    NSMutableSet *selectLeagueIdArray;
    
    id<SelectLeagueControllerDelegate> delegate;    
}

-(IBAction)selectAll:(id)sender;
-(IBAction)selectNone:(id)sender;
-(IBAction)selectTopLeague:(id)sender;

- (BOOL)isLeagueSelected:(NSString*)leagueId;


- (void)clickDone:(id)sender;
- (IBAction)confirmButton:(id)sender;

- (void)updateHiddenMatchInfo;

@property (nonatomic, retain) IBOutlet UILabel *promptLabel;
@property (nonatomic, retain) IBOutlet UIButton *topLeagueButton;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *selectNoneButton;
@property (nonatomic, retain) IBOutlet UIButton *selectAllButton;
@property (nonatomic ,retain) IBOutlet UILabel *hideMatchesUpDateInf;
@property (nonatomic ,retain) IBOutlet UILabel *hideMatchesLabel1;
@property (nonatomic ,retain) IBOutlet UILabel *hideMatchesLabel2;



@property (nonatomic, retain) id<SelectLeagueControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableSet *selectLeagueIdArray;

+ (SelectLeagueController*)show:(UIViewController<SelectLeagueControllerDelegate>*)superController;

@end
