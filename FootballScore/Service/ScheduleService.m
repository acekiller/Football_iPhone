//
//  ScheduleService.m
//  FootballScore
//
//  Created by Orange on 11-12-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ScheduleService.h"
#import "FootballNetworkRequest.h"
#import "LanguageManager.h"
#import "LeagueManager.h"
#import "MatchManager.h"
#import "TimeUtils.h"

@implementation ScheduleService

- (NSDate*)parseSeverDate:(NSArray*)dataArray
{
    if ([dataArray count] == 0)
        return nil;
    
    NSArray* fields = [dataArray objectAtIndex:0];
    if ([fields count] == 0)
        return nil;
    
    NSString* dateString = [fields objectAtIndex:0];
    if (dateString == nil)
        return nil;
    
    return dateFromChineseStringByFormat(dateString, DEFAULT_DATE_FORMAT);
}

- (void)getSchedule:(id<ScheduleServiceDelegate>)delegate date:(NSDate*)date
{
    int lang = [LanguageManager getLanguage]; 
   
    CommonNetworkOutput* output = [FootballNetworkRequest getWeeklyScheduleByDate:date language:lang];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDate* serverDate = nil;
            NSArray* leagueArray = nil;
            NSArray* updateMatchArray = nil;
            
            if (output.resultCode == ERROR_SUCCESS){
                
                // parse server timestamp and update 
                serverDate = [self parseSeverDate:
                              [output.arrayData objectAtIndex:REALTIME_MATCH_SERVER_TIMESTAMP]];
                [[MatchManager defaultMatchScheduleManager] updateServerDate:serverDate];
                
                // parse league data and update                        
                leagueArray = [LeagueManager fromString:
                               [output.arrayData objectAtIndex:REALTIME_MATCH_LEAGUE]];                    
                [[LeagueManager defaultLeagueScheduleManager] updateLeague:leagueArray];
                
                // parser result into match array and update
                updateMatchArray = [MatchManager fromString:
                                    [output.arrayData objectAtIndex:REALTIME_MATCH_DATA]];
                [[MatchManager defaultMatchScheduleManager] updateAllMatchArray:updateMatchArray];
            }
            
            // step 2 : update UI
            if (delegate && [delegate respondsToSelector:
                             @selector(getMatchScheduleFinish)]){
                [delegate getMatchScheduleFinish];
            }
            
        });                        

}

@end
