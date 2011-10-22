
function YapeiView(){
	
	 var helperFunctions = {};

    var yapeiCompanyTemplate = Ext.XTemplate.from("yapei-company-template", helperFunctions);

    this.companyPanel = new Ext.Panel({            
        id : 'companyPanel',
        tpl : yapeiCompanyTemplate,
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
