//
//  SelectIndexController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-10-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

enum {
    ASIANBWIN = 220111109,
    EUROPEBWIN,
    BIGANDSMALL    
};

@protocol SeclectIndexControllerDelegate <NSObject>

- (void)SelectCompanyFinish;

@end

@interface SelectIndexController : PPViewController {
    
    UIButton *buttonAsianBwin;
    UIButton *buttonEuropeBwin;
    UIButton *buttonBigandSmall;
    int contentType;
    
    NSMutableArray *asianBwinArray;
    NSMutableArray *europeBwinArray;
    NSMutableArray *bigandSmallArray;
    
    NSMutableSet* _yapeiSelectedCompanySet;
    NSMutableSet* _oupeiSelectedCompanySet;
    NSMutableSet* _daxiaoSelectedCompanySet;
    int           selectedOddsType;

    id<SeclectIndexControllerDelegate> delegate;
    
}



@property (nonatomic, retain) IBOutlet UIButton *buttonAsianBwin;
@property (nonatomic, retain) IBOutlet UIButton *buttonEuropeBwin;
@property (nonatomic, retain) IBOutlet UIButton *buttonBigandSmall;
@property (nonatomic, assign) id<SeclectIndexControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableSet *yapeiSelectedCompanySet;
@property (nonatomic, retain) NSMutableSet* oupeiSelectedCompanySet;
@property (nonatomic, retain) NSMutableSet* daxiaoSelectedCompanySet;
@property (nonatomic, assign) int selectedOddsType;

- (IBAction)clickContentTypeButton:(id)sender;
- (void)buttonClicked:(id)sender;
- (void)createButtonsByArray:(NSArray*)array selectedCompanySet:(NSMutableSet*)selectedCompanySet;

+ (SelectIndexController*)show:(UIViewController<SeclectIndexControllerDelegate>*)superController;





@end
