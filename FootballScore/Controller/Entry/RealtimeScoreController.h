//
//  RealtimeScoreController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "SelectLeagueController.h"
#import "MatchService.h"

@interface RealtimeScoreController : PPTableViewController <MatchServiceDelegate, 
    UIActionSheetDelegate, SelectLeagueControllerDelegate> {
    
    int matchScoreType;
        
    NSTimer *matchSecondTimer;
}

@property (nonatomic, retain) NSTimer *matchSecondTimer;

- (IBAction)clickSelectMatchStatus:(id)sender;


@end
