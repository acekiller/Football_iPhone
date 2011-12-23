//
//  DataUtils.h
//  FootballScore
//
//  Created by qqn_pipi on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Match.h"

#define LANG_MANDARIN   0
#define LANG_CANTON     1

@interface DataUtils : NSObject {
    
}

+ (NSString*)toChuPanString:(NSNumber*)chupanNSValue;

+ (NSString*)toMatchStatusString:(NSInteger)intValue;

+ (NSString*)toDaxiaoPanKouString:(NSNumber*)panKou;

/*
 类型序号对应依次为
 string[] txt ={"先开球", "第一个角球", "第一张黄牌", "射门次数", "射正次数", "犯规次数", "角球次数", "角球次数(加时)", "任意球次数", "越位次数", "乌龙球数", "黄牌数", "黄牌数(加时)", "红牌数", "控球时间", "头球", "救球", "守门员出击", "丟球", "成功抢断", "阻截", "长传", "短传", "助攻", "成功传中", "第一个换人", "最后换人", "第一个越位", "最后越位", "换人数", "最后角球", "最后黄牌", "换人数(加时)", "越位次数(加时)", "红牌数(加时)"};  
*/

/*
 比赛事件
事件类型1、入球 2、红牌  3、黄牌   7、点球  8、乌龙  9、两黄变红
*/

@end
