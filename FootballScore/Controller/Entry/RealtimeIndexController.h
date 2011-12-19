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
    BOOL hasClickedRefresh;    
}
@property (nonatomic, retain) NSMutableDictionary* matchOddsList;
@property (nonatomic, retain) NSMutableArray* companyIdArray;
@property (nonatomic, retain) NSDate* oddsDate;
@property (nonatomic, assign) int matchType;
@property (nonatomic, assign) int oddsType;
@property (nonatomic, retain) NSMutableSet *hideSectionSet;

- (void)updateAllOddsData;
- (void)refleshOddsType;
- (void)refleshCompanyIdArray;
- (void)filterOddsByLeague:(NSSet*)filterLeagueIdSet;
- (BOOL)isSectionHide:(NSInteger)section;
- (void)addSectionToHideSet:(NSInteger)section;
- (void)removeSectionFromHideSet:(NSInteger)section;
- (void)updateHeaderMatch;

- (void)setRightBarButtons;
- (void)clickSelectContentButton;
- (void)clickSelectLeagueButton;
- (void)clickSearcHistoryButton;

@end


@interface RealtimeIndexHeaderView : UIView {
@private
    
}
- (id)initWithMatchId:(NSString *)matchId;
- (void)setBackgroundImage:(UIImage *)image;
+ (CGFloat)getHeight;
@end
