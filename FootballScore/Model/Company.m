//
//  Company.m
//  FootballScore
//
//  Created by Orange on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Company.h"

@implementation Company

@synthesize companyId;
@synthesize companyName;
@synthesize hasAsianOdds;
@synthesize hasEuropeOdds;
@synthesize hasDaXiao;

- (void)dealloc
{
    [companyId release];
    [companyName release];
    [super dealloc];
}

- (id) initWithId:(NSString*)idvalue 
      companyName:(NSString*)name 
         asianBet:(BOOL)asianBet 
        europeBet:(BOOL)europeBet 
           daXiao:(BOOL)daXiao
{
    [super init];
    self.companyId = idvalue;
    self.companyName = name;
    self.hasAsianOdds = asianBet;
    self.hasEuropeOdds = europeBet;
    self.hasDaXiao = daXiao;
    return self;
}


- (void) encodeWithCoder: (NSCoder *)coder  
{  
    [coder encodeObject:companyId forKey:@"companyId"];  
    [coder encodeObject:companyName forKey:@"companyName"];  
    [coder encodeBool:hasAsianOdds forKey:@"hasAsianOdds"];
    [coder encodeBool:hasEuropeOdds forKey:@"hasEuropeOdds"];
    [coder encodeBool:hasDaXiao forKey:@"hasDaXiao"];
    
} 

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init])  
    {  
        self.companyId = [coder decodeObjectForKey:@"matchId"];  
        self.companyName = [coder decodeObjectForKey:@"leagueId"];  
        self.hasAsianOdds = [coder decodeBoolForKey:@"status"];
        self.hasEuropeOdds = [coder decodeBoolForKey:@"date"];
        self.hasDaXiao = [coder decodeBoolForKey:@"firstHalfStartDate"];

    }  
    return self; 
    
}


@end
