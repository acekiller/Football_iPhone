function AnalysisView(){
	
	var helperFunctions = {
		getMonthDayFromDate: function(date) {
			return date.substring(4,6) +"/" + date.substring(6,8);
		},
		
		getYearFromDate: function(subArr) {
			return subArr[0].time.substring(0,4);
		},
		
		formateDate: function(date) {
			return date.substring(0,4) +"/" + date.substring(4,6) +"/" + date.substring(6,8);
		}
	};

    var analysisTemplate = Ext.XTemplate.from("analysis-template", helperFunctions);
  
    
    this.analysisPanel = new Ext.Panel({
        tpl: analysisTemplate
    });
    
	
	
	
    
    this.mainPanel = new Ext.Panel({
        fullscreen: true,
        layout: {
            type: 'vbox',
            align: 'top'
        },
        scroll: 'vertical',
        items: [this.analysisPanel]
    });
    
}

AnalysisView.prototype = {
    constructor: AnalysisView,
    
    updateView: function(manager){
    
     this.analysisPanel.update(manager);
        
    }
};
