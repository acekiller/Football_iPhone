//
//  ScoreIndexCell.h
//  FootballScore
//
//  Created by Orange on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@interface ScoreIndexCell : PPTableViewCell

+ (ScoreIndexCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
@property (retain, nonatomic) IBOutlet UILabel *matchName;

@end
