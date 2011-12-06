//
//  RepositoryController.h
//  FootballScore
//
//  Created by  on 11-12-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "RepositoryService.h"



@interface RepositoryController : PPTableViewController<RepositoryDelegate,UITextFieldDelegate>
{
    NSInteger selectedContinent;
    NSArray *filterCountryArray;
}

@property (nonatomic, retain)     NSArray *filterCountryArray;
- (IBAction)clickContinent:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)clickSearch:(id)sender;

@end
