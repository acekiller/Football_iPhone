//
//  Company.h
//  FootballScore
//
//  Created by Orange on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject <NSCoding> {
    NSString* companyId;
    NSString* companyName;
    BOOL      hasAsianOdds;
    BOOL      hasEuropeOdds;
    BOOL      hasDaXiao;
}

@property (nonatomic, retain) NSString* companyId;
@property (nonatomic, retain) NSString* companyName;
@property (nonatomic, assign) BOOL      hasAsianOdds;
@property (nonatomic, assign) BOOL      hasEuropeOdds;
@property (nonatomic, assign) BOOL      hasDaXiao;

- (id) initWithId:(NSString*)idvalue 
      companyName:(NSString*)name 
         asianBet:(BOOL)asianBet 
        europeBet:(BOOL)europeBet 
           daXiao:(BOOL)daXiao;

@end
