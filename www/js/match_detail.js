
MatchDetailApp = new Ext.Application({

//Ext.regApplication({
    
    name: 'MatchDetailApp',
    
    isLaunched: 0,
    
    launch: function() {
        		
        console.log("match javascript launched");
        
        // define all views here
        MatchDetailApp.matchDetailView = null;
        MatchDetailApp.yapeiDetailView = null;
        MatchDetailApp.overunderDetailView = null;
        MatchDetailApp.oupeiView = null;
        MatchDetailApp.yapeiView = null;
        MatchDetailApp.overunderView = null;
        MatchDetailApp.lineupView = null;
        
        // set launched flag
        MatchDetailApp.isLaunched = 1;
        
//		测试比赛事件
//		testDisplayMatchEventLocally();
//        testDisplayMatchEventRemote();
		
//		测试欧赔
//        testDisplayOupeiDetail();
//        testDisplayOupeiDetailRemote();

//		测试亚赔
//        testDisplayYapeiRemote();

//		测试亚赔变化
//        testYapeiOddsDetailLocal();

//		测试大小
//      testDisplayOverunder();
//		testDisplayOverunderRemote();

//		测试阵容
//		testDisplayLineup();
//		testDisplayLineupRemote();

        
//		测试分析
//		testDisplayAnalysisLocal();
		//testDisplayAnalysisRemote();
		//testSep();
    }
});

function isAppLaunched(){
	return MatchDetailApp.isLaunched;
}

function hideView(view){
	console.log("hide view " + view);
	if (view != null && view.mainPanel != undefined){
		view.mainPanel.hide();
	}
}

function hideAllView(){
	hideView(MatchDetailApp.matchDetailView);
	hideView(MatchDetailApp.yapeiDetailView);
	hideView(MatchDetailApp.overunderDetailView);
	hideView(MatchDetailApp.oupeiView);
	hideView(MatchDetailApp.yapeiView);
	hideView(MatchDetailApp.overunderView);
	hideView(MatchDetailApp.lineupView);
	hideView(MatchDetailApp.analysisView);		
}

function setCurrentView(panel){	
	hideAllView();
	MatchDetailApp.viewport = panel;
	panel.show();	
}

function getMatchDetailView(){	
	if (MatchDetailApp.matchDetailView != null)
		return MatchDetailApp.matchDetailView;
	else
		return new MatchDetailView(); 
}

function getOupeiView(){
	if (MatchDetailApp.oupeiView != null)
		return MatchDetailApp.oupeiView;
	else
		return new OupeiView();
}

function getYapeiView(){
	
	if (MatchDetailApp.yapeiView != null)
		return MatchDetailApp.yapeiView;
	else
		return new YapeiView(TYPE_YAPEI);
}

function getLineupView() {
	
	if (MatchDetailApp.lineupView != null)
		return MatchDetailApp.lineupView;
	else
		return new LineupView();
}

function getOverunderView() {
	
	if (MatchDetailApp.overunderView != null)
		return MatchDetailApp.overunderView;
	else
		return new YapeiView(TYPE_OVERUNDER);	// the same as yapei view
}

function getYapeiDetailView(type) {
	
	if (type == TYPE_YAPEI){	
		if (MatchDetailApp.yapeiDetailView != null)
			return MatchDetailApp.yapeiDetailView;
		else
			return new YapeiDetailView(type);
	}
	else{
		if (MatchDetailApp.overunderDetailView != null)
			return MatchDetailApp.overunderDetailView;
		else
			return new YapeiDetailView(type);
	}
}

function getAnalysisView(){
	if (MatchDetailApp.analysisView != null)
		return MatchDetailApp.analysisView;
	else
		return new AnalysisView();
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
	setCurrentView(MatchDetailApp.matchDetailView.mainPanel);	
	MatchDetailApp.matchDetailView.updateView(matchDetailManager);
	return true;
}

