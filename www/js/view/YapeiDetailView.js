
function YapeiDetailView(){
	
	var helperFunctions = {};

    var companyTemplate = Ext.XTemplate.from("odds-detail-company-template", helperFunctions);
	var oddsTemplate = Ext.XTemplate.from("odds-detail-template", helperFunctions);

	this.selectCompanyId = null;

    this.companyPanel = new Ext.Panel({            
        id : 'companyPanel',
        tpl : companyTemplate,
        margin: '0 0 0 0',
		flex: 93/320,
//        align: 'top',
        scroll : 'vertical'
    });	        	       
	
	this.oddsPanel = new Ext.Panel({
        id : 'oddsPanel',
        tpl : oddsTemplate,
        margin: '0 0 0 0',
		flex: (320-93)/320,
//        align: 'right',		
        scroll : 'vertical'
	});

    this.mainPanel = new Ext.Panel({

        fullscreen: true,
        layout: {
            type: 'hbox',
            align: 'stretch'
        },
        items: [this.companyPanel, this.oddsPanel]            
    });	
}

YapeiDetailView.prototype = {
	constructor : YapeiDetailView,
	
	updateCompany : function(){
		this.companyPanel.update(yapeiCompanyManager);
	},
	
	updateCompanyOdds : function(companyId){

		if (companyId == null || companyId.length <= 0) {
			console.log("update company odds by id but id is null or length <= 0");
			return;
		}			
		
		yapeiCompanyManager.selectCompanyId = companyId;
		
//		alert("updateCompanyOdds, companyId=" + companyId);
		yapeiCompanyManager.requestOddsChangeFromServer(companyId);		
		this.oddsPanel.update(yapeiCompanyManager.oddsChangeList);
		this.companyPanel.update(yapeiCompanyManager);
	},
	
	test : function(){
		alert("test");
	}
	
};

