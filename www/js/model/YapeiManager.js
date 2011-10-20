
// constants
var YAPEI_FIELD_NAME = 0;
var YAPEI_FIELD_ID = 1;
var YAPEI_FIELD_HOMECHUPEI = 2;
var YAPEI_FIELD_CHUPAN = 3;
var YAPEI_FIELD_AWAYCHUPEI = 4;
var YAPEI_FIELD_HOMEJISHI = 5;
var YAPEI_FIELD_JISHI = 6;
var YAPEI_FIELD_AWAYJISHI = 7;
var YAPEI_FIELD_COUNT = 8;

// define YapeiMangager Model
function YapeiManager(){
	this.dataArray = null;
}

YapeiManager.prototype = {
	constructor : YapeiManager,
	
	readData: function(inputString){
		
		// clear data firstly
		this.stat = null;
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
			if (record != null && record.length >= OUPEI_FIELD_COUNT) {
				var obj = new YapeiObject(record[OUPEI_FIELD_NAME], record[YAPEI_FIELD_HOMECHUPEI], record[YAPEI_FIELD_CHUPAN], record[YAPEI_FIELD_AWAYCHUPEI], record[YAPEI_FIELD_HOMEJISHI], record[YAPEI_FIELD_JISHI], record[YAPEI_FIELD_AWAYJISHI]);				
				this.dataArray.push(obj);
				
			}
			else {
				console.log("<warning> readYAPEIData, but field in record is null or field count not enough");
			}
		}
						
		return this.dataArray;
	}
};

// init the global object
var yapeiManager = new YapeiManager();


