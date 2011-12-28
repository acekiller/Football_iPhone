
function ScorerView(type){
	
	this.type = type;

	 var helperFunctions = {
	 };

    var scorerTemplate = Ext.XTemplate.from("scorer-template", helperFunctions);
	var noDataTemplate = Ext.XTemplate.from("noData-template", helperFunctions);
	this.noDataPanel = new Ext.Panel({
	    tpl : noDataTemplate
	});	

    this.scorerPanel = new Ext.Panel({            
        tpl : scorerTemplate,
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
        items: [this.scorerPanel, this.noDataPanel]            
    });	
	
	this.manager = null;
}

ScorerView.prototype = {
	constructor : ScorerView,
	updateView : function(manager) {
    	if (manager.dataArray == null || manager.dataArray.length == 0) {
            this.scorerPanel.hide();
            this.noDataPanel.show();
            this.noDataPanel.update();
        }
        else{
            this.noDataPanel.hide();
            this.scorerPanel.show();
            this.manager = manager;
            this.scorerPanel.update(manager);

        }    
	
	}
};


