//
//  CompanyManager.h
//  FootballScore
//
//  Created by Orange on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Company;

@interface CompanyManager : NSObject {
    NSSet* selectedCompany;
    NSMutableArray* allCompany;
    int selectedOddsType;
}

@property (nonatomic, retain) NSSet* selectedCompany;
@property (nonatomic, retain) NSMutableArray* allCompany;
@property (nonatomic, assign) int selectedOddsType;

+ (CompanyManager*) defaultCompanyManager;

- (Company*) getCompanyById:(NSString*)companyId;

@end
