
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

var statArray = [
    "先开球", 	"第一个角球", "第一张黄牌", "射门次数", "射正次数", 	"犯规次数", "角球次数", "角球次数(加时)", "任意球次数", "越位次数", 	
	"乌龙球数", 	"黄牌数",  	"黄牌数(加时)", "红牌数", "控球时间", 	"头球",    "救球",	 "守门员出击", 	"丟球", 		"成功抢断", 
	"阻截", 		"长传", 		"短传", 		  "助攻",   "成功传中", 	"第一个换人","最后换人", "第一个越位", 	"最后越位", 	"换人数", 
	"最后角球", 	"最后黄牌", 	"换人数(加时)", "越位次数(加时)", "红牌数(加时)"
    ];

function MatchDetailView(){

	
	var helperFunctions = {
	
	    isScoreEvent : function(type){
	        return (parseInt(type) == 1); // 是否是进球
	    },
	
	    isCardEvent : function(type){
	        return (parseInt(type) == 2); // 是否是红黄牌
	    },
	
	    eventString : function(type){
	    	switch (type){
	    	case "1":
	    		return "进球";
	    	case "2":
	    		return "红牌";
	    	case "3":
	    		return "黄牌";
	    	case "7":
	    		return "点球";
	    	case "8":
	    		return "乌龙";
	    	case "9":
	    		return "两黄变红";
	    	}
	    	return "";
	    },
	
		eventImage : function(type){
			console.log("call eventImage, type = " + type);
	    	switch (parseInt(type)){
	    	case 1:{
				return "images/5.png";
			}
	    	case 2:
	    		return "images/redcard.png";
	    	case 3:
	    		return "images/yellowcard@2x.png";
	    	case 7:
	    		return "images/3.png";
	    	case 8:
	    		return "images/s.png";
	    	case 9:
	    		return "images/4.png";
	    	}
	    	return "";
	    },
	
		isHome : function(homeAwayFlag){
			return (homeAwayFlag == "1");
		},
		
		isAway : function(homeAwayFlag){
			return (homeAwayFlag == "0");
		},		
	
		homeAwayClass : function(homeAwayFlag){
			console.log("call homeAwayClass, homeAwayFlag = "+homeAwayFlag);
			switch (parseInt(homeAwayFlag)){
				case 1:
					return "dl_home";
				case 0:
					return "dl_visitors";
			}
			return "";
		},
	
	    statString : function(type)
	    {
			console.log("stat string, type = "+type);
	        return statArray[parseInt(type)];	    
	    },
		
		displayStat : function(type, value) {
//			console.log("display event stat: type = "+type+", value="+value);
			if (type == "0" && value == "*") {  	//先开球					
				return "<img src=images/dwq.png />";
			}
			else if (type == "2" && value == "*") { //第一张黄牌
//				console.log("return <img src=images/yellowcard@2x.png />");
				return "<img src=images/yellowcard.png />";
			}
			else if (type == "25" && value == "*") { //第一个换人
				return "<img src=images/2.png />";
			}
			else if (value == "*") {         
				return "<img src=images/dwq.png />";
				/*       
				if (type == "3" || type == "4" || type == "5" || type == "6" 
				 || type == "7" || type == "8" || type == "9" || type == "10"
				 || type == "11"|| type == "12"|| type == "13"|| type == "14"
				 || type == "15"|| type == "17"|| type == "18"|| type == "19"
				 || type == "20"|| type == "21"|| type == "22"|| type == "23"
				 || type == "24"|| type == "27"|| type == "29"|| type == "32"
				 || type == "33" || type == "34") {
				 	return "<img src=images/dwq.png />";
				 } else {
				 	return value;
				 }
				 */
			}
			return value;
		}
	
	};

	// init template	
	var eventTemplate = Ext.XTemplate.from("event-template", helperFunctions);
	var statTemplate = Ext.XTemplate.from("stat-template", helperFunctions);
	var noEventTemplate = Ext.XTemplate.from("noEvent-template", helperFunctions);
	
	this.eventPanel = new Ext.Panel({	    
	    id : 'eventPanel',
	    tpl : eventTemplate,	
	    margin: '0 0 0 0',
	    align: 'left'
	});
	
	this.statPanel = new Ext.Panel({
	    id : 'statPanel',
	    tpl : statTemplate
	});	
	this.noEventPanel = new Ext.Panel({
	    id : 'noEventPanel',
	    tpl : noEventTemplate
	});	
	
	this.mainPanel = new Ext.Panel({	
	    fullscreen: true,
	    layout: {
	        type: 'vbox',
	        align: 'top'
	    },
		//tpl : '<div class="noEventdata"><span>暂无比赛事件相关数据</span></div>',
	    scroll : 'vertical',
	    items: [this.eventPanel, this.statPanel,this.noEventPanel]            
	});
	
}

MatchDetailView.prototype = {
	constructor : MatchDetailView,
	updateView : function(manager){
		
		if (manager.eventArray == null || manager.eventArray.length == 0) {
			this.noEventPanel.show();
			this.noEventPanel.update();
		}
		else{
			this.noEventPanel.hide();
			this.eventPanel.update(manager.eventArray);

		}
		
		if (manager.statArray == null || manager.statArray.length == 0) {
			this.statPanel.hide();
		}
		else {
			this.statPanel.show();
			this.statPanel.update(manager.statArray);
		}
	}
};


