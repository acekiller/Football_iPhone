//
//  ScoreIndexTitleCell.m
//  FootballScore
//
//  Created by  on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ScoreIndexTitleCell.h"

@implementation ScoreIndexTitleCell

+ (ScoreIndexTitleCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ScoreIndexTitleCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ScoreIndexTitleCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((ScoreIndexTitleCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (ScoreIndexTitleCell*)[topLevelObjects objectAtIndex:0];
}

+ (NSString*)getCellIdentifier
{
    return @"ScoreIndexTitleCell";
}

+ (CGFloat)getCellHeight
{
    return 26.0f;
}
@end
