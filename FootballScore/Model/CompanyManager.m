//
//  CompanyManager.m
//  FootballScore
//
//  Created by Orange on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CompanyManager.h"
#import "Company.h"
#import "FootballNetworkRequest.h"

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

+ (CompanyManager*)defaultCompanyManager
{
    return GlobalGetCompanyManager();
}

- (Company*)getCompanyById:(NSString *)companyId
{
    for (Company* company in self.allCompany) {
        if ([company.companyId isEqualToString:companyId]) {
            return company;
        }
    }
    return nil;
}

- (void)addCompany:(Company*)company
{
    [self.allCompany addObject:company];
}

- (void)selectCompany:(Company*)company;
{
    [self.selectedCompany addObject:company];
}


- (void)selectCompanyById:(NSString *)companyId
{
    Company* company = [self getCompanyById:companyId];
    [self.selectedCompany addObject:company];
}

- (void)unselectCompanyById:(NSString *)companyId
{
    for (Company* company in [selectedCompany allObjects]) {
        if (company.companyId == companyId) {
            [self.selectedCompany removeObject:company];
        }
    }
}

- (id)init
{
    self = [super init];    
    allCompany = [[NSMutableArray alloc] init];
    selectedCompany = [[NSMutableSet alloc] init];
    
    return self;
}

- (void)dealloc
{
    [allCompany release];
    [selectedCompany release];
    [super dealloc];
}

@end
