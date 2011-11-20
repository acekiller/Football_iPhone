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
#import "SelectLeagueController.h"

@interface RealtimeIndexController : PPTableViewController <OddsServiceDelegate, UIActionSheetDelegate, SeclectIndexControllerDelegate, SelectLeagueControllerDelegate>{
    NSMutableDictionary* matchOddsList;
    NSMutableArray* companyIdArray;
    NSDate* oddsDate;
    int oddsType;
    int matchType;
    NSMutableSet *hideSectionSet;
}
@property (nonatomic, retain) NSMutableDictionary* matchOddsList;
@property (nonatomic, retain) NSMutableArray* companyIdArray;
@property (nonatomic, retain) NSDate* oddsDate;
@property (nonatomic, assign) int matchType;
@property (nonatomic, assign) int oddsType;
@property (nonatomic, retain) NSMutableSet *hideSectionSet;

- (IBAction)clickContentFilterButton:(id)sender;
- (IBAction)clickSearcHistoryBackButton:(id)sender;
-(IBAction)clickSelectLeagueController:(id)sender;
- (void)updateAllOddsData;
- (void)refleshOddsType;
- (void)refleshCompanyIdArray;
- (void)filterOddsByLeague:(NSSet*)filterLeagueIdSet;
- (BOOL)isSectionHide:(NSInteger)section;
- (void)addSectionToHideSet:(NSInteger)section;
- (void)removeSectionFromHideSet:(NSInteger)section;
- (void)updateHeaderMatch;

@end


@interface RealtimeIndexHeaderView : UIView {
@private
    
}
- (id)initWithMatchId:(NSString *)matchId;
@end
