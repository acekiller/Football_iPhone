
function OupeiView(){
	
	 var helperFunctions = {};

    var oupeiCompanyTemplate = Ext.XTemplate.from("oupei-company-template", helperFunctions);
    var oupeiStatTemplate = Ext.XTemplate.from("oupei-stat-template", helperFunctions);

    this.companyPanel = new Ext.Panel({            
        id : 'companyPanel',
        tpl : oupeiCompanyTemplate,
        margin: '20 10 20 0',
        align: 'left'
    });	        	       

    this.statPanel = new Ext.Panel({            
        id : 'statPanel',
        tpl : oupeiStatTemplate,
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
        items: [this.statPanel,
                this.companyPanel]            
    });	
}

OupeiView.prototype = {
	constructor : OupeiView
};
