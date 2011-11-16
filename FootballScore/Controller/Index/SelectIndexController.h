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
    
    NSMutableSet *selectedBwin;
    
    NSMutableArray *buttonsArray;
    id<SeclectIndexControllerDelegate> delegate;
    
}

@property (nonatomic, retain) IBOutlet UIButton *buttonAsianBwin;
@property (nonatomic, retain) IBOutlet UIButton *buttonEuropeBwin;
@property (nonatomic, retain) IBOutlet UIButton *buttonBigandSmall;
@property (nonatomic, assign) id<SeclectIndexControllerDelegate> delegate;

- (void)buttonsInit;
- (void)dataInit;
- (void)showButtonsWithArray:(NSArray*)array selectedArray:(NSMutableSet*)selectedArray;
- (IBAction)clickContentTypeButton:(id)sender;
- (void)buttonClicked:(id)sender;
- (void)createButtonsByArray:(NSArray*)array;

+ (SelectIndexController*)show:(UIViewController<SeclectIndexControllerDelegate>*)superController;
+ (void)showButtonsAtScrollView:(UIScrollView*)scrollView 
                withButtonArray:(NSMutableArray*)buttonArray
                  selectedImage:(UIImage*)selectedImage 
                unSelectedImage:(UIImage*)unSelectedImage 
                 buttonsPerLine:(int)buttonsPerLine 
                     buttonSize:(CGSize)buttonSize;


@end
