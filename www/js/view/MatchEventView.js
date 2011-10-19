
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

function MatchDetailView(){

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

	// init template	
	var eventTemplate = Ext.XTemplate.from("event-template", helperFunctions);
	var statTemplate = Ext.XTemplate.from("stat-template", helperFunctions);
	
	this.eventPanel = new Ext.Panel({	    
	    id : 'eventPanel',
	    tpl : eventTemplate,	
	    margin: '20 10 20 0',
	    align: 'left'
	});
	
	this.statPanel = new Ext.Panel({
	    id : 'statPanel',
	    tpl : statTemplate
	});	
	
	this.mainPanel = new Ext.Panel({	
	    fullscreen: true,
	    layout: {
	        type: 'vbox',
	        align: 'stretch'
	    },
	    scroll : 'vertical',
	    items: [this.eventPanel, this.statPanel]            
	});
	
}

MatchDetailView.prototype = {
	constructor : MatchDetailView
};


