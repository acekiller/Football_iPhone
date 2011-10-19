//
//  FootballNetworkRequest.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "FootballNetworkRequest.h"
#import "StringUtil.h"

#define URL_GET_REALTIME_MATCH      @"http://bf.bet007.com/phone/schedule.aspx?"
#define URL_GET_MATCH_DETAIL        @"http://bf.bet007.com/phone/ResultDetail.aspx?"
#define URL_GET_REALTIME_SCORE      @"http://bf.bet007.com/phone/LiveChange.aspx"
#define URL_GET_MATCH_DETAIL_HEADER @"http://bf.bet007.com/phone/ScheduleDetail.aspx?"
#define URL_GET_REGISTER_USER_ID    @"http://bf.bet007.com/phone/Register.aspx?"
#define URL_UPDATE_USER_PUSH_INFO   @"http://bf.bet007.com/phone/PushSet.aspx?"
#define URL_GET_PLAYER_LIST         @"http://bf.bet007.com/phone/ScheduleDetail.aspx?"
  
#define SEGMENT_SEP             @"$$"
#define RECORD_SEP              @"!"
#define FIELD_SEP               @"^"

enum{

    ERROR_INCORRECT_RESPONSE_DATA   = 60001
};

#define NETWORK_TIMEOUT 30

@implementation FootballNetworkRequest

+ (CommonNetworkOutput*)sendRequest:(NSString*)baseURL
                constructURLHandler:(ConstructURLBlock)constructURLHandler
                    responseHandler:(FootballNetworkResponseBlock)responseHandler
                             output:(CommonNetworkOutput*)output
{    
    
    
    
    NSURL* url = nil;    
    if (constructURLHandler != NULL)
        url = [NSURL URLWithString:[constructURLHandler(baseURL) stringByURLEncode]];
    else
        url = [NSURL URLWithString:baseURL];        
    
    if (url == nil){
        output.resultCode = ERROR_CLIENT_URL_NULL;
        return output;
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setAllowCompressedResponse:YES];
    [request setTimeOutSeconds:NETWORK_TIMEOUT];
    
#ifdef DEBUG    
    int startTime = time(0);
    NSLog(@"[SEND] URL=%@", [url description]);    
#endif
    
    [request startSynchronous];
    //    BOOL *dataWasCompressed = [request isResponseCompressed]; // Was the response gzip compressed?
    //    NSData *compressedResponse = [request rawResponseData]; // Compressed data    
    //    NSData *uncompressedData = [request responseData]; // Uncompressed data
    
    NSError *error = [request error];
    int statusCode = [request responseStatusCode];
    
#ifdef DEBUG    
    NSLog(@"[RECV] : status=%d, error=%@", [request responseStatusCode], [error description]);
#endif    
    
    if (error != nil){
        output.resultCode = ERROR_NETWORK;
    }
    else if (statusCode != 200){
        output.resultCode = statusCode;
    }
    else{
        NSString *text = [request responseString];
        
#ifdef DEBUG
        int endTime = time(0);
        NSLog(@"[RECV] data (len=%d bytes, latency=%d seconds, raw=%d bytes, real=%d bytes)", 
              [text length], (endTime - startTime),
              [[request rawResponseData] length], [[request responseData] length]);
#endif         
        
        output.textData = text;
        if ([text length] > 0){
            
            NSMutableArray* resultSegArray = [[NSMutableArray alloc] init];
            
            NSArray* array = [output.textData componentsSeparatedByString:SEGMENT_SEP];
            int count = [array count];
            for (int i=0; i<count; i++){

                NSMutableArray* resultRecordArray = [[NSMutableArray alloc] init];
                
                NSString* records = [array objectAtIndex:i];
                NSArray*  recordArray = [self parseRecord:records];
                int recordCount = [recordArray count];
                for (int j=0; j<recordCount; j++){
                    NSString* fields = [recordArray objectAtIndex:j];
                    NSArray* fieldArray = [self parseField:fields];
                    if (fieldArray != nil){
                        [resultRecordArray addObject:fieldArray];
                    }
                }
                
                [resultSegArray addObject:resultRecordArray];
                [resultRecordArray release];
            }
            
            output.arrayData = resultSegArray;
            [resultSegArray release];
        }
        
#ifdef DEBUG
        NSLog(@"[RECV] data : %@", text);
#endif            
                    
        responseHandler(text, output);       
        return output;
        
    }
    
    return output;
}

+ (NSArray*)parseSegment:(NSString*)data
{
    if ([data length] > 0)
        return [data componentsSeparatedByString:SEGMENT_SEP];
    else
        return nil;
}

+ (NSArray*)parseRecord:(NSString*)data
{
    if ([data length] > 0)
        return [data componentsSeparatedByString:RECORD_SEP];
    else
        return nil;
}

+ (NSArray*)parseField:(NSString*)data
{
    if ([data length] > 0)
        return [data componentsSeparatedByString:FIELD_SEP];
    else
        return nil;
}


