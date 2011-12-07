//
//  LeagueScheduleController.h
//  FootballScore
//
//  Created by Orange on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PPViewController.h"
@class League;
@protocol CommonCommandDelegate <NSObject>

- (void)execute;

@end

@interface LeagueScheduleController : PPViewController {
    NSMutableDictionary*  buttonCommandsDict;
    League* league;
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

- (void)setScoreCommand:(id<CommonCommandDelegate>)command forKey:(int)Key; 
- (id)initWithLeague:(League*)leagueValue;
+ (void)showWithSuperController:(UIViewController*)superController League:(League*)league;
@end


@interface JsCommand : NSObject <CommonCommandDelegate>{
@private
    NSString* jsCodeString;
    UIWebView* superControllerWebView;
}
- (id)initWithJSCodeString:(NSString*)jsCode dataWebView:(UIWebView*)webView;


@end