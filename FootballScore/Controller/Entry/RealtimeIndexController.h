//
//  RealtimeIndexController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "OddsService.h"
#import "SelectIndexController.h"

@interface RealtimeIndexController : PPTableViewController <OddsServiceDelegate, UIActionSheetDelegate, SeclectIndexControllerDelegate>{
    NSMutableDictionary* matchOddsList;
    NSMutableArray* companyIdArray;
    NSString* oddsTimeString;
    int oddsType;
        
}
@property (nonatomic, retain) NSMutableDictionary* matchOddsList;
@property (nonatomic, retain) NSMutableArray* companyIdArray;
@property (nonatomic, retain) NSString* oddsTimeString;

- (IBAction)clickContentFilterButton:(id)sender;
- (IBAction)clickSearcHistoryBackButton:(id)sender;

@end


@interface RealtimeIndexHeaderView : UIView {
@private
    
}
- (id)initWithMatchId:(NSString *)matchId;
@end
