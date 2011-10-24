
function OverunderView(){
	
	 var helperFunctions = {};

    var overunderCompanyTemplate = Ext.XTemplate.from("overunder-company-template", helperFunctions);

    this.companyPanel = new Ext.Panel({            
        id : 'companyPanel',
        tpl : overunderCompanyTemplate,
        margin: '20 10 20 0',
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

OverunderView.prototype = {
	constructor : OverunderView,
	updateView : function(manager) {
		this.companyPanel.update(manager.dataArray);
	}
};
