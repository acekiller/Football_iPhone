
//constants
var LINEUP_FIELD_HOME = 0;
var LINEUP_FIELD_HOMERESERVE = 1;
var LINEUP_FIELD_AWAY = 2;
var LINEUP_FIELD_AWAYRESERVE = 3;
var LINEUP_FIELD_COUNT = 4;

//define LineupManager Model
function LineupManager(){
	
}

LineupManager.prototype = {
	constructor : LineupManager,
	
	readData: function(inputString){
		
		// clear data firstly
		this.data = null;

		if (inputString == null || inputString.length == 0)
			return null;
			
		var recordArray = parseRequestStringWithSegment(inputString);
		if (recordArray == null) 
			return null;
		
		var len = recordArray.length;
		if (len == 0){
			return null;
		}
		else{
			this.dataArray = new Array();
		}
					
        var obj = new LineupObject(recordArray[LINEUP_FIELD_HOME], recordArray[LINEUP_FIELD_HOMERESERVE], recordArray[LINEUP_FIELD_AWAY], recordArray[LINEUP_FIELD_AWAYRESERVE]);
        this.data = obj;
						
		return this.data;
	}
};

