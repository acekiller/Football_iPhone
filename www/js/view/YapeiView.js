
function YapeiView(){
	
	 var helperFunctions = {};

    var yapeiCompanyTemplate = Ext.XTemplate.from("yapei-company-template", helperFunctions);

    this.companyPanel = new Ext.Panel({            
        id : 'companyPanel',
        tpl : yapeiCompanyTemplate,
        margin: '0 0 0 0',
        align: 'left'
    });	        	       


    this.mainPanel = new Ext.Panel({

        fullscreen: true,
        layout: {
            type: 'vbox',
            align: 'stretch'
        },
        scroll : 'vertical',
        items: [this.companyPanel]            
    });	
}

YapeiView.prototype = {
	constructor : YapeiView	
};

function loadYapeiView(manager, matchId){	
	var yapeiView = new YapeiView();
	MatchDetailApp.viewport = yapeiView.mainPanel;	
	manager.requestDataFromServer(matchId);	
	yapeiView.companyPanel.update(manager.dataArray);
}

