//
//  ScoreUpdateCell.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@protocol ScoreUpdateCellDelegate <NSObject>

-(void) endClickDeleteButton:(NSIndexPath *)indexPath;

@end

@class ScoreUpdate;
@interface ScoreUpdateCell : PPTableViewCell {
    
    UILabel *leagueName;
    UILabel *startTime;
    UILabel *matchState;
    UILabel *homeTeam;
    UILabel *awayTeam;
    UIButton *homeTeamEvent;
    UIButton *awayTeamEvent;
    UILabel *matchScore;
    UILabel *scoreTypeName;
    UIImageView *eventStateImage;
    UIButton *deleteButton;
    id<ScoreUpdateCellDelegate> scoreUpdateCellDelegate;
}
@property (nonatomic, retain) IBOutlet UILabel *leagueName;
@property (nonatomic, retain) IBOutlet UILabel *startTime;
@property (nonatomic, retain) IBOutlet UILabel *matchState;
@property (nonatomic, retain) IBOutlet UILabel *homeTeam;
@property (nonatomic, retain) IBOutlet UILabel *awayTeam;
@property (nonatomic, retain) IBOutlet UIButton *homeTeamEvent;
@property (nonatomic, retain) IBOutlet UIButton *awayTeamEvent;
@property (nonatomic, retain) IBOutlet UILabel *matchScore;
@property (nonatomic, retain) IBOutlet UILabel *scoreTypeName;
@property (nonatomic, retain) IBOutlet UIImageView *eventStateImage;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, assign) id<ScoreUpdateCellDelegate> scoreUpdateCellDelegate;
- (IBAction)clickDeleteButton:(id)sender;

+ (ScoreUpdateCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
- (void)setCellInfo:(ScoreUpdate *)scoreUpdate;
@end
