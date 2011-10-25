//
//  ColorManager.m
//  FootballScore
//
//  Created by Orange on 11-10-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ColorManager.h"

@implementation ColorManager

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (UIColor*)halfScoreColor
{
    return [UIColor colorWithRed:(0x42)/255.0                                           
                           green:(0x95)/255.0                                           
                            blue:(0xdf)/255.0                                          
                           alpha:1.0];
}

+ (UIColor*)leageNameColor
{
    return [UIColor colorWithRed:(0x31)/255.0                                              
                           green:(0x31)/255.0                                               
                            blue:(0x31)/255.0                                              
                           alpha:1.0];
}
+ (UIColor*)startTimeColor
{
    return [UIColor colorWithRed:(0x66)/255.0                                             
                           green:(0x66)/255.0
                            blue:(0x66)/255.0                                              
                           alpha:1.0];
}
+ (UIColor*)onGoTimeColor
{
    return [UIColor colorWithRed:(0xff)/255.0 
                           green:(0x33)/255.0
                            blue:(0x00)/255.0
                           alpha:1.0];
}
+ (UIColor*)onGoScore
{
    return [UIColor colorWithRed:(0x33)/255.0 
                           green:(0x99)/255.0
                            blue:(0x00)/255.0
                           alpha:1.0];
}
+ (UIColor*)finishScoreColor
{
    return [UIColor colorWithRed:(0xff)/255.0 
                           green:(0x00)/255.0
                            blue:(0x00)/255.0
                           alpha:1.0];
}
+ (UIColor*)leagueColor1
{
    return [UIColor colorWithRed:(0x51)/255.0 
                           green:(0x8e)/255.0
                            blue:(0xd2)/255.0
                           alpha:1.0];
}
+ (UIColor*)leagueColor2
{
    return [UIColor colorWithRed:(0xe8)/255.0 
                    green:(0x81)/255.0
                     blue:(0x1a)/255.0
                    alpha:1.0];
}
+ (UIColor*)leagueColor3
{
    return [UIColor colorWithRed:(0x94)/255.0 
                           green:(0x97)/255.0
                            blue:(0x20)/255.0
                           alpha:1.0];
}
+ (UIColor*)leagueColor4
{
    return [UIColor colorWithRed:(0x8f)/255.0 
                           green:(0x6d)/255.0
                            blue:(0xd6)/255.0
                           alpha:1.0];
}
+ (UIColor*)leagueColor5
{
    return [UIColor colorWithRed:(0x53)/255.0 
                           green:(0xac)/255.0
                            blue:(0x98)/255.0
                           alpha:1.0];
}









+ (UIColor*)MatchesNameButtonNotChosenColor{
    
    
    return [UIColor colorWithRed:0x66/255.0 
                           green:0x66/255.0
                            blue:0x66/255.0
                           alpha:1.0];

 
}
+ (UIColor*)ToChooseTheMatchesButtonColor{
    
    return [UIColor colorWithRed:(0x24)/255.0 
                           green:(0x53)/255.0
                            blue:(0x93)/255.0
                           alpha:1.0];
}




//ScoreUpStateCell

+ (UIColor*)matchStateTextColor{

    
    return [UIColor colorWithRed:0xff/255.0 
                           green:0x33/255.0 
                            blue:0x00/255.0 
                           alpha:1];
}
+(UIColor*)startTimeTextColor{

   return [ UIColor colorWithRed:0x66/255.0 
                           green:0x66/255.0 
                            blue:0x66/255.0
                           alpha:1];

}
+(UIColor*)TeamTextColor{
    
    return [UIColor colorWithRed:0x39/255.0
                           green:0x39/255.0 
                            blue:0x39/255.0 
                           alpha:1];

}
+(UIColor*)MatchScoreTextColor{
    
    return [UIColor colorWithRed:0x33/255.0 
                           green:0x99/255.0 
                            blue:0x00/255.0
                            alpha:1];

}

//ScoreUpDateController

+(UIColor*)dateTimeTextColor{
    
     return [UIColor colorWithRed:0x1B/255.0
                            green:0x4A/255.0
                             blue:0x6D/255.0 
                            alpha:1];

}

@end
