//
//  CompanyManager.h
//  FootballScore
//
//  Created by Orange on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

enum {
    INDEX_OF_COMPANY_ID = 0,
    INDEX_OF_COMPANY_NAME,
    INDEX_OF_ASIAN_ODDS,
    INDEX_OF_EUROPE_ODDS,
    INDEX_OF_DAXIAO
};

#import <Foundation/Foundation.h>
@class Company;

@interface CompanyManager : NSObject {
    NSMutableSet* selectedCompany;
    NSMutableArray* allCompany;
    int selectedOddsType;
}

@property (nonatomic, retain) NSMutableSet* selectedCompany;
@property (nonatomic, retain) NSMutableArray* allCompany;
@property (nonatomic, assign) int selectedOddsType;

+ (CompanyManager*)defaultCompanyManager;

- (Company*)getCompanyById:(NSString*)companyId;
- (void )addCompany:(Company*)company;
- (void)selectCompanyById:(NSString*)companyId;
- (void)unselectCompanyById:(NSString*)companyId;

@end
