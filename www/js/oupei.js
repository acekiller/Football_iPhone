


// define model
//var model = Ext.define('Oupei', {
//    extend: 'Ext.data.Model',
//    fields: [
//        { name: 'name', type: 'string' },
//        { name: 'chupanWin', type: 'float' },
//        { name: 'chupanDraw', type: 'float' },
//        { name: 'chupanLost', type: 'float' },
//        { name: 'jishiWin', type: 'float' },
//        { name: 'jishiDraw', type: 'float' },
//        { name: 'jishiLost', type: 'float' }
//    ]
//});

var json = { name : '12bet.com', chupanWin : 1.29, chupanDraw : 5, chupanLost : 8.01, jishiWin : 1.16, jishiDraw : 7.78, jishiLost : 16.84};

var jsonString = "[{ name : '12bet.com', chupanWin : 1.29, chupanDraw : 5, chupanLost : 8.01, jishiWin : 1.16, jishiDraw : 7.78, jishiLost : 16.84}, { name : 'mark.com', chupanWin : 1.29, chupanDraw : 5, chupanLost : 8.01, jishiWin : 1.16, jishiDraw : 7.78, jishiLost : 16.84}, ]";

// define one test record
//var oupeiRecord1 = Ext.create('Oupei', {
//	name : '12bet.com',
//	chupanWin : 1.29,
//	chupanDraw : 5,
//	chupanLost : 8.01,
//	jishiWin : 1.16,
//	jishiDraw : 7.78,
//	jishiLost : 16.84
//});

// define data store
//var store = Ext.create('Ext.data.Store', {
//	model : 'Oupei',
//	data : [ oupeiRecord1 ]	
//});

OupeiApp = new Ext.Application({
	    
    name: 'OupeiApp',    
    launch: function() {
		
	 var helperFunctions = {};

        var oupeiCompanyTemplate = Ext.XTemplate.from("oupei-company-template", helperFunctions);
        var oupeiStatTemplate = Ext.XTemplate.from("oupei-stat-template", helperFunctions);

        OupeiApp.companyPanel = new Ext.Panel({            
            id : 'companyPanel',
            tpl : oupeiCompanyTemplate,
            margin: '20 10 20 0',
            align: 'left'
        });	        	       

        OupeiApp.statPanel = new Ext.Panel({            
            id : 'statPanel',
            tpl : oupeiStatTemplate,
            margin: '20 10 20 0',
            align: 'left'
        });	        	       

        OupeiApp.viewport = new Ext.Panel({

            fullscreen: true,
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            scroll : 'vertical',
            items: [OupeiApp.statPanel,
                    OupeiApp.companyPanel]            
        });
        
    
        
//        console.log("test");
                
        
//        console.log(oupeiRecord1.get('name'));
        console.log(eval(jsonString));
        console.log(OupeiApp.companyPanel.id);
        
//        OupeiApp.companyPanel.update(eval(jsonString));
//        updateOupeiDetail("");
        
//        OupeiApp.companyPanel.update(eval(json));
        
//        OupeiApp.companyPanel.setHtml(json);
        
//        updateOupeiDetail(jsonString);

//        updateOupeiDetail("盈禾^2582152^1.15^6.00^8.80^1.16^6.60^9.00!韦德^2582387^1.143^6.00^13.00^1.167^5.50^13.00!立博^2582486^1.18^6.00^12.00^1.18^6.00^11.00!Bet365^2580244^1.28^4.75^8.00^1.16^6.00^16.00!Interwetten^2582388^1.27^4.30^8.50^1.27^4.30^8.50!ＳＢ^2582148^1.15^6.00^8.80^1.16^6.60^9.00!利记^2582336^1.16^5.60^12.50^1.22^5.20^9.75!永利高^2582218^1.15^6.00^8.80^1.13^6.20^8.70!10BET^2582354^1.17^5.63^12.60^1.19^5.55^10.61!金宝博^2582579^1.18^6.20^8.70^1.18^6.20^8.70!12bet/大发^2583002^1.20^5.50^9.54^1.19^5.56^10.02!明陞^2583001^1.20^5.50^9.54^1.18^5.62^10.57");
        
//        OupeiApp.companyPanel.update([oupeiRecord1]);
    }
});


function updateOupeiDetail(oupeiData){
	
	var string = "盈禾^2580078^1.70^3.30^4.35^1.65^3.45^4.50!韦德^2574267^1.615^3.50^4.75^1.667^3.60^5.50!Bet365^2573522^1.61^3.40^5.00^1.65^4.20^4.60!易胜^2579536^1.65^3.40^4.75^1.62^3.40^5.00!ＳＢ^2580075^1.70^3.30^4.35^1.65^3.30^4.50!利记^2579424^1.70^3.40^4.20^1.64^3.35^4.80!永利高^2580277^1.70^3.30^4.35^1.46^3.30^4.35!10BET^2579343^1.61^3.47^4.92^1.54^3.58^5.26!金宝博^2580170^1.70^3.30^4.35^1.61^3.55^4.65!12bet/大发^2579540^1.67^3.45^4.32^1.64^3.37^4.68!明陞^2579541^1.67^3.45^4.32^1.64^3.37^4.68";
//	alert(oupeiData);
//  var array = parseRequestString(string);
//  console.log(array);
  

	var oupeiArray = oupeiManager.readData(oupeiData);
//	console.log(string);
//	console.log(oupeiArray);
//	console.log(Ext.util.JSON.encode(oupeiArray));
//	var jsonString = Ext.util.JSON.encode(oupeiManager.stat);
	OupeiApp.statPanel.update(oupeiManager.stat);
//	OupeiApp.companyPanel.update(eval(Ext.util.JSON.encode(oupeiManager.dataArray)));
	OupeiApp.companyPanel.update(oupeiManager.dataArray);
}