function displayYapeiOddsDetail(type, betCompanyId){

	var betManager = null;
	var view = null;
	
	if (type == TYPE_YAPEI){
		betManager = yapeiCompanyManager;
		MatchDetailApp.yapeiDetailView = getYapeiDetailView(type);
		view = MatchDetailApp.yapeiDetailView;
	}
	else{
		betManager = overunderCompanyManager;
		MatchDetailApp.overunderDetailView = getYapeiDetailView(type);
		view = MatchDetailApp.overunderDetailView;
	}
	
	setCurrentView(view.mainPanel);
	view.updateCompanyOdds(betManager, betCompanyId);
	return true;
}

function displayOupeiDetail(reload, matchId, lang, data){
	if (reload) {
		if (data != undefined) {
			if (oupeiManager.readData(data) == false) {
				return false;
			}
		} else if (oupeiManager.requestDataFromServer(matchId, lang) == false){
			return false;
		}
	}
	MatchDetailApp.oupeiView = getOupeiView();	
	setCurrentView(MatchDetailApp.oupeiView.mainPanel);	
	MatchDetailApp.oupeiView.updateView(oupeiManager);
	return true;	
}

function displayYapeiDetail(reload, matchId, lang, data){
	if (reload) {
		if (data != undefined) {
			if (yapeiManager.readData(data) == false) {
				return false;
			}
		} else if (yapeiManager.requestDataFromServer(matchId, lang) == false){
			return false;
		}
	}
	MatchDetailApp.yapeiView = getYapeiView();	
	setCurrentView(MatchDetailApp.yapeiView.mainPanel);	
	MatchDetailApp.yapeiView.updateView(yapeiManager);
	return true;	
}

function displayOverunder(reload, matchId, lang, data) {
	if (reload) {
		if (data != undefined) {
			if (overunderManager.readData(data) == false) {
				return false;
			}
		} else if (overunderManager.requestDataFromServer(matchId, lang) == false) {
				return false;
		}
	}
	
	MatchDetailApp.overunderView = getOverunderView();
	setCurrentView(MatchDetailApp.overunderView.mainPanel);
	MatchDetailApp.overunderView.updateView(overunderManager);
	return true;
}

function displayLineup(reload, matchId, lang, data){
	if (reload) {
		if (data != undefined) {
			if (lineupManager.readData(data) == false) {
				return false;
			}
		} else if (lineupManager.requestDataFromServer(matchId, lang) == false){
			return false;
		}
	}
	MatchDetailApp.lineupView = getLineupView();	
	setCurrentView(MatchDetailApp.lineupView.mainPanel);	
	MatchDetailApp.lineupView.updateView(lineupManager);
	return true;	
}

function displayAnalysis(reload, matchId, homeTeam, awayTeam, lang, data) {
	if (reload) {
		if (data != undefined) {
			if (analysisManager.readData(data, homeTeam, awayTeam) == false) {
				return false;
			}
		} else if (analysisManager.requestDataFromServer(matchId, homeTeam, awayTeam, lang) == false){
			return false;
		}
	}
	MatchDetailApp.analysisView = getAnalysisView();
	setCurrentView(MatchDetailApp.analysisView.mainPanel);
	MatchDetailApp.analysisView.updateView(analysisManager);
	
	pointsAction();
	headtoheadActoin();
	recordsAction();
	near3gamesAction();
	recommendAction();
	
	return true;
}

function getOddsCompanyElementName(index, type){
	return "com"+"-"+index+"-"+type;
}

function changebg(index, type) {
	
	var manager = null;	
	if (type == TYPE_YAPEI)
		manager = yapeiCompanyManager;
	else
		manager = overunderCompanyManager;		
		
	 var len = manager.betCompanyList.length;
	 for(var i=1; i<=len; i++) {
	 	if (i == index){
			continue;
		} else {
			anchorTag = document.getElementById(getOddsCompanyElementName(i, type));
	 		anchorTag.className= "ac_bg";
	 		console.log("set " + i + " to ac_bg");
		}
	 } 
	 anchorTag = document.getElementById(getOddsCompanyElementName(index, type));
	 anchorTag.className= "ac_Select";
	 console.log("set " + index + " to ac_Select");
}
