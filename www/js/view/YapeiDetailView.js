function YapeiDetailView(type){
	
	this.type = type;

	var helperFunctions = {
		pankouString : function(string)
	    {			
	        return Goal2GoalCn(string);	    
	    },
		
		pankouDateString : function(str){

			if (str == null || str.length < 12){
				return str;				
			}
						
			var year = str.substring(0, 4);
			var month = str.substring(4, 6);
			var day = str.substring(6, 8);
			var hour = str.substring(8, 10);
			var minute = str.substring(10, 12);
			
			var result = month + "/" + day + " " + hour + ":" + minute;
			return result;			
		},
		
		getSelectCompanyClass : function(selectedCompanyId, currentId){
			console.log("call getSelectCompanyclass");
			if (selectedCompanyId == currentId)
				return "ac_Select";
			else
				return "ac_bg";
		}
		
	};
	
    var companyTemplate = Ext.XTemplate.from("odds-detail-company-template", helperFunctions);
	var oddsTemplate = Ext.XTemplate.from("odds-detail-template", helperFunctions);

	this.selectCompanyId = null;
	this.manager = null;

    this.detailCompanyPanel = new Ext.Panel({            
//        id : 'detailCompanyPanel' + type.toString(),
        tpl : companyTemplate,
        margin: '0 0 0 0',
		flex: 93/320,
//        align: 'top',
        scroll : 'vertical'
    });	        	       
		
	this.oddsPanel = new Ext.Panel({
//        id : 'oddsPanel' + type.toString(),
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
        items: [this.detailCompanyPanel, this.oddsPanel]            
    });	
}

YapeiDetailView.prototype = {
	constructor : YapeiDetailView,
	
	updateCompany : function(manager){
		this.manager = manager;
		this.detailCompanyPanel.update(manager);
	},
	
	updateCompanyOdds : function(manager, companyId){

		if (companyId == null || companyId.length <= 0) {
			console.log("update company odds by id but id is null or length <= 0");
			return;
		}			
		
		this.manager = manager;
		manager.selectCompanyId = companyId;
		
		manager.requestOddsChangeFromServer(companyId);		
		this.oddsPanel.update(manager.oddsChangeList);
		this.detailCompanyPanel.update(manager);
	},
	
	updateView : function(manager, companyId){
		this.manager = manager;
		manager.selectCompanyId = companyId;
		
		this.oddsPanel.update(manager.oddsChangeList);
		this.detailCompanyPanel.update(manager);		
	},
	
	test : function(){
		alert("test");
	}
	
};