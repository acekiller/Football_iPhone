
function ScheduleView(type){
	
	this.type = type;

	 var helperFunctions = {
		 scheduleDateString : function(str){

			if (str == null || str.length < 12){
				return str;				
			}
						
			var year = str.substring(0, 4);
			var month = str.substring(4, 6);
			var day = str.substring(6, 8);
			var hour = str.substring(8, 10);
			var minute = str.substring(10, 12);
			
			var result = month + "/" + day ;
			return result;			
		},
         
         
        scoreHilight: function(state){
            var s = state - 0;
            if(s == -1 || s == 2)
                return true;
            return false;
        },
        
        scoreNormal: function(state){
             var s = state - 0;
             if(s == 1 || s == 3)
                 return true;
             return false;
         },		
         
        scoreVS: function(state){
            s = state - 0;
            if(s == -1 || s > 0)
                return false;
            return true;
		},
         
        statusHilight: function(state){
            var s = state - 0;
            if(s < 0)
                return true;
            return false;
        }
    };
            
    var scheduleTemplate = Ext.XTemplate.from("schedule-template", helperFunctions);
	var noDataTemplate = Ext.XTemplate.from("noData-template", helperFunctions);
	this.noDataPanel = new Ext.Panel({
	    tpl : noDataTemplate
	});	

    this.schedulePanel = new Ext.Panel({            
        tpl : scheduleTemplate,
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
        items: [this.schedulePanel,this.noDataPanel]            
    });	
	
	this.manager = null;
}

ScheduleView.prototype = {
	constructor : ScheduleView,
	updateView : function(manager) {
    	if (manager.dataArray == null || manager.dataArray.length == 0) {
            this.schedulePanel.hide();
            this.noDataPanel.show();
            this.noDataPanel.update();
        }
        else{
            this.noDataPanel.hide();
            this.schedulePanel.show();
            this.manager = manager;
            this.schedulePanel.update(manager);

        }    

	}
};


