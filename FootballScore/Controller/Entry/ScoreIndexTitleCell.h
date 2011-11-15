//
//  ScoreIndexTitleCell.h
//  FootballScore
//
//  Created by  on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPTableViewCell.h"

@interface ScoreIndexTitleCell : PPTableViewCell{
    
}

+ (ScoreIndexTitleCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

@end
