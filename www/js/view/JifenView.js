
function JifenView(type){
	
	this.type = type;

	 var helperFunctions = {
	 };

    var jifenTemplate = Ext.XTemplate.from("jifen-template", helperFunctions);

    this.jifenPanel = new Ext.Panel({            
        tpl : jifenTemplate,
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
        items: [this.jifenPanel]            
    });	
	
	this.manager = null;
}

JifenView.prototype = {
	constructor : JifenView,
	updateView : function(manager) {
		this.manager = manager;
		this.jifenPanel.update(manager);
	}
};


