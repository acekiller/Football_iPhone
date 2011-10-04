//
//  DetailHeader.h
//  FootballScore
//
//  Created by qqn_pipi on 11-10-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IMAGE_PREFFIX_URL @"http://info.bet007.com/image/team/"

enum{
    INDEX_DETAIL_HEADER_HOME_TEAM_SCNAME = 0,
    INDEX_DETAIL_HEADER_AWAY_TEAM_SCNAME,
    INDEX_DETAIL_HEADER_HOME_TEAM_YYNAME,
    INDEX_DETAIL_HEADER_AWAY_TEAM_YYNAME,
    
    INDEX_DETAIL_HEADER_MATCH_STATUS,
    INDEX_DETAIL_HEADER_MATCH_TIME,
    INDEX_DETAIL_HEADER_HOME_TEAM_RANK,
    INDEX_DETAIL_HEADER_AWAY_TEAM_RANK,
    INDEX_DETAIL_HEADER_HOME_TEAM_IMAGE,
    INDEX_DETAIL_HEADER_AWAY_TEAM_IMAGE,
    
    INDEX_DETAIL_HEADER_HOME_TEAM_SCORE,
    INDEX_DETAIL_HEADER_AWAY_TEAM_SCORE,
    INDEX_DETAIL_HEADER_HAS_LINEUP,
   
//    INDEX_DETAIL_HEADER_HOME_TEAM_HALF_SCORE,
    
//    INDEX_DETAIL_HEADER_AWAY_TEAM_HALF_SCORE,
    
    DETAIL_HEADER_FILED_COUNT
};

@interface DetailHeader : NSObject {
    NSString *homeTeamSCName; //简体名字
    NSString *awayTeamSCName;
    NSString *homeTeamYYName; //粤语名
    NSString *awayTeamYYName;
    NSInteger matchStatus;
    NSString *matchDateString;
    NSString *homeTeamRank;
    NSString *awayTeamRank;   
    NSString *homeTeamImage;
    NSString *awayTeamImage;
    NSInteger homeTeamScore;
    NSInteger awayTeamScore;
//    NSInteger homeHalfScore;
//    NSInteger awayHalfScore;
    BOOL hasLineUp;
}

@property(nonatomic, retain) NSString *homeTeamSCName; //简体名字
@property(nonatomic, retain) NSString *awayTeamSCName;
@property(nonatomic, retain) NSString *homeTeamYYName; //粤语名
@property(nonatomic, retain) NSString *awayTeamYYName;
@property(nonatomic, assign) NSInteger matchStatus;
@property(nonatomic, retain) NSString *matchDateString;
@property(nonatomic, retain) NSString *homeTeamRank;
@property(nonatomic, retain) NSString *awayTeamRank;   
@property(nonatomic, retain) NSString *homeTeamImage;
@property(nonatomic, retain) NSString *awayTeamImage;
@property(nonatomic, assign) NSInteger homeTeamScore;
@property(nonatomic, assign) NSInteger awayTeamScore;
//@property(nonatomic, assign) NSInteger homeHalfScore;
//@property(nonatomic, assign) NSInteger awayHalfScore;
@property(nonatomic, assign) BOOL hasLineUp;

- (id)initWithDetailHeaderArray:(NSArray *)headerArray;
@end
