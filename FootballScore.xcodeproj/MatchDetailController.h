//
//  MatchDetailController.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "MatchService.h"
#import "Match.h"
#import "HJManagedImageV.h"
@class DetailHeader;

enum{
    
    SELECT_EVENT,
    SELECT_LINEUP,
    SELECT_ANALYSIS,
    SELECT_YAPEI,
    SELECT_OUPEI,
    SELECT_DAXIAO
    
};

@interface MatchDetailController : PPViewController<MatchServiceDelegate> {
    
    Match *match;
    
    HJManagedImageV *homeTeamIcon;
    HJManagedImageV *awayTeamIcon;
    UILabel *matchStateLabel;
    UILabel *matchStarttimeLabel;
    UILabel *homeTeamName;
    UILabel *awayTeamName;
    UILabel *homeTeamRank;
    UILabel *awayTeamRank;
    UIButton *eventButton;
    UIButton *lineUpButton;
    UIButton *analysisButton;
    UIButton *asianOdds;
    UIButton *auropeanOdds;
    UIButton *sizeButton;
    UIWebView *dataWebView;
    
    NSString *eventJsonArray;
    NSString *statJsonArray;
    
    DetailHeader *detailHeader;
    
    int      loadCounter;
    BOOL     showDataFinish;
    BOOL    firstLoadWebView;
    BOOL    isWebViewReady;
   
    int     currentSelection;
    
}

@property(nonatomic,retain) Match* match;

@property(nonatomic,retain) NSString *eventJsonArray;
@property(nonatomic,retain) NSString *statJsonArray;
@property(nonatomic,retain) NSString *oupeiString;
@property(nonatomic,retain) NSString *eventString;

- (id)initWithMatch:(Match *)aMatch;

- (IBAction)clickMatchesDatasButton:(id)sender;
- (IBAction)clickMatchesOupeiButton:(id)sender;

- (void)updateSelectMatchStatusButtonState:(int)selectMatchStatus;

@property (nonatomic, retain) IBOutlet HJManagedImageV *homeTeamIcon;
@property (nonatomic, retain) IBOutlet HJManagedImageV *awayTeamIcon;
@property (nonatomic, retain) IBOutlet UILabel *matchStateLabel;
@property (nonatomic, retain) IBOutlet UILabel *matchStarttimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *homeTeamName;
@property (nonatomic, retain) IBOutlet UILabel *awayTeamName;
@property (nonatomic, retain) IBOutlet UILabel *homeTeamRank;
@property (nonatomic, retain) IBOutlet UILabel *awayTeamRank;

@property (nonatomic, retain) IBOutlet UIButton *eventButton;
@property (nonatomic, retain) IBOutlet UIButton *lineUpButton;
@property (nonatomic, retain) IBOutlet UIButton *analysisButton;
@property (nonatomic, retain) IBOutlet UIButton *asianOdds;
@property (nonatomic, retain) IBOutlet UIButton *auropeanOdds;
@property (nonatomic, retain) IBOutlet UIButton *sizeButton;
@property (nonatomic, retain) IBOutlet UIWebView *dataWebView;

@property (nonatomic, retain) DetailHeader *detailHeader;

// for external call after alloc object
- (void)resetWithMatch:(Match*)newMatch;

// internal call
//-(void)matchDataButtonBackGround;
- (void)loadMatchDetailHeaderFromServer;
- (void)initWebView;
- (void)updateOupeiView:(NSString*)oupeiDataString;
- (void)updateEventView:(NSString*)eventDataString;
- (void)showWebViewByClick:(BOOL)needReload;

@end
