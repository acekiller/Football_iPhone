
function LineupView(){

    var helperFunctions = {};
    
    var homeLineupTemplate = Ext.XTemplate.from("home-lineup-template", helperFunctions);
    var homeReserveTemplate = Ext.XTemplate.from("home-reserve-template", helperFunctions);
    var awayLineupTemplate = Ext.XTemplate.from("away-lineup-template", helperFunctions);
    var awayReserveTemplate = Ext.XTemplate.from("away-reserve-template", helperFunctions);    
    var nodataTemplate = Ext.XTemplate.from("nodata-template", helperFunctions);
    
    this.homeLineupPanel = new Ext.Panel({
        id: 'homeLineupPanel',
        tpl: homeLineupTemplate,
        margin: '10 0 10 20',
        align: 'left',
    });
    
    this.homeReservePanel = new Ext.Panel({
        id: 'homeReservePanel',
        tpl: homeReserveTemplate,
        margin: '0 0 0 20',
    });
    
    this.awayLineupPanel = new Ext.Panel({
        id: 'awayLineupPanel',
        tpl: awayLineupTemplate,
        margin: '10 0 10 110',
        align: 'left'
    });
    
    this.awayReservePanel = new Ext.Panel({
        id: 'awayReservePanel',
        tpl: awayReserveTemplate,
        margin: '0 0 0 110',
    });
	
	this.subPanel1 = new Ext.Panel({	
	    layout: {
	        type: 'vbox',
	        align: 'left'
	    },
	    items: [this.homeLineupPanel,
               this.homeReservePanel]          
	});
	
	this.subPanel2 = new Ext.Panel({	
	    layout: {
	        type: 'vbox',
	        align: 'left'
	    },
	    items: [this.awayLineupPanel,
               this.awayReservePanel]          
	});
	
	
	
	this.mainPanel = new Ext.Panel({
		fullscreen: true,
		bodyStyle:'background-image: url(images/team_bg@2x.png);background-repeat: no-repeat',
		layout: {
	        type: 'hbox',
			align: 'left'
	    }, 
		scroll : 'vertical',
		tpl : '<div class="nodata"><span>暂无阵容相关数据</span></div>',
	    items: [this.subPanel1,
               this.subPanel2,nodataTemplate] 

	});

}

LineupView.prototype = {
    constructor: LineupView,
	updateView : function(manager) {
		if (manager.data != null 
		 && manager.data.homeLineup.length > 0 && manager.data.homeReserve.length > 0 
		 && manager.data.awayLineup.length > 0 && manager.data.awayReserve.length > 0 ) {
			this.subPanel1.show();
			this.subPanel2.show();
			this.homeLineupPanel.update(manager.data.homeLineup);
			this.homeReservePanel.update(manager.data.homeReserve);
			this.awayLineupPanel.update(manager.data.awayLineup);
			this.awayReservePanel.update(manager.data.awayReserve);

			Ext.get('nodata-template').dom.style.display = 'none'; 
			
		}
		 else {
			//Ext.get('homelist').dom.style.display = 'none'; 
			//Ext.get('homeReservelist').dom.style.display = 'none'; 
			//Ext.get('awaylist').dom.style.display = 'none'; 
			//Ext.get('awayReservelist').dom.style.display = 'none'; 
			 Ext.get('nodata-template').dom.style.display = 'block';
			this.subPanel1.hide();
			this.subPanel2.hide();
		}
	}
};
