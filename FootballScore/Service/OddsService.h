//
//  OddsService.h
//  FootballScore
//
//  Created by Orange on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommonService.h"

@protocol OddsServiceDelegate <NSObject>

- (void)updateAllBetCompanyListFinish;
- (void)getOddsListFinish:(NSMutableArray*)leagues matchArray:(NSMutableArray*)matches oddsArray:(NSMutableArray*)oddsList;

@end

@interface OddsService : CommonService {
    id<OddsServiceDelegate> delegate;
    
}

- (void)updateAllBetCompanyList;
- (void)getOddsListByDate:(NSDate*)date 
           companyIdArray:(NSArray*)companyIdAray 
                 language:(int)language 
                matchType:(int)matchType 
                 oddsType:(int)oddsType;

@end
