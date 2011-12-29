//
//  LeagueScheduleController.h
//  FootballScore
//
//  Created by Orange on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PPViewController.h"
#import "RepositoryService.h"
@class League;
@protocol CommonCommandInterface <NSObject>
@optional
- (void)updateCommand;
- (NSString*)execute;

@end

@interface LeagueScheduleController : PPViewController <UIActionSheetDelegate>{
    NSMutableDictionary*  buttonCommandsDict;
    League* league;
    int currentSelection;
    int loadCounter;
    int roundsCount;
    int currentRound;
    int actionSheetIndex;
    BOOL isWebViewReady;
    BOOL isGroupReady;
    BOOL firstLoadWebView;
};
@property (retain, nonatomic) IBOutlet UIWebView *dataWebView;
@property (retain, nonatomic) NSMutableDictionary* buttonCommandsDict;
@property (retain, nonatomic) IBOutlet UIButton *pointButton;
@property (retain, nonatomic) IBOutlet UIButton *scheduleButton;
@property (retain, nonatomic) IBOutlet UIButton *rangQiuButton;
@property (retain, nonatomic) IBOutlet UIButton *daxiaoButton;
@property (retain, nonatomic) IBOutlet UIButton *shooterRankingButton;
@property (retain, nonatomic) IBOutlet UIButton *seasonSelectionButton;
@property (retain, nonatomic) IBOutlet UIButton *roundSelectionButton;
@property (retain, nonatomic) League* league;
@property (assign, nonatomic) NSInteger loadCount;
@property (assign, nonatomic) BOOL showDataFinished;
@property (retain, nonatomic) NSString* currentSeason;

- (void)setScoreCommand:(id<CommonCommandInterface>)command forKey:(int)Key; 
- (id)initWithLeague:(League*)leagueValue;
- (void)resetWithLeague:(League *)leagueValue;
- (void)resetSelection;
+ (void)showWithSuperController:(UIViewController*)superController League:(League*)league;
- (void)loadWebViewByHtml:(NSString*)html;
- (void)initWebView;
- (void)showSeasonSelectionActionSheet;
- (void)resetCommand;
@end


@interface JsCommand : NSObject <CommonCommandInterface>{
@private
    NSString* jsCodeString;
    UIWebView* superControllerWebView;
}
@property (retain, nonatomic) NSString* jsCodeString;
@property (retain, nonatomic) UIWebView* superControllerWebView;
- (id)initWithJSCodeString:(NSString*)jsCode dataWebView:(UIWebView*)webView;


@end