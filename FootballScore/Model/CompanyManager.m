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
#import "LogUtil.h"

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

+ (int)getOddsType
{
    return GlobalGetCompanyManager().selectedOddsType;
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
    if (company != nil){
        [self.selectedCompany addObject:company];
    }
    else{
        PPDebug(@"WARNING <selectCompanyById> but no company id(%@) found!", companyId);
    }
}

- (void)unselectCompanyById:(NSString *)companyId
{
    for (Company* company in [selectedCompany allObjects]) {
        if ([company.companyId isEqualToString:companyId]) {
            [self.selectedCompany removeObject:company];
        }
    }
}

- (BOOL)hasCompanyData
{
    if ([allCompany count] > 0)
        return YES;
    else
        return NO;
}

- (BOOL)hasInitSelectCompany
{
    if ([selectedCompany count] > 0)
        return YES;
    else
        return NO;
}

- (void)initSelectCompany
{
    int initMaxCount = 4;
    int count = 0;
    for (Company* company in allCompany){
        if (company.hasAsianOdds == YES) {
            [selectedCompany addObject:company];
            count ++;
        }
        if (count >= initMaxCount){
            break;
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
