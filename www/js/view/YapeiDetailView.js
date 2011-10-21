
function YapeiDetailView(){
	
	var helperFunctions = {};

    var companyTemplate = Ext.XTemplate.from("odds-detail-company-template", helperFunctions);
	var oddsTemplate = Ext.XTemplate.from("odds-detail-template", helperFunctions);

    this.companyPanel = new Ext.Panel({            
        id : 'companyPanel',
        tpl : companyTemplate,
        margin: '0 0 0 0',
		flex: 1,
//        align: 'top',
        scroll : 'vertical'
    });	        	       
	
	this.oddsPanel = new Ext.Panel({
        id : 'oddsPanel',
        tpl : oddsTemplate,
        margin: '0 0 0 0',
		flex: 2,
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
		this.companyPanel.update(yapeiCompanyManager.betCompanyList);
	},
	
	updateCompanyOdds : function(companyId){

		if (companyId == null || companyId.length <= 0) {
			console.log("update company odds by id but id is null or length <= 0");
			return;
		}			
		
		//alert("updateCompanyOdds, companyId=" + companyId);
		yapeiCompanyManager.requestOddsChangeFromServer(companyId);		
		this.oddsPanel.update(yapeiCompanyManager.oddsChangeList);
	},
	
	test : function(){
		alert("test");
	}
	
};

