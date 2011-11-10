//
//  OddsService.m
//  FootballScore
//
//  Created by Orange on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "OddsService.h"
#import "FootballNetworkRequest.h"
#import "CompanyManager.h"
#import "Company.h"

#define GET_COMPANY_LIST @"GET_COMPANY_LIST"

@implementation OddsService

- (void)updateAllBetCompanyList
{
    NSOperationQueue* queue = [self getOperationQueue:GET_COMPANY_LIST];
    
    [queue addOperationWithBlock:^{
        
        CommonNetworkOutput* output = [FootballNetworkRequest getBetCompanyList];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            CompanyManager* manager = [CompanyManager defaultCompanyManager];
            
            if (output.resultCode == ERROR_SUCCESS){
                if ([output.arrayData count] > 0) {
                    [manager.allCompany removeAllObjects];
                    NSArray* segment = [output.arrayData objectAtIndex:0];
                    if ([segment count] > 0) {
                        for (NSArray* data in segment) {
                            if ([data count] == 5) {
                                NSString* companyId = [data objectAtIndex:INDEX_OF_COMPANY_ID];
                                NSString* companyName = [data objectAtIndex:INDEX_OF_COMPANY_NAME];
                                NSString* asianOdds = [data objectAtIndex:INDEX_OF_ASIAN_ODDS];
                                NSString* europeOdds = [data objectAtIndex:INDEX_OF_EUROPE_ODDS];
                                NSString* daXiao = [data objectAtIndex:INDEX_OF_DAXIAO];
                                
                                Company* company = [[Company alloc] initWithId:companyId 
                                                                   companyName:companyName 
                                                                      asianBet:[asianOdds boolValue] 
                                                                     europeBet:[europeOdds boolValue] 
                                                                        daXiao:[daXiao boolValue]];
                                [manager addCompany:company];
                                [company release];
                            } else {
                                continue;
                            }
                            
                        }
                    }
                    else {
                        NSLog(@"segment format error:%@",[segment description]);
                    }
                   
                }
                else {
                    NSLog(@"no company list updated");
                }                
            }

        });                        
    }];

}

@end
