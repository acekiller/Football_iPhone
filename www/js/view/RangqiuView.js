
function RangqiuView(type){
	
	this.type = type;

	 var helperFunctions = {
	 };

    var rangqiuTemplate = Ext.XTemplate.from("rangqiu-template", helperFunctions);
	var noDataTemplate = Ext.XTemplate.from("noData-template", helperFunctions);
	this.noDataPanel = new Ext.Panel({
	    tpl : noDataTemplate
	});	

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
        items: [this.rangqiuPanel,this.noDataPanel]            
    });	
	
	this.manager = null;
}

RangqiuView.prototype = {
	constructor : RangqiuView,
	updateView : function(manager) {
    	if (manager.dataArray == null || manager.dataArray.length == 0) {
            this.rangqiuPanel.hide();
            this.noDataPanel.show();
            this.noDataPanel.update();
        }
        else{
            this.noDataPanel.hide();
            this.rangqiuPanel.show();
            this.manager = manager;
            this.rangqiuPanel.update(manager);

        }
	}
};


