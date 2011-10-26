
function YapeiView(type){
	
	this.type = type;

	 var helperFunctions = {
	 };

    var yapeiCompanyTemplate = Ext.XTemplate.from("yapei-company-template", helperFunctions);

    this.companyPanel = new Ext.Panel({            
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
	
	this.manager = null;
}

YapeiView.prototype = {
	constructor : YapeiView,
	updateView : function(manager) {
		this.manager = manager;
		this.companyPanel.update(manager);
	}
};


