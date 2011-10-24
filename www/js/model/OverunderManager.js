
// constants
var OVERUNDER_FIELD_NAME = 0;
var OVERUNDER_FIELD_ID = 1;
var OVERUNDER_FIELD_OVERCHUPEI = 2;
var OVERUNDER_FIELD_CHUPAN = 3;
var OVERUNDER_FIELD_UNDERCHUPEI = 4;
var OVERUNDER_FIELD_OVERJISHI = 5;
var OVERUNDER_FIELD_JISHI = 6;
var OVERUNDER_FIELD_UNDERJISHI = 7;
var OVERUNDER_FIELD_COUNT = 8;

//define OverunderManager Model
function OverunderManager() {
	this.dataArray = null;
}

OverunderManager.prototype = {
	constructor : OverunderManager,
	
	readData : function(inputString){
		// clear data firstly
		this.dataArray = null;

		if (inputString == null || inputString.length == 0)
			return null;
			
		var recordArray = parseRequestString(inputString);
		if (recordArray == null) 
			return null;
		
		var len = recordArray.length;
		if (len == 0){
			return null;
		}
		else{
			this.dataArray = new Array();
		}			
		
		for (var i = 0; i < len; i++) {
			var record = recordArray[i];
			if (record != null && record.length >= OVERUNDER_FIELD_COUNT) {
				var obj = new OverunderObject(record[OVERUNDER_FIELD_NAME], record[OVERUNDER_FIELD_OVERCHUPEI], record[OVERUNDER_FIELD_CHUPAN], record[OVERUNDER_FIELD_UNDERCHUPEI], record[OVERUNDER_FIELD_OVERJISHI], record[OVERUNDER_FIELD_JISHI], record[OVERUNDER_FIELD_UNDERJISHI]);				
				this.dataArray.push(obj);
				
			}
			else {
				console.log("<warning> readOVERUNDERData, but field in record is null or field count not enough");
			}
		}
						
		return this.dataArray;
	}
};

