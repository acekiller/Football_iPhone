
function YapeiView(){
	
	 var helperFunctions = {};

    var oupeiCompanyTemplate = Ext.XTemplate.from("yapei-company-template", helperFunctions);

    this.companyPanel = new Ext.Panel({            
        id : 'companyPanel',
        tpl : oupeiCompanyTemplate,
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

YapeiView.prototype = {
	constructor : YapeiView
};
