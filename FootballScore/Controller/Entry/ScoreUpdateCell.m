//
//  ScoreUpdateCell.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ScoreUpdateCell.h"
#import "ScoreUpdate.h"
#import "DataUtils.h"
#import "TimeUtils.h"
@implementation ScoreUpdateCell
@synthesize leagueName;
@synthesize startTime;
@synthesize matchState;
@synthesize homeTeam;
@synthesize awayTeam;
@synthesize homeTeamEvent;
@synthesize awayTeamEvent;
@synthesize matchScore;

+ (ScoreUpdateCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ScoreUpdateCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ScoreUpdateCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((ScoreUpdateCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (ScoreUpdateCell*)[topLevelObjects objectAtIndex:0];
}

+ (NSString*)getCellIdentifier
{
    return @"ScoreUpdateCell";
}

+ (CGFloat)getCellHeight
{
    return 48.0f;
}


- (void)setCellInfo:(ScoreUpdate *)scoreUpdate
{
    self.matchState.text =  [DataUtils toMatchStatusString:[scoreUpdate state] language:1];
    self.startTime.text = dateToChineseStringByFormat([scoreUpdate startTime], @"hh:mm");
    self.leagueName.text = [scoreUpdate leagueName];
    self.homeTeam.text = [scoreUpdate homeTeamName];
    self.awayTeam.text = [scoreUpdate awayTeamName];
    self.matchScore.text = [NSString stringWithFormat:@"%@ : %@",
                            [scoreUpdate homeTeamScore],[scoreUpdate awayTeamScore]];
    
    //TO DO set red and yellow card, to show ball.
}

- (void)dealloc {
    [leagueName release];
    [startTime release];
    [matchState release];
    [homeTeam release];
    [awayTeam release];
    [homeTeamEvent release];
    [awayTeamEvent release];
    [matchScore release];
    [super dealloc];
}
@end
