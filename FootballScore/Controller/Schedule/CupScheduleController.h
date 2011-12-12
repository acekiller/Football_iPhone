//
//  CupScheduleController.h
//  FootballScore
//
//  Created by Orange on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PPViewController.h"
#import "LeagueScheduleController.h"
@class League;

@interface CupScheduleController : PPViewController <UIActionSheetDelegate>{
    League* league;
    int currentSelection;
    BOOL isWebViewReady;
    NSString* currentSeason;
    
}
@property (retain, nonatomic) League* league;

+ (void)showWithSuperController:(UIViewController*)superController League:(League*)league;
- (id)initWithLeague:(League*)leagueValue;
@property (retain, nonatomic) IBOutlet UIButton *groupPointsButton;
@property (retain, nonatomic) IBOutlet UIButton *matchTypeSelectButton;
@property (retain, nonatomic) IBOutlet UIButton *matchResultButton;
@property (retain, nonatomic) IBOutlet UIWebView *dataWebView;
@property (retain, nonatomic) NSString* currentSeason;

- (void)loadWebViewByHtml:(NSString*)html;
- (void)initWebView;
- (void)buttonTagInit;
- (void)initBarButton;
- (void)selectSeason;
+ (NSString *)creatSeasonByYearOffset:(int)offset;

@end


