//
//  DataUtils.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataUtils : NSObject {
    
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

/*
 类型序号对应依次为
 string[] txt ={"先开球", "第一个角球", "第一张黄牌", "射门次数", "射正次数", "犯规次数", "角球次数", "角球次数(加时)", "任意球次数", "越位次数", "乌龙球数", "黄牌数", "黄牌数(加时)", "红牌数", "控球时间", "头球", "救球", "守门员出击", "丟球", "成功抢断", "阻截", "长传", "短传", "助攻", "成功传中", "第一个换人", "最后换人", "第一个越位", "最后越位", "换人数", "最后角球", "最后黄牌", "换人数(加时)", "越位次数(加时)", "红牌数(加时)"};  
*/

/*
 比赛事件
事件类型1、入球 2、红牌  3、黄牌   7、点球  8、乌龙  9、两黄变红
*/

@end