+ (CommonNetworkOutput*)getRealtimeMatch:(int)lang scoreType:(int)scoreType
{
    
    
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        str = [str stringByAddQueryParameter:@"lang"
                                       intValue:lang];
        
        str = [str stringByAddQueryParameter:@"type"
                                    intValue:scoreType];

        return str;
    };
    
    FootballNetworkResponseBlock responseHandler = ^(NSString *textData, CommonNetworkOutput *output) {    
        if ([output.arrayData count] != REALTIME_MATCH_SEGMENT){
            output.resultCode = ERROR_INCORRECT_RESPONSE_DATA;
        }
        return;
    }; 
    
    return [FootballNetworkRequest sendRequest:URL_GET_REALTIME_MATCH
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
}

+ (CommonNetworkOutput*)getRealtimeScore
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];                
        return str;
    };
    
    FootballNetworkResponseBlock responseHandler = ^(NSString *textData, CommonNetworkOutput *output) {    
        return;
    }; 
        
    return [FootballNetworkRequest sendRequest:URL_GET_REALTIME_SCORE
                           constructURLHandler:constructURLHandler
                               responseHandler:responseHandler
                                        output:output];    
}    

+ (CommonNetworkOutput*)getMatchDetail:(int)lang matchId:(NSString *)matchId
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        str = [str stringByAddQueryParameter:@"lang"
                                    intValue:lang];
        
        str = [str stringByAddQueryParameter:@"ID" value:matchId];
        return str;
    };
    
    FootballNetworkResponseBlock responseHandler = ^(NSString *textData, CommonNetworkOutput *output) {    
        if ([output.arrayData count] != MATCH_EVENT_SEGMENT){
            NSLog(@"<getMatchDetail> but segment not enough");
            output.resultCode = ERROR_INCORRECT_RESPONSE_DATA;
        }
        return;
    }; 
    
    return [FootballNetworkRequest sendRequest:URL_GET_MATCH_DETAIL
                           constructURLHandler:constructURLHandler
                               responseHandler:responseHandler
                                        output:output];
}


+ (CommonNetworkOutput*)getMatchDetailHeader:(NSString *)matchId;
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];        

        
        str = [str stringByAddQueryParameter:@"ID" value:matchId];
        return str;
    };
    
    FootballNetworkResponseBlock responseHandler = ^(NSString *textData, CommonNetworkOutput *output) {    
        if ([output.arrayData count] != MATCH_DETAIIL_HEADER_SEGMENT){
            NSLog(@"<getMatchDetail> but segment not enough");
            output.resultCode = ERROR_INCORRECT_RESPONSE_DATA;
        }
        return;
    }; 
    
    return [FootballNetworkRequest sendRequest:URL_GET_MATCH_DETAIL_HEADER
                           constructURLHandler:constructURLHandler
                               responseHandler:responseHandler
                                        output:output];
}

+ (CommonNetworkOutput*)getRegisterUserId:(int)registerType
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];
        
        str = [str stringByAddQueryParameter:@"kind" intValue:registerType];
        
        return str;
    };
    
    FootballNetworkResponseBlock responseHandler = ^(NSString *textData, CommonNetworkOutput *output) {
        
        return;
    };
    
    return [FootballNetworkRequest sendRequest:URL_GET_REGISTER_USER_ID
                           constructURLHandler:constructURLHandler
                               responseHandler:responseHandler
                                        output:output];
}

+ (CommonNetworkOutput*)updateUserPushInfo:(int)userId pushType:(int)pushType
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];
        
        str = [str stringByAddQueryParameter:@"UserID" intValue:userId];
        
        str = [str stringByAddQueryParameter:@"Type" intValue:pushType];
        
        return str;
    };
    
    FootballNetworkResponseBlock responseHandler = ^(NSString *textData, CommonNetworkOutput *output) {
        if (textData != nil && textData.length > 0){
            output.resultCode = [textData intValue];
        }
        return;
    };
    
    return [FootballNetworkRequest sendRequest:URL_UPDATE_USER_PUSH_INFO
                           constructURLHandler:constructURLHandler
                               responseHandler:responseHandler
                                        output:output];
}

+ (CommonNetworkOutput*)getPlayerList:(NSString *)matchId lanaguage:(int)language
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL)  {
        
        //set input parameters
        NSString* str = [NSString stringWithString:baseURL];
        
        str = [str stringByAddQueryParameter:@"ID" value:matchId];
        
        str = [str stringByAddQueryParameter:@"lang" intValue:language];
        
        return str;
    };
    
    FootballNetworkResponseBlock responseHandler = ^(NSString *textData, CommonNetworkOutput *output) {
        
        return;
    };
    
    return [FootballNetworkRequest sendRequest:URL_GET_PLAYER_LIST
                           constructURLHandler:constructURLHandler
                               responseHandler:responseHandler
                                        output:output];
}


@end
