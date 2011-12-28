
function DaxiaoView(type){
	
	this.type = type;

	 var helperFunctions = {
	 };

    var daxiaoTemplate = Ext.XTemplate.from("daxiao-template", helperFunctions);
	var noDataTemplate = Ext.XTemplate.from("noData-template", helperFunctions);
	this.noDataPanel = new Ext.Panel({
                                     tpl : noDataTemplate
                                     });	
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
        items: [this.daxiaoPanel,this.noDataPanel]            
    });	
	
	this.manager = null;
}

DaxiaoView.prototype = {
	constructor : DaxiaoView,
	updateView : function(manager) {
    	if (manager.dataArray == null || manager.dataArray.length == 0) {
            this.daxiaoPanel.hide();
            this.noDataPanel.show();
            this.noDataPanel.update();
        }
        else{
            this.noDataPanel.hide();
            this.daxiaoPanel.show();
            this.manager = manager;
            this.daxiaoPanel.update(manager);
            
        }
	}
};


