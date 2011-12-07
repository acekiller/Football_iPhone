DepositoryApp = new Ext.Application({

//Ext.regApplication({
    
    name: 'MatchDetailApp',
    
    isLaunched: 0,
    
    launch: function() {
        		
        console.log("repository javascript launched");
        
        // define all views here
       
        
        // set launched flag
        MatchDetailApp.isLaunched = 1;

//		测试联赛积分
//		testDisplayJifenLocally();
        testDisplayJifenRemote();
    }

});

function hideView(view){
	console.log("hide view " + view);
	if (view != null && view.mainPanel != undefined){
		view.mainPanel.hide();
	}
}

function hideAllView(){
	
}

function setCurrentView(panel){	
	hideAllView();
	DepositoryApp.viewport = panel;
	panel.show();	
}

function getjifenView()
{
	if (DepositoryApp.jifenView != null)
		return DepositoryApp.jifenView;
	else
		return new JifenView();
}


function displayJifen(reload, leagueId, season, lang, data){
	if (reload) {
		if (data != undefined) {
			if (jifenManager.readData(data) == false) {
				return false;
			}
		} else if (jifenManager.requestDataFromServer(leagueId, season, lang) == false){
			return false;
		}
	}
	DepositoryApp.jifenView = getjifenView();	
	setCurrentView(DepositoryApp.jifenView.mainPanel);	
	DepositoryApp.jifenView.updateView(jifenManager);
	return true;	
}