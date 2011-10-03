//
//  ScoreUpdateController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "MatchService.h"

@interface ScoreUpdateController : PPTableViewController <UIActionSheetDelegate>{

    
}

- (void)getRealtimeScoreFinish:(NSSet*)updateMatchSet;
@end
