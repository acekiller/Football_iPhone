//
//  ColorManager.h
//  FootballScore
//
//  Created by Orange on 11-10-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorManager : UIColor

+ (UIColor*)halfScoreColor;
+ (UIColor*)leageNameColor;
+ (UIColor*)startTimeColor;
+ (UIColor*)onGoTimeColor;
+ (UIColor*)onGoScore;
+ (UIColor*)finishScoreColor;
+ (UIColor*)leagueColor1;
+ (UIColor*)leagueColor2;
+ (UIColor*)leagueColor3;
+ (UIColor*)leagueColor4;
+ (UIColor*)leagueColor5;


+ (UIColor*)MatchesNameButtonNotChosenColor;
+ (UIColor*)ToChooseTheMatchesButtonColor;

//ScoreUpStateCell
+ (UIColor*)matchStateTextColor;
+(UIColor*)startTimeTextColor;
+(UIColor*)TeamTextColor;
+(UIColor*)MatchScoreTextColor;



//ScoreUpDateController
+(UIColor*)dateTimeTextColor;



//SelectLeagueController

+(UIColor*)HideMatchesInforNumColor;
+(UIColor*)HideMatchesInforColor;
+(UIColor*)scrollViewBackgroundColor;

//AlertController 

+(UIColor*)scoreAlertColor;
+(UIColor*)soundsAlertColor;
+(UIColor*)soundSubtitlesColor;
+(UIColor*)blackGroundColor;

//ScoreIndexCellColor
+(UIColor*)scoreIndexTitleCellBackgroundColor;
+(UIColor*)scoreIndexCellBackgroundColor;

//OddsRealTimeColor
+(UIColor *)oddsIncreaseColor;
+(UIColor *)oddsDecreaseColor;
+(UIColor *)oddsUnchangeColor;

+(UIColor *)indexTableViewBackgroundColor;

+ (UIColor *)realTimeScoreControllerTableViewBackgroundColor;


//Repository && League Controller Color

+(UIColor *)repositoryCountoryUnselectedColor;
+(UIColor *)repositoryLegueUnselectedColor;


@end
