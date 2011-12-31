function AnalysisView(){
	
	var helperFunctions = {
		getMonthDayFromDate: function(date) {
			return date.substring(4,6) +"/" + date.substring(6,8);
		},
		
		getYearFromDate: function(subArr) {
			return subArr[0].time.substring(0,4);
		},
		
		formateDate: function(date) {
			return date.substring(2,4) +"/" + date.substring(4,6) +"/" + date.substring(6,8);
		},
		
		getScoreEarn: function(score,scoreAgainst) {
			if(score!="" && scoreAgainst!="") {
				return score-scoreAgainst;
			} else {
				return "";
			}
		},
		
		getGames: function(win,draw,lose) {
			return parseInt(win)+parseInt(draw)+parseInt(lose);
		},
		
		getShortName: function(name) {
			if (name.length > 5) {
				return name.substring(0,5);
			} else {
				return name;
			}
		},
		
		nameColor: function(home,random) {
			if (home == random) {
				return "teamNameGreen";
			}
		},
		
		oddsColor: function(odds) {
			if (odds == "输"){
				return "oddsGreen";
			} else if(odds == "赢") {
				return "oddsRed";
			} else if(odds == "走" ){
				return "oddsBlue";
			}
		}
	};

    var analysisTemplate = Ext.XTemplate.from("analysis-template", helperFunctions);
    
    
    
    this.analysisPanel = new Ext.Panel({
        tpl: analysisTemplate
    });
    
    
    this.mainPanel = new Ext.Panel({
        fullscreen: true,
        layout: {
            type: 'vbox',
            align: 'top'
        },
        scroll: 'vertical',
        items: [this.analysisPanel]
    });
    
}

AnalysisView.prototype = {
    constructor: AnalysisView,
    
    updateView: function(manager){
    
	if (manager.homePointsArray[0].games = "") {
		alert("!!!");
	}
		
    this.analysisPanel.update(manager);
        
    }
};
