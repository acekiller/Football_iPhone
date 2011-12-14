//
//  CupMatchType.h
//  FootballScore
//
//  Created by Orange on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    MATCH_TYPE_ID = 0,
    MATCH_TYPE_NAME,
    IS_CURRENT
};

@interface CupMatchType : NSObject {
    NSString* matchTypeName;
    NSString* isCurrentType;
    NSString* matchTypeId;
}
@property (nonatomic, retain) NSString* matchTypeName;
@property (nonatomic, retain) NSString* isCurrentType;
@property (nonatomic, retain) NSString* matchTypeId;

- (id)initWithId:(NSString*)idValue name:(NSString*)name isCurrentType:(NSString*)isCurrent;
@end
