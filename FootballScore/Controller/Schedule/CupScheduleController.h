//
//  CupScheduleController.h
//  FootballScore
//
//  Created by Orange on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PPViewController.h"
#import "LeagueScheduleController.h"
#import "RepositoryService.h"
@class League;

@interface CupScheduleController : PPViewController <UIActionSheetDelegate, RepositoryDelegate>{
    League* league;
    int currentSelection;
    int loadCounter;
    BOOL isWebViewReady;
    BOOL isGroupReady;
    BOOL firstLoadWebView;
    NSString* currentSeason;
    NSString* currentCupMatchType;
    int actionSheetIndex;
    
}
@property (retain, nonatomic) League* league;
@property (retain, nonatomic) IBOutlet UILabel *cupScheduleResultTitle;
@property (retain, nonatomic) IBOutlet UIButton *groupPointsButton;
@property (retain, nonatomic) IBOutlet UIButton *matchTypeSelectButton;
@property (retain, nonatomic) IBOutlet UIButton *matchResultButton;
@property (retain, nonatomic) IBOutlet UIWebView *dataWebView;
@property (retain, nonatomic) NSString* currentSeason;
@property (retain, nonatomic) NSString* currentCupMatchType;
@property (retain, nonatomic) NSArray* matchTypesList;

+ (void)showWithSuperController:(UIViewController*)superController League:(League*)league;
- (id)initWithLeague:(League*)leagueValue;
- (void)resetWithLeague:(League*)leagueValue;
- (void)loadWebViewByHtml:(NSString*)html;
- (void)initWebView;
- (void)initBarButton;
- (void)selectSeason;
- (void)updateView;
@end


