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
#import "LocaleConstants.h"
#import "MatchManager.h"
#import "LeagueManager.h"
#import "Match.h"
#import "ColorManager.h"

@implementation ScoreUpdateCell
@synthesize leagueName;
@synthesize startTime;
@synthesize matchState;
@synthesize homeTeam;
@synthesize awayTeam;
@synthesize homeTeamEvent;
@synthesize awayTeamEvent;
@synthesize matchScore;
@synthesize scoreTypeName;
@synthesize eventStateImage;
@synthesize deleteButton;
@synthesize scoreUpdateCellDelegate;

- (IBAction)clickDeleteButton:(id)sender {
    if (self.scoreUpdateCellDelegate && [self.scoreUpdateCellDelegate respondsToSelector:@selector(endClickDeleteButton:)]) {
        [self.scoreUpdateCellDelegate endClickDeleteButton:self.indexPath];
    }
}

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

//buttonId = 0 for homeTeam, other for awayTeam;
- (void)setTeamEventButton:(NSInteger)buttonId message:(NSString *)message image:(UIImage *)image
{
    UIButton *settingButton = buttonId ? awayTeamEvent : homeTeamEvent;
    UIButton *hiddenButton = (!buttonId) ? awayTeamEvent : homeTeamEvent;
    [settingButton setHidden:NO];
    [hiddenButton setHidden:YES];
        
    NSLog(@"This is a :%@",message);
    [settingButton setBackgroundImage:image  forState:UIControlStateDisabled ] ;
    [settingButton setTitle:message forState:UIControlStateDisabled];
    [settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
}


- (void)setCellInfo:(ScoreUpdate *)scoreUpdate 
{ 

    
    //更新时间 ，颜色
    self.matchState.text =  scoreUpdate.updateMinute;
    self.matchState.textColor= [ColorManager matchStateTextColor];
    
   
    //开赛时间
    self.startTime.text = dateToChineseStringByFormat([scoreUpdate startTime], @"HH:mm");
    self.startTime.textColor=[ ColorManager startTimeTextColor ];
    
    
    //联赛类型
    self.leagueName.text = [scoreUpdate leagueName];
    self.leagueName.textColor = [[LeagueManager defaultManager] getLeagueColorById:[[scoreUpdate match]leagueId]];
    
    
    //队名
    self.homeTeam.text = [scoreUpdate homeTeamName];
    self.awayTeam.text =  [scoreUpdate awayTeamName];
    self.homeTeam.textColor = [ColorManager TeamTextColor];
    self.awayTeam.textColor = [ColorManager TeamTextColor];

   

    //set event type
    NSInteger type = scoreUpdate.scoreUpdateType;
    UIImage *eventImage = nil;
    
    
    //比分
    self.matchScore.text = [NSString stringWithFormat:@"%d : %d", 
                            [scoreUpdate homeTeamDataCount],[scoreUpdate awayTeamDataCount]];
            self.matchScore.textColor=  [ColorManager MatchScoreTextColor];
    
    
    if (type < HOMETEAMRED) {
        //score type
        //TO DO set score event image 
        eventImage = [UIImage imageNamed:@"ls_ball@2x.png"];
        self.scoreTypeName.text = FNS(@"比分");
        self.scoreTypeName.textColor=[ColorManager  TeamTextColor];
        [self setTeamEventButton:type message:FNS(@"进球") image:[UIImage imageNamed:@"ls_img1.png"]];
        
    }else if(type < HOMETEAMYELLOW)
    {
        // red card type
        //TO DO set red card event image 
        eventImage = [UIImage imageNamed:@"redcard@2x.png"];
        self.scoreTypeName.text = FNS(@"比数");
        self.scoreTypeName.textColor=[ColorManager  TeamTextColor];
        [self setTeamEventButton:type-HOMETEAMRED  message:FNS(@"红牌") image :[UIImage imageNamed:@"ls_img2.png"]];
        
    }else if(type < TYPECOUNT)
    {
        //yellow card type
        //TO DO set yellow card event image 
        eventImage = [UIImage imageNamed:@"yellowcard@2x.png"];
        self.scoreTypeName.text = FNS(@"比数");
        self.scoreTypeName.textColor=[ColorManager  TeamTextColor];
        [self setTeamEventButton:type-HOMETEAMYELLOW  message:FNS(@"黄牌") image:[UIImage  imageNamed:@"ls_img3.png"]];
    }

        [self.eventStateImage setImage:eventImage];
    
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
    [scoreTypeName release];
    [eventStateImage release];
    [deleteButton release];
    [super dealloc];
}
@end
