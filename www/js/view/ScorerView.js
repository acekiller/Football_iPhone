
function ScorerView(type){
	
	this.type = type;

	 var helperFunctions = {
	 };

    var scorerTemplate = Ext.XTemplate.from("scorer-template", helperFunctions);

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
        items: [this.scorerPanel]            
    });	
	
	this.manager = null;
}

ScorerView.prototype = {
	constructor : ScorerView,
	updateView : function(manager) {
		this.manager = manager;
		this.scorerPanel.update(manager);
	}
};


