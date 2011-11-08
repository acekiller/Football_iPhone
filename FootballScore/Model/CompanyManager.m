//
//  CompanyManager.m
//  FootballScore
//
//  Created by Orange on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CompanyManager.h"
#import "Company.h"

CompanyManager* companyManager;

CompanyManager* GlobalGetCompanyManager()
{
    if (companyManager == nil){
        companyManager = [[CompanyManager alloc] init];
    }
    
    return companyManager;
}

@implementation CompanyManager

@synthesize selectedCompany;
@synthesize allCompany;
@synthesize selectedOddsType;

+ (CompanyManager*) defaultCompanyManager
{
    return GlobalGetCompanyManager();
}

- (Company*) getCompanyById:(NSString *)companyId
{
    for (Company* company in self.allCompany) {
        if (company.companyId == companyId) {
            return company;
        }
    }
    return nil;
}

@end
