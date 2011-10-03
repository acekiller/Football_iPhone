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

@interface MatchDetailController : PPViewController<MatchServiceDelegate> {
    Match *match;
    UIImageView *homeTeamIcon;
    UIImageView *awayTeamIcon;
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
    
    int      loadCounter;
    BOOL     showDataFinish;
}

@property(nonatomic,retain) Match* match;

@property(nonatomic,retain) NSString *eventJsonArray;
@property(nonatomic,retain) NSString *statJsonArray;

- (id)initWithMatch:(Match *)aMatch;

@property (nonatomic, retain) IBOutlet UIImageView *homeTeamIcon;
@property (nonatomic, retain) IBOutlet UIImageView *awayTeamIcon;
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



@end
