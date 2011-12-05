//
//  DatabaseController.h
//  FootballScore
//
//  Created by  on 11-12-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
     
    EUROPE = 1601,
    AMERICAS,
    ASIA,
    AFRICA,
    OCEANIA
} ContinentType;


@interface DatabaseController : UIViewController

- (IBAction)clickContinent:(id)sender;
@end
