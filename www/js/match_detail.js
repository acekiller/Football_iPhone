



MatchDetailApp = new Ext.Application({

//Ext.regApplication({
    
    name: 'MatchDetailApp',
    
    isLaunched: 0,
    
    launch: function() {
        		
        console.log("match javascript launched");
//      testReadData();
//      testUpdateMatchDetail();
//      testUpdateOupeiDetail();
		testUpdateYapeiDetail();
//        testUpdateOverunderDetail();
        MatchDetailApp.isLaunched = 1;
		Goal2GoalCn(0.75);
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

function testUpdateYapeiDetail(){
	var data = "ＳＢ^2490884^1.02^-0.25^0.80^0.90^-0.5^0.92!Bet365^2497415^1.10^-0.25^0.775^0.95^-0.5^0.90!立博^2502862^1.08^-0.25^0.72^1.08^-0.25^0.72!韦德^2496650^1.10^-0.25^0.75^1.16^-0.25^0.69!易胜^2504231^0.72^-0.5^1.08^0.87^-0.5^0.93!明陞^2497396^1.11^-0.25^0.74^0.97^-0.5^0.87!澳彩^2497282^1.02^-0.25^0.80^1.12^-0.25^0.70!10BET^2496512^1.06^-0.25^0.76^0.90^-0.5^0.90!金宝博^2497406^1.04^-0.25^0.80^0.91^-0.5^0.93!12bet/大发^2479187^1.11^-0.25^0.74^0.97^-0.5^0.87!利记^2478851^0.94^-0.25^0.90^0.94^-0.5^0.90!永利高^2496090^0.99^-0.25^0.77^0.87^-0.5^0.89!盈禾^2496075^1.03^-0.25^0.82^0.91^-0.5^0.94";
	updateYapeiDetail(data);
}

function updateYapeiDetail(yapeiData){
	MatchDetailApp.yapeiView = new YapeiView();
	MatchDetailApp.viewport = MatchDetailApp.yapeiView.mainPanel;
	
	yapeiManager.readData(yapeiData);
	
	MatchDetailApp.yapeiView.companyPanel.update(yapeiManager.dataArray);
}

function testUpdateOverunderDetail(){
	var data = "ＳＢ^1978021^1.00^2.5^0.80^0.78^2.5^1.02!Bet365^1984678^1.025^2.5^0.825^0.875^2.5^0.975!立博^1990224^1.01^2.5^0.79^0.94^2.5^0.86!韦德^1983921^0.909^2.5^0.80^0.80^2.5^0.909!易胜^1991610^0.95^2.5^0.75^0.90^2.5^0.80!明陞^1984659^1.02^2.5^0.80^0.89^2.5^0.93!澳彩^1984554^0.95^2.5^0.75^0.95^2.5^0.75!10BET^1983752^1.00^2.5^0.78^0.85^2.5^0.90!金宝博^1984669^1.02^2.5^0.80^0.79^2.5^1.03!12bet/大发^1966126^1.02^2.5^0.80^0.89^2.5^0.93!利记^1965788^1.02^2.5^0.80^0.88^2.5^0.94!永利高^1983327^0.97^2.5^0.77^0.785^2.5^0.955!盈禾^1983312^1.02^2.5^0.80^0.80^2.5^1.02";
	updateOverunderDetail(data);
}

function updateOverunderDetail(overunderData){
	MatchDetailApp.overunderView = new OverunderView();
	MatchDetailApp.viewport = MatchDetailApp.overunderView.mainPanel;
	
	overunderManager.readData(overunderData);
	
	MatchDetailApp.overunderView.companyPanel.update(overunderManager.dataArray);
}
