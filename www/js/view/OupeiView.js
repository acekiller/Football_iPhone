
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

    this.oupeiCompanyPanel = new Ext.Panel({            
        id : 'oupeiCompanyPanel',
//        tpl : oupeiCompanyTemplate,
		tpl : oupeiCompanyTemplate,
        margin: '0 0 0 0',
        align: 'left'
    });	        	       

    this.oupeiStatPanel = new Ext.Panel({            
        id : 'oupeiStatPanel',
        tpl : oupeiStatTemplate,
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
        items: [this.oupeiStatPanel,
                this.oupeiCompanyPanel]            
    });	
}

OupeiView.prototype = {
	constructor : OupeiView,
	updateView : function(manager) {
		this.oupeiCompanyPanel.update(manager.dataArray);
		this.oupeiStatPanel.update(manager.stat);
	}
};
