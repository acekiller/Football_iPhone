//
//  LeagueScheduleController.h
//  FootballScore
//
//  Created by Orange on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PPViewController.h"
@protocol CommonCommandDelegate <NSObject>

- (void)execute;

@end

@interface LeagueScheduleController : PPViewController {
    id<CommonCommandDelegate> pointCommand;
    id<CommonCommandDelegate> scheduleCommand;
    id<CommonCommandDelegate> rangQiuCommand;
    id<CommonCommandDelegate> daxiaoCommand;
    id<CommonCommandDelegate> shooterRankingCommand;
    id<CommonCommandDelegate> seasonCommand;
    id<CommonCommandDelegate> roundCommand;
};

@property (nonatomic, assign) id<CommonCommandDelegate> pointCommand;
@property (nonatomic, assign) id<CommonCommandDelegate> scheduleCommand;
@property (nonatomic, assign) id<CommonCommandDelegate> rangQiuCommand;
@property (nonatomic, assign) id<CommonCommandDelegate> daxiaoCommand;
@property (nonatomic, assign) id<CommonCommandDelegate> shooterRankingCommand;
@property (nonatomic, assign) id<CommonCommandDelegate> seasonCommand;
@property (nonatomic, assign) id<CommonCommandDelegate> roundCommand;
@property (retain, nonatomic) IBOutlet UIButton *pointButton;
@property (retain, nonatomic) IBOutlet UIButton *scheduleButton;
@property (retain, nonatomic) IBOutlet UIButton *rangQiuButton;
@property (retain, nonatomic) IBOutlet UIButton *daxiaoButton;
@property (retain, nonatomic) IBOutlet UIButton *shooterRankingButton;
@property (retain, nonatomic) IBOutlet UIButton *seasonSelectionButton;
@property (retain, nonatomic) IBOutlet UIButton *roundSelectionButton;

- (void)setScoreCommand:(id<CommonCommandDelegate>)point 
               schedule:(id<CommonCommandDelegate>)schedule 
                rangQiu:(id<CommonCommandDelegate>)rangQiu 
                 daxiao:(id<CommonCommandDelegate>)daxiao 
         shooterRanking:(id<CommonCommandDelegate>)shooterRanking 
                 season:(id<CommonCommandDelegate>)season  
                  round:(id<CommonCommandDelegate>)round;

@end


@interface Common_command : NSObject <CommonCommandDelegate>{
@private
    
}
@end