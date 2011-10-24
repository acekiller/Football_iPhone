
MatchDetailApp = new Ext.Application({

//Ext.regApplication({
    
    name: 'MatchDetailApp',
    
    isLaunched: 0,
    
    launch: function() {
        		
        console.log("match javascript launched");
        
        // define all views here
        MatchDetailApp.matchDetailView = null;
        
        // set launched flag
        MatchDetailApp.isLaunched = 1;
        
//		测试比赛事件
//      testUpdateMatchDetail();
		testDisplayMatchEventLocally();
		
//		测试比赛事件
//      testUpdateOupeiDetail();

//		测试亚赔
//		testUpdateYapeiDetail();

//		测试亚赔变化
//      testYapeiOddsDetail();


//		测试大小
//      testUpdateOverunderDetail();

//		测试阵容
//		testUpdateLineup();

//      testShowYapeiView();
        
        
    }

});

function isAppLaunched(){
	return MatchDetailApp.isLaunched;
}

function setCurrentView(panel){
	MatchDetailApp.viewport = panel;
}

function getMatchDetailView(){	
	return new MatchDetailView(); 
}

function displayMatchEvent(reload, matchId, lang, data){
		
	if (reload){
		if (data != undefined){
			if (matchDetailManager.readData(data) == false){
				return false;
			}
		}	
		else if (matchDetailManager.requestDataFromServer(matchId, lang) == false){
			return false;
		}
	}
	
	MatchDetailApp.matchDetailView = getMatchDetailView();
	MatchDetailApp.matchDetailView.updateView(matchDetailManager);
	setCurrentView(MatchDetailApp.matchDetailView.mainPanel);	
	return true;
}

function updateMatchDetail(inputString){

	if (MatchDetailApp.matchDetailView == null || MatchDetailApp.matchDetailView == undefined){
		MatchDetailApp.matchDetailView = new MatchDetailView();
	}
	
	MatchDetailApp.viewport = MatchDetailApp.matchDetailView.mainPanel;		
	
	matchDetailManager.readData(inputString);	
	MatchDetailApp.matchDetailView.eventPanel.update(matchDetailManager.eventArray);
	MatchDetailApp.matchDetailView.statPanel.update(matchDetailManager.statArray);
}

function showYapeiOddsDetail(betCompanyId){

	if (MatchDetailApp == null || MatchDetailApp == undefined){
		return;
	}

	// create view
	if (MatchDetailApp.yapeiDetailView == null || MatchDetailApp.yapeiDetailView == undefined){
		MatchDetailApp.yapeiDetailView = new YapeiDetailView();
	}
	MatchDetailApp.viewport = MatchDetailApp.yapeiDetailView.mainPanel;
			
	// request data from server and update view
	MatchDetailApp.yapeiDetailView.updateCompanyOdds(betCompanyId);
}

function updateOupeiDetail(oupeiData){
	
//	alert("updateOupeiDetail 1");
	
	MatchDetailApp.oupeiView = new OupeiView();	
	MatchDetailApp.viewport = MatchDetailApp.oupeiView.mainPanel;		

//	alert("updateOupeiDetail 2");
	
	oupeiManager.readData(oupeiData);
	
//	alert("updateOupeiDetail 3 " + oupeiData);

	MatchDetailApp.oupeiView.statPanel.update(oupeiManager.stat);	
	MatchDetailApp.oupeiView.companyPanel.update(oupeiManager.dataArray);
	
//	alert("updateOupeiDetail 4 " + oupeiManager.stat);

}

function showYapeiView(matchId){
	loadYapeiView(yapeiManager, matchId);
}

function updateYapeiDetail(yapeiData){
	MatchDetailApp.yapeiView = new YapeiView();
	MatchDetailApp.viewport = MatchDetailApp.yapeiView.mainPanel;
	
	yapeiManager.readData(yapeiData);
	
	MatchDetailApp.yapeiView.companyPanel.update(yapeiManager.dataArray);
}

function updateOverunderDetail(overunderData){
	MatchDetailApp.overunderView = new OverunderView();
	MatchDetailApp.viewport = MatchDetailApp.overunderView.mainPanel;
	
	overunderManager.readData(overunderData);
	
	MatchDetailApp.overunderView.companyPanel.update(overunderManager.dataArray);
}

function updateLineup(lineupData){
	MatchDetailApp.lineupView = new LineupView();
	MatchDetailApp.viewport = MatchDetailApp.lineupView.mainPanel;
	
	lineupManager.readData(lineupData);
	
	MatchDetailApp.lineupView.homeLineupPanel.update(lineupManager.data.homeLineup[0]);
	MatchDetailApp.lineupView.homeReservePanel.update(lineupManager.data.homeReserve[0]);
	MatchDetailApp.lineupView.awayLineupPanel.update(lineupManager.data.awayLineup[0]);
	MatchDetailApp.lineupView.awayReservePanel.update(lineupManager.data.awayReserve[0]);
}

function changebg(index) {
	 var len = yapeiCompanyManager.betCompanyList.length;
	 for(var i=1;i<=len;i++) {
	 	if (i==index){
			continue;
		} else {
			anchorTag = document.getElementById("com"+i);
	 		anchorTag.className= "ac_bg";
		}
	 } 
	 anchorTag = document.getElementById("com"+index);
	 anchorTag.className= "ac_Select";
}
