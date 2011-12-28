function CupGroupResultView(){
	
	var helperFunctions = {
			 getFenzuName : function(obj) {
					return "分组" + obj[0].fenzu;
				},
				
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
			
			isFinished : function(state){
				if(state == -1){
	                return true;
	            }
				return false;
			},
			
			statusHilight: function(state){
	            var s = state - 0;
	            if(s < 0)
	                return true;
	            return false;
	        },
			
			getShortName: function(name) {
				if (name.length > 6) {
					return name.substring(0,6);
				} else {
					return name;
				}
			}
		 };

    var cupGroupResultTemplate = Ext.XTemplate.from("cupGroupResult-template", helperFunctions);
    var nodataTemplate = Ext.XTemplate.from("noCupGroupResult-template", helperFunctions);
    
    this.cupGroupResultPanel = new Ext.Panel({
        tpl: cupGroupResultTemplate
    });
    
    this.nodataPanel = new Ext.Panel({
        tpl: nodataTemplate
    });
    
    this.mainPanel = new Ext.Panel({
        fullscreen: true,
        layout: {
            type: 'vbox',
            align: 'top'
        },
        scroll: 'vertical',
        items: [this.cupGroupResultPanel,
                this.nodataPanel]
    });
    
}

CupGroupResultView.prototype = {
    constructor: CupGroupResultView,
    
    updateView: function(manager){
    
	if(manager.CupFenzuResultArray == null || manager.CupFenzuResultArray.length == 0) {
		this.cupGroupResultPanel.hide();
		this.nodataPanel.show();
		this.nodataPanel.update();
	} else {
		this.nodataPanel.hide();
		this.cupGroupResultPanel.show();
		this.cupGroupResultPanel.update(manager);
	}
       
        
    }
};
