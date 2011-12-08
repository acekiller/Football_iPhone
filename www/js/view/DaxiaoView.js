
function DaxiaoView(type){
	
	this.type = type;

	 var helperFunctions = {
	 };

    var daxiaoTemplate = Ext.XTemplate.from("daxiao-template", helperFunctions);

    this.daxiaoPanel = new Ext.Panel({            
        tpl : daxiaoTemplate,
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
        items: [this.daxiaoPanel]            
    });	
	
	this.manager = null;
}

DaxiaoView.prototype = {
	constructor : DaxiaoView,
	updateView : function(manager) {
		this.manager = manager;
		this.daxiaoPanel.update(manager);
	}
};


