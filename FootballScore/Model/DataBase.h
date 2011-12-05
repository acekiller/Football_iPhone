//
//  DataBase.h
//  FootballScore
//
//  Created by  on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBContinent : NSObject
{
    NSString *continentId;
    NSString *continentName;
}

@property(nonatomic, retain) NSString *continentId;
@property(nonatomic, retain) NSString *continentName;

@end


@interface DBCountry : NSObject
{
    NSString *countryId;
    NSString *countryName;
    NSString *continentId;
}
@property(nonatomic, retain) NSString *countryId;
@property(nonatomic, retain) NSString *countryName;
@property(nonatomic, retain) NSString *continentId;
@end

@interface DBLeague : NSObject

@end
