//
//  ScoreIndexCell.m
//  FootballScore
//
//  Created by Orange on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ScoreIndexCell.h"

@implementation ScoreIndexCell

+ (ScoreIndexCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ScoreIndexCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ScoreIndexCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((ScoreIndexCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (ScoreIndexCell*)[topLevelObjects objectAtIndex:0];
}

+ (NSString*)getCellIdentifier
{
    return @"ScoreIndexCell";
}

+ (CGFloat)getCellHeight
{
    return 48.0f;
}

@end
