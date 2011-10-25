
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
        
        // setup loading view
        loadingView = new Ext.LoadMask(Ext.getBody(), {msg:"加载中..."});
        
//		测试比赛事件
//		testDisplayMatchEventLocally();
		
//		测试欧赔
//        testDisplayOupeiDetail();

//		测试亚赔
//		testDisplayYapeiDetail();

//		测试亚赔变化
//      testYapeiOddsDetail();

//		测试大小
//      testDisplayOverunder();
		testDisplayOverunderRemote();

//		测试阵容
		testDisplayLineup();
//		testDisplayLineupRemote();

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

function getOupeiView(){
	return new OupeiView();
}

function getYapeiView(type){
	return new YapeiView(type);
}

function getLineupView() {
	return new LineupView();
}

function getOverunderView() {
	return new YapeiView();	// the same as yapei view
}

function getYapeiDetailView(type) {
	return new YapeiDetailView(type);
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

function displayYapeiOddsDetail(type, betCompanyId){

	var betManager = null;
	if (type == TYPE_YAPEI){
		betManager = yapeiCompanyManager;
	}
	else{
		betManager = overunderCompanyManager;
	}
	
	MatchDetailApp.yapeiDetailView = getYapeiDetailView(type);
			
	MatchDetailApp.yapeiDetailView.updateCompanyOdds(betManager, betCompanyId); // TODO
	setCurrentView(MatchDetailApp.yapeiDetailView.mainPanel);
	return true;
}

//Deprecated
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
	MatchDetailApp.oupeiView.updateView(oupeiManager);
	setCurrentView(MatchDetailApp.oupeiView.mainPanel);	
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
	MatchDetailApp.yapeiView = getYapeiView(TYPE_YAPEI);	
	MatchDetailApp.yapeiView.updateView(yapeiManager);
	setCurrentView(MatchDetailApp.yapeiView.mainPanel);	
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
	
	MatchDetailApp.overunderView = getOverunderView(TYPE_OVERUNDER);
	MatchDetailApp.overunderView.updateView(overunderManager);
	setCurrentView(MatchDetailApp.overunderView.mainPanel);
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
	MatchDetailApp.lineupView.updateView(lineupManager);
	setCurrentView(MatchDetailApp.lineupView.mainPanel);	
	return true;	
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
