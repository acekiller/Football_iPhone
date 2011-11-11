//
//  DataUtils.m
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DataUtils.h"
#import "LocaleConstants.h"

@implementation DataUtils

+ (NSString*)toChuPanString:(NSNumber*)chupanNSValue
{

    NSArray *GoalCnMandarin = [NSArray arrayWithObjects:@"平手",@"平手/半球",@"半球",@"半球/一球",@"一球",@"一球/球半",@"球半",@"球半/两球",@"两球",@"两球/两球半",@"两球半",@"两球半/三球",@"三球",@"三球/三球半",@"三球半",@"三球半/四球",@"四球",@"四球/四球半",@"四球半",@"四球半/五球",@"五球",@"五球/五球半",@"五球半",@"五球半/六球",@"六球",@"六球/六球半",@"六球半",@"六球半/七球",@"七球",@"七球/七球半",@"七球半",@"七球半/八球",@"八球",@"八球/八球半",@"八球半",@"八球半/九球",@"九球",@"九球/九球半",@"九球半",@"九球半/十球",@"十球",nil];
    
//    NSArray *GoalCnConton = [NSArray arrayWithObjects:@"平手",@"平手/半球",@"半球",@"半球/一球",@"一球",@"一球/球半",@"球半",@"球半/兩球",@"兩球",@"兩球/兩球半",@"兩球半",@"兩球半/三球",@"三球",@"三球/三球半",@"三球半",@"三球半/四球",@"四球",@"四球/四球半",@"四球半",@"四球半/五球",@"五球",@"五球/五球半",@"五球半",@"五球半/六球",@"六球",@"六球/六球半",@"六球半",@"六球半/七球",@"七球",@"七球/七球半",@"七球半",@"七球半/八球",@"八球",@"八球/八球半",@"八球半",@"八球半/九球",@"九球",@"九球/九球半",@"九球半",@"九球半/十球",@"十球",nil];
    
    NSString *Goal2Cn = [NSString stringWithFormat:@""];
    double chupanDoubleValue = [chupanNSValue doubleValue];
    int Goal2CnIndex = (int)(abs(chupanDoubleValue*4));
    
    if(chupanNSValue == nil || Goal2CnIndex >= [GoalCnMandarin count]){
        return Goal2Cn;
    }

    Goal2Cn =  FNS([GoalCnMandarin objectAtIndex:Goal2CnIndex]);
  
    
    if(chupanDoubleValue >= 0){
        return Goal2Cn;
    }
    else{
        return [NSString stringWithFormat:@"受%@",Goal2Cn];
    }
    /*
     盘口数字转文字，供参考，需要支持各种语言
     private string[] GoalCn ={"平手","平手/半球","半球","半球/一球","一球","一球/球半","球半","球半/两球","两球","两球/两球半","两球半","两球半/三球","三球","三球/三球半","三球半","三球半/四球","四球","四球/四球半","四球半","四球半/五球","五球","五球/五球半","五球半","五球半/六球","六球","六球/六球半","六球半","六球半/七球","七球","七球/七球半","七球半","七球半/八球","八球","八球/八球半","八球半","八球半/九球","九球","九球/九球半","九球半","九球半/十球","十球"};
     public string Goal2GoalCn(float goal) {  	//数字盘口转汉汉字
     string Goal2GoalCn = "";
     try{
     if (Convert.IsDBNull(goal)) {Goal2GoalCn = "";	}
     else if(goal >= 0){Goal2GoalCn = GoalCn[Convert.ToInt32(goal * 4)];}
     else	{Goal2GoalCn = "受" + GoalCn[Math.Abs(Convert.ToInt32(goal * 4))];}
     }
     catch{Goal2GoalCn=goal.ToString();}
     return Goal2GoalCn;
     } 
     */

}

+ (NSString*)toMatchStatusString:(NSInteger)intValue
{
    switch (intValue) {
//        case MATCH_STATUS_NOT_STARTED:
//            return FNS(@"未开");
//            break;
//        case MATCH_STATUS_FIRST_HALF:
//            return FNS(@"上半场");
//        case MATCH_STATUS_MIDDLE:
//            return FNS(@"中场");
//            break;
//        case MATCH_STATUS_SECOND_HALF:
//            return FNS(@"下半场");
//        case MATCH_STATUS_TBD:
//            return FNS(@"待定");
//            break;
//        case MATCH_STATUS_KILL:
//            return FNS(@"腰斩");
//        case MATCH_STATUS_PAUSE:
//            return FNS(@"中断");
//            break;
//        case MATCH_STATUS_POSTPONE:
//            return FNS(@"推迟");
//        case MATCH_STATUS_FINISH:
//            return FNS(@"完场");
//            break;
//        case MATCH_STATUS_CANCEL:
//            return FNS(@"取消");
//        default:
//            return nil;
            case MATCH_STATUS_FIRST_HALF:
            return fns(@"上半场");
            case MATCH_STATUS_SECOND_HALF:
            return fns(@"下半场");
            case MATCH_STATUS_MIDDLE:
                return FNS(@"中场");
            case MATCH_STATUS_FINISH:
                return FNS(@"完场");
            case MATCH_STATUS_TBD:
            return FNS(@"完场");
                 MATCH_STATUS_KILL:
            return FNS(@"完场");
                 MATCH_STATUS_PAUSE:
            return FNS(@"完场");
                 MATCH_STATUS_POSTPONE:
            return FNS(@"完场");
                 MATCH_STATUS_CANCEL:
            return FNS(@"完场");
                 MATCH_STATUS_NOT_STARTED:
                 return @"未开赛";
            default:
                return FNS(@"未开赛");
    }
}

@end
