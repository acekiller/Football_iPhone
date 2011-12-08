
function RangqiuView(type){
	
	this.type = type;

	 var helperFunctions = {
	 };

    var rangqiuTemplate = Ext.XTemplate.from("rangqiu-template", helperFunctions);

    this.rangqiuPanel = new Ext.Panel({            
        tpl : rangqiuTemplate,
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
        items: [this.rangqiuPanel]            
    });	
	
	this.manager = null;
}

RangqiuView.prototype = {
	constructor : RangqiuView,
	updateView : function(manager) {
		this.manager = manager;
		this.rangqiuPanel.update(manager);
	}
};


