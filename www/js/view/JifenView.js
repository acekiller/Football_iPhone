
function JifenView(type){
	
	this.type = type;

	 var helperFunctions = {
	 };

    var jifenTemplate = Ext.XTemplate.from("jifen-template", helperFunctions);
	var noDataTemplate = Ext.XTemplate.from("noData-template", helperFunctions);
	this.noDataPanel = new Ext.Panel({
                                     tpl : noDataTemplate
                                     });	
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
        items: [this.jifenPanel,this.noDataPanel]            
    });	
	
	this.manager = null;
}

JifenView.prototype = {
	constructor : JifenView,
	updateView : function(manager) {
    	if (manager.dataArray == null || manager.dataArray.length == 0) {
            this.jifenPanel.hide();
            this.noDataPanel.show();
            this.noDataPanel.update();
        }
        else{
            this.noDataPanel.hide();
            this.jifenPanel.show();
            this.manager = manager;
            this.jifenPanel.update(manager);
            
        }
	}
};


