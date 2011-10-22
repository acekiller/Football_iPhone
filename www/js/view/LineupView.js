
function LineupView(){

    var helperFunctions = {};
    
    var homeLineupTemplate = Ext.XTemplate.from("home-lineup-template", helperFunctions);
    var homeReserveTemplate = Ext.XTemplate.from("home-reserve-template", helperFunctions);
    var awayLineupTemplate = Ext.XTemplate.from("away-lineup-template", helperFunctions);
    var awayReserveTemplate = Ext.XTemplate.from("away-reserve-template", helperFunctions);
    
    
    this.homeLineupPanel = new Ext.Panel({
        id: 'homeLineupPanel',
        tpl: homeLineupTemplate,
        margin: '20 10 20 0',
        align: 'left'
    });
    
    this.homeReservePanel = new Ext.Panel({
        id: 'homeReservePanel',
        tpl: homeReserveTemplate,
        margin: '20 10 20 0',
        align: 'left'
    });
    
    this.awayLineupPanel = new Ext.Panel({
        id: 'awayLineupPanel',
        tpl: awayLineupTemplate,
        margin: '20 10 20 0',
        align: 'left'
    });
    
    this.awayReservePanel = new Ext.Panel({
        id: 'awayReservePanel',
        tpl: awayReserveTemplate,
        margin: '20 10 20 0',
        align: 'left'
    });
    
    this.mainPanel = new Ext.Panel({
    
        fullscreen: true,
        layout: 'vbox',
        defaults: {
            flex: 1,
            width: '100%',
            defaults: {
                flex: 1,
                height: '100%'
            }
        },
        scroll: 'vertical',
        items: [{
            xtype: 'panel',
            layout: 'hbox',
            items: [
               this.homeLineupPanel,
               this.awayLineupPanel
            ]
        }, {
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
    constructor: LineupView
};
