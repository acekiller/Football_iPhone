//
//  OddsService.h
//  FootballScore
//
//  Created by Orange on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommonService.h"
#import "Odds.h"

@protocol OddsServiceDelegate <NSObject>

- (void)getOddsListFinish:(int)reslutCode;
@optional
- (void)getRealtimeOddsFinish:(NSSet *)oddsSet oddsType:(ODDS_TYPE)oddsType;


@end

@interface OddsService : CommonService {
    id<OddsServiceDelegate> delegate;
    ODDS_TYPE realTimeOddsType;
    NSTimer *realTimeOddsTimer;
}
@property (nonatomic, assign) id<OddsServiceDelegate> delegate;
@property (nonatomic, assign) ODDS_TYPE realTimeOddsType;
@property (nonatomic, retain) NSTimer *realTimeOddsTimer;
@property (nonatomic, retain) NSTimer *retryOddsCompanyTimer;

- (void)updateAllBetCompanyList;
- (void)getOddsListByDate:(NSDate*)date 
           companyIdArray:(NSArray*)companyIdAray 
                 language:(int)language 
                matchType:(int)matchType 
                 oddsType:(int)oddsType 
                 delegate:(id<OddsServiceDelegate>)delegate;

- (void)getRealtimeOdds;
- (void)startGetRealtimOddsTimer:(ODDS_TYPE)oddsType delegate:(id<OddsServiceDelegate>)oddsServicedelegate;
- (void)stopGetRealtimOddsTimer;
@end

extern OddsService *GlobalGetOddsService();