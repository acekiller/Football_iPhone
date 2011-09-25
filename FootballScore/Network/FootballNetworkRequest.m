//
//  FootballNetworkRequest.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FootballNetworkRequest.h"
#import "StringUtil.h"

#define URL_GET_REALTIME_MATCH      @"http://bf.bet007.com/phone/schedule.aspx?"


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
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    if (request == nil){
        output.resultCode = ERROR_CLIENT_REQUEST_NULL;
        return output;
    }
    
#ifdef DEBUG    
    NSLog(@"[SEND] URL=%@", [request description]);    
#endif
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
#ifdef DEBUG    
    NSLog(@"[RECV] : status=%d, error=%@", [response statusCode], [error description]);
#endif    
    
    if (response == nil){
        output.resultCode = ERROR_NETWORK;
    }
    else if (response.statusCode != 200){
        output.resultCode = response.statusCode;
    }
    else{
        output.resultCode = 0;  // success
        if (data != nil){
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            output.textData = text;
            
#ifdef DEBUG
            NSLog(@"[RECV] data : %@", text);
#endif            
                        
            responseHandler(text, output);       
            [text release];
            return output;
        }         
        
    }
    
    return output;
}


+ (CommonNetworkOutput*)getRealtimeMatch:(int)lang
{
    CommonNetworkOutput* output = [[[CommonNetworkOutput alloc] init] autorelease];
    
    ConstructURLBlock constructURLHandler = ^NSString *(NSString *baseURL) {
        
        // set input parameters
        NSString* str = [NSString stringWithString:baseURL];        
        str = [str stringByAddQueryParameter:@"lang"
                                       intValue:lang];
        
        return str;
    };
    
    FootballNetworkResponseBlock responseHandler = ^(NSString *textData, CommonNetworkOutput *output) {        
        return;
    }; 
    
    return [FootballNetworkRequest sendRequest:URL_GET_REALTIME_MATCH
                     constructURLHandler:constructURLHandler
                         responseHandler:responseHandler
                                  output:output];
}

@end
