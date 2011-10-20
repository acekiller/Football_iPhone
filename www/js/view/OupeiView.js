
function OupeiView(){
	
	 var helperFunctions = {};

    var oupeiCompanyTemplate = Ext.XTemplate.from("oupei-company-template", helperFunctions);
    var oupeiStatTemplate = Ext.XTemplate.from("oupei-stat-template", helperFunctions);

	var template = new Ext.XTemplate('<table border=1 cellpadding=0 cellspacing = 0>',
            '<tr><td>序号</td><td width=90 >姓名</td></tr>',
            '<tpl for=".">',
            '<tr><td>{name}</td><td>{chupanWin}</td></tr>',
            '</tpl>',
            '</table>');

    this.companyPanel = new Ext.Panel({            
        id : 'companyPanel',
//        tpl : oupeiCompanyTemplate,
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
