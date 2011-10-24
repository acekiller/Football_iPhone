
function YapeiDetailView(){
	
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
			
			var result = year + "/" + month + "/" + day + " " + hour + ":" + minute;
			return result;			
		}
		
	};

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

