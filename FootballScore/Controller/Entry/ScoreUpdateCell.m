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
    
   // settingButton.titleLabel.text = message;  用这种方法不行阿 ？？？？调用方法更加好阿 。
    
    NSLog(@"This is a :%@",message);
    [settingButton setBackgroundImage:image  forState:UIControlStateDisabled ] ;
    [settingButton setTitle:message forState:UIControlStateDisabled];
    [settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
}


- (void)setCellInfo:(ScoreUpdate *)scoreUpdate 
{ 

    
    //更新时间 ，颜色
    self.matchState.text =  scoreUpdate.updateMinute;
    self.matchState.textColor= [UIColor redColor];
    
    //比分颜色
    self.matchScore.textColor= [UIColor greenColor];
    
    self.startTime.text = dateToChineseStringByFormat([scoreUpdate startTime], @"HH:mm");
    self.startTime.textColor=[UIColor grayColor];
    
    
    
    self.leagueName.text = [scoreUpdate leagueName];
    self.leagueName.textColor = [[LeagueManager defaultManager] getLeagueColorById:[[scoreUpdate match]leagueId]];
    NSLog(@"leagueId = %@",scoreUpdate.match.leagueId);
   
    
    self.homeTeam.text = [scoreUpdate homeTeamName];
    self.awayTeam.text =  [scoreUpdate awayTeamName];


    
    //set event type
    NSInteger type = scoreUpdate.scoreUpdateType;
    
    UIImage *eventImage = nil;
    
    if (type < HOMETEAMRED) {
        //score type
        //TO DO set score event image 
        eventImage = [UIImage imageNamed:@"ls_ball.png"];
        self.scoreTypeName.text = FNS(@"比分");
        
        
        [self setTeamEventButton:type message:FNS(@"进球") image:[UIImage imageNamed:@"ls_img1.png"]];
            
    
        
        self.matchScore.text = [NSString stringWithFormat:@"%@ : %@",
                                [scoreUpdate homeTeamScore],[scoreUpdate awayTeamScore]];
        
    }else if(type < HOMETEAMYELLOW)
    {
        // red card type
        //TO DO set red card event image 
        eventImage = [UIImage imageNamed:@"redcard.png"];
        self.scoreTypeName.text = FNS(@"比数");
        [self setTeamEventButton:type-HOMETEAMRED  message:FNS(@"红牌") image :[UIImage imageNamed:@"ls_img2.png"]];
        self.matchScore.text = [NSString stringWithFormat:@"%@ : %@",
                                [scoreUpdate homeTeamRedcard],[scoreUpdate awayTeamRedcard]];
        
    }else if(type < TYPECOUNT)
    {
        //yellow card type
        //TO DO set yellow card event image 
        eventImage = [UIImage imageNamed:@"yellowcard.png"];
        self.scoreTypeName.text = FNS(@"比数");
        [self setTeamEventButton:type-HOMETEAMYELLOW  message:FNS(@"黄牌") image:[UIImage  imageNamed:@"ls_img3.png"]];
        
        
        self.matchScore.text = [NSString stringWithFormat:@"%@ : %@",
                                [scoreUpdate homeTeamYellowcard],[scoreUpdate awayTeamYellowcard]];
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
