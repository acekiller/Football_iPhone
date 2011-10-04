

function getEventString(type){
	switch (type){
	case 1:
		return "入球";
	case 2:
		return "红牌";
	case 3:
		return "黄牌";
	case 7:
		return "点球";
	case 8:
		return "乌龙";
	case 9:
		return "两黄变红";
	}
}

MatchDetailApp = new Ext.Application({

//Ext.regApplication({
    
    name: 'MatchDetailApp',
    
    launch: function() {
	
		// 主客队标志，1：主队事件，0：客队事件
		// 事件类型1、入球 2、红牌  3、黄牌   7、点球  8、乌龙  9、两黄变红

        var event = [];

        var stat = [];        
        
        var statArray = [
            "先开球", "第一个角球", "第一张黄牌", "射门次数", "射正次数", "犯规次数", "角球次数", "角球次数(加时)", 
            "任意球次数", "越位次数", "乌龙球数", "黄牌数", "黄牌数(加时)", "红牌数", "控球时间", "头球", "救球", 
            "守门员出击", "丟球", "成功抢断", "阻截", "长传", "短传", "助攻", "成功传中", "第一个换人", "最后换人", 
            "第一个越位", "最后越位", "换人数", "最后角球", "最后黄牌", "换人数(加时)", "越位次数(加时)", "红牌数(加时)"
            ];

        var helperFunctions = {
        
            isScoreEvent : function(type){
                return (type == 1); // 是否是进球
            },

            isCardEvent : function(type){
                return (type == 2); // 是否是红黄牌
            },

            eventString : function(type){
            	switch (type){
            	case 1:
            		return "入球";
            	case 2:
            		return "红牌";
            	case 3:
            		return "黄牌";
            	case 7:
            		return "点球";
            	case 8:
            		return "乌龙";
            	case 9:
            		return "两黄变红";
            	}
            	return "";
            },

            statString : function(type)
            {
                return ""+statArray[type];
            
            }

        };

        var eventInfo = Ext.XTemplate.from("event-template", helperFunctions);
        var statInfo = Ext.XTemplate.from("stat-template", helperFunctions);

        MatchDetailApp.eventPanel = new Ext.Panel({
            
            id : 'eventPanel',
            tpl : eventInfo,

            margin: '20 10 20 0',
            align: 'left'
        });
        
        MatchDetailApp.statPanel = new Ext.Panel({
            id : 'statPanel',
            tpl : statInfo
        });


        MatchDetailApp.viewport = new Ext.Panel({

            fullscreen: true,
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            scroll : 'vertical',
            items: [MatchDetailApp.eventPanel, MatchDetailApp.statPanel]            
        });

    }

});


function updateMatchDetail(event, stat){

	MatchDetailApp.eventPanel.update(eval(event));
	MatchDetailApp.statPanel.update(eval(stat));

}
