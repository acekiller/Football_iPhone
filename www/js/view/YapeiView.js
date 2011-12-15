
function YapeiView(type){
	
	this.type = type;

	 var helperFunctions = {
	 };

    var yapeiCompanyTemplate = Ext.XTemplate.from("yapei-company-template", helperFunctions);
	var noYapeiTemplate = Ext.XTemplate.from("noYapei-template", helperFunctions);

    this.companyPanel = new Ext.Panel({            
        tpl : yapeiCompanyTemplate,
        margin: '0 0 0 0',
        align: 'left'
    });	        	       

    this.noYapeiPanel = new Ext.Panel({
	    id : '',
	    tpl : noYapeiTemplate
	});	

    this.mainPanel = new Ext.Panel({

        fullscreen: true,
        layout: {
            type: 'vbox',
            align: 'stretch'
        },
        scroll : 'vertical',
        items: [this.companyPanel,this.noYapeiPanel]            
    });	
	
	this.manager = null;
}

YapeiView.prototype = {
	constructor : YapeiView,
	updateView : function(manager) {
		this.manager = manager;
		
		if (manager.dataArray == null || manager.dataArray.length == 0) {
			this.companyPanel.hide();
			this.noYapeiPanel.show();
			this.noYapeiPanel.update();
			
		}
		else{
			this.noYapeiPanel.hide();
			this.companyPanel.show();
			this.companyPanel.update(manager);
		}
	}
};


