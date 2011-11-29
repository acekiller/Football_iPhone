
//constants
var LINEUP_FIELD_HOME = 0;
var LINEUP_FIELD_HOMERESERVE = 1;
var LINEUP_FIELD_AWAY = 2;
var LINEUP_FIELD_AWAYRESERVE = 3;
var LINEUP_FIELD_COUNT = 4;

//define LineupManager Model
function LineupManager(url){
	this.url = url;
	this.data = null;
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
		else if (len < LINEUP_FIELD_COUNT){
			console.log("read lineup data but segment not enough");
			return null;
		}
					
        var obj = new LineupObject(recordArray[LINEUP_FIELD_HOME][0], 
			recordArray[LINEUP_FIELD_HOMERESERVE][0], 
			recordArray[LINEUP_FIELD_AWAY][0], 
			recordArray[LINEUP_FIELD_AWAYRESERVE][0]);
			
		if (obj != null) {
        	this.data = obj;
		}	
		console.log(this.data);
						
		return this.data;
	},
	
	clearData : function() {
		console.log("clear data...");
		this.data = null;
	},
	
	requestDataFromServer : function(matchId, lang){
		
		this.clearData();
		
		var data = sendRequest(this.url + matchId + "&lang=" + lang);
		if (data == null)
			return false;
			
		this.readData(data);
		return true;
	}
};

