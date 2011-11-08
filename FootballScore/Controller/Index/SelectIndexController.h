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
    ASIANBWIN = 11,
    EUROPEBWIN,
    BIGANDSMALL    
};



@interface SelectIndexController : PPViewController {
    
    UIScrollView *buttonScrollView;
    UIButton *buttonAsianBwin;
    UIButton *buttonEuropeBwin;
    UIButton *buttonBigandSmall;
    int contentType;
    
    NSArray *asianBwinArray;
    NSArray *europeBwinArray;
    NSArray *bigandSmallArray;
    
    NSMutableSet *selectedBwin;
    
    NSMutableArray *buttonsArray;
    
}

@property (nonatomic, retain) IBOutlet UIScrollView *buttonScrollView;
@property (nonatomic, retain) IBOutlet UIButton *buttonAsianBwin;
@property (nonatomic, retain) IBOutlet UIButton *buttonEuropeBwin;
@property (nonatomic, retain) IBOutlet UIButton *buttonBigandSmall;

- (void)buttonsInit;
- (void)dataInit;
- (void)showButtonsWithArray:(NSArray*)array selectedArray:(NSMutableSet*)selectedArray;
- (IBAction)clickContentTypeButton:(id)sender;
- (void)buttonClicked:(id)sender;

+ (void)showButtonsAtScrollView:(UIScrollView*)scrollView 
                withButtonArray:(NSMutableArray*)buttonArray
                  selectedImage:(UIImage*)selectedImage 
                unSelectedImage:(UIImage*)unSelectedImage 
                 buttonsPerLine:(int)buttonsPerLine 
                     buttonSize:(CGSize)buttonSize;


@end
