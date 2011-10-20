



MatchDetailApp = new Ext.Application({

//Ext.regApplication({
    
    name: 'MatchDetailApp',
    
    isLaunched: 0,
    
    launch: function() {
        		
        console.log("match javascript launched");
//      testReadData();
//      testUpdateMatchDetail();
//      testUpdateOupeiDetail();
        
        MatchDetailApp.isLaunched = 1;
    }

});

function isAppLaunched(){
	return MatchDetailApp.isLaunched;
}

function testUpdateMatchDetail(){
	var data = "0^1^3^D.卡里奴!1^1^42^F.蒙迪路!0^1^60^施薩 迪加度$$3^8^6!4^5^4!5^5^3!6^3^3!9^0^3!11^1^2!16^2^4";
	updateMatchDetail(data);
}

function updateMatchDetail(inputString){

	MatchDetailApp.matchDetailView = new MatchDetailView();	
	MatchDetailApp.viewport = MatchDetailApp.matchDetailView.mainPanel;		
	
	matchDetailManager.readData(inputString);	
	MatchDetailApp.matchDetailView.eventPanel.update(matchDetailManager.eventArray);
	MatchDetailApp.matchDetailView.statPanel.update(matchDetailManager.statArray);
}

function testUpdateOupeiDetail(){
	var data = "盈禾^2580078^1.70^3.30^4.35^1.65^3.45^4.50!韦德^2574267^1.615^3.50^4.75^1.667^3.60^5.50!Bet365^2573522^1.61^3.40^5.00^1.65^4.20^4.60!易胜^2579536^1.65^3.40^4.75^1.62^3.40^5.00!ＳＢ^2580075^1.70^3.30^4.35^1.65^3.30^4.50!利记^2579424^1.70^3.40^4.20^1.64^3.35^4.80!永利高^2580277^1.70^3.30^4.35^1.46^3.30^4.35!10BET^2579343^1.61^3.47^4.92^1.54^3.58^5.26!金宝博^2580170^1.70^3.30^4.35^1.61^3.55^4.65!12bet/大发^2579540^1.67^3.45^4.32^1.64^3.37^4.68!明陞^2579541^1.67^3.45^4.32^1.64^3.37^4.68";
	updateOupeiDetail(data);
}

function updateOupeiDetail(oupeiData){
		
	MatchDetailApp.oupeiView = new OupeiView();	
	MatchDetailApp.viewport = MatchDetailApp.oupeiView.mainPanel;		

	oupeiManager.readData(oupeiData);
	
	MatchDetailApp.oupeiView.statPanel.update(oupeiManager.stat);	
	MatchDetailApp.oupeiView.companyPanel.update(oupeiManager.dataArray);
}
