
function LineupView(){

    var helperFunctions = {};
    
    var homeLineupTemplate = Ext.XTemplate.from("home-lineup-template", helperFunctions);
    var homeReserveTemplate = Ext.XTemplate.from("home-reserve-template", helperFunctions);
    var awayLineupTemplate = Ext.XTemplate.from("away-lineup-template", helperFunctions);
    var awayReserveTemplate = Ext.XTemplate.from("away-reserve-template", helperFunctions);
    
    
    this.homeLineupPanel = new Ext.Panel({
        id: 'homeLineupPanel',
        tpl: homeLineupTemplate,
        margin: '0 0 0 20',
        align: 'left'
    });
    
    this.homeReservePanel = new Ext.Panel({
        id: 'homeReservePanel',
        tpl: homeReserveTemplate,
        margin: '0 0 0 20',
        align: 'left'
    });
    
    this.awayLineupPanel = new Ext.Panel({
        id: 'awayLineupPanel',
        tpl: awayLineupTemplate,
        margin: '0 0 0 10',
        align: 'left'
    });
    
    this.awayReservePanel = new Ext.Panel({
        id: 'awayReservePanel',
        tpl: awayReserveTemplate,
        margin: '0 0 0 10',
        align: 'left'
    });
    
    this.mainPanel = new Ext.Panel({
    
        fullscreen: true,
        layout: 'vbox',
		bodyStyle:'background-image: url(images/team_bg@2x.png);background-repeat: no-repeat;width: 310px;height: 326px;',  
        defaults: {
            flex: 1,
            width: '100%',
            defaults: {
                height: '100%'
            }
        },
        
        items: [{
			scroll: 'vertical',
			margin: '10 0 0 0',
            xtype: 'panel',
            layout: 'hbox',
            items: [
               this.homeLineupPanel,
               this.awayLineupPanel
            ]
        }, {
			scroll: 'vertical',
			margin: '-60 0 0 0',						
            xtype: 'panel',
            layout: 'hbox',
            items: [
                this.homeReservePanel,
                this.awayReservePanel
            ]
        }, ]
    });
}

LineupView.prototype = {
    constructor: LineupView,
	updateView : function(manager) {
		this.homeLineupPanel.update(manager.data.homeLineup[0]);
		this.homeReservePanel.update(manager.data.homeReserve[0]);
		this.awayLineupPanel.update(manager.data.awayLineup[0]);
		this.awayReservePanel.update(manager.data.awayReserve[0]);
	}
};
