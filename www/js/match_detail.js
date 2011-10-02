

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

MatchDetailApp = Ext.regApplication({

//Ext.regApplication({
    
    name: 'MatchDetailApp',
    
    launch: function() {
	
		// 主客队标志，1：主队事件，0：客队事件
		// 事件类型1、入球 2、红牌  3、黄牌   7、点球  8、乌龙  9、两黄变红

        var event = [{ minutes:15, player:'进球', type:1 }, { minutes:20, player:'黄牌', type:2 }];

        var stat = [{ type:0, awayValue:0, homeValue:0},
                    { type:0, awayValue:'0', homeValue:0}];        
        
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
            }
        };

        var eventInfo = Ext.XTemplate.from("event-template", helperFunctions);

        var statInfo = new Ext.XTemplate(
            '<h2>统计数据</h2>',
            '<tpl for=".">',
                '<div>{type} {homeValue} {awayValue}</div>',
            '</tpl>'
        );

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

//        alert(eventString(1));
        
//        MatchDetailApp.eventPanel.update(event);
//        statPanel.update(stat);
        
//        updateMatchDetail();
        
//        console.log('launch');
//        alert("launch finish");
    }

});

function updateMatchDetail(event, stat){

//	alert("New Update Match Detail Done");

	MatchDetailApp.eventPanel.update(eval(event));
	MatchDetailApp.statPanel.update(eval(stat));
	
//	MatchDetailApp.statPanel.update(eval("[{type:3, homeValue:'8', awayValue:'3'}, {type:4, homeValue:'1', awayValue:'2'}, {type:5, homeValue:'5', awayValue:'11'}, {type:6, homeValue:'10', awayValue:'3'}, {type:9, homeValue:'1', awayValue:'3'}, {type:11, homeValue:'3', awayValue:'3'}, {type:16, homeValue:'1', awayValue:'1'}]"));
}
