
// constants
var OUPEI_FIELD_NAME = 0;
var OUPEI_FIELD_ID = 1;
var OUPEI_FIELD_CHUPANWIN = 2;
var OUPEI_FIELD_CHUPANDRAW = 3;
var OUPEI_FIELD_CHUPANLOST = 4;
var OUPEI_FIELD_JISHIWIN = 5;
var OUPEI_FIELD_JISHIDRAW = 6;
var OUPEI_FIELD_JISHILOST = 7;
var OUPEI_FIELD_COUNT = 8;

// define Oupei Model
function OupeiManager(){
	this.dataArray = null;
	this.stat = null;
}

OupeiManager.prototype = {
	constructor : OupeiManager,
	
	readData: function(inputString){	
		var recordArray = parseRequestString(inputString);
		if (recordArray == null) 
			return null;

		this.dataArray = null;		
		this.dataArray = new Array();
		this.stat = new OupeiStatObject();
		var len = recordArray.length;
		for (var i = 0; i < len; i++) {
			var record = recordArray[i];
			if (record != null && record.length >= OUPEI_FIELD_COUNT) {
				var obj = new OupeiObject(record[OUPEI_FIELD_NAME], record[OUPEI_FIELD_CHUPANWIN], record[OUPEI_FIELD_CHUPANDRAW], record[OUPEI_FIELD_CHUPANLOST], record[OUPEI_FIELD_JISHIWIN], record[OUPEI_FIELD_JISHIDRAW], record[OUPEI_FIELD_JISHILOST]);				
				this.dataArray.push(obj);
				
				// update statistic data
				this.stat.updateStat(obj);								
			}
			else {
				console.log("<warning> readOupeiData, but field in record is null or field count not enough");
			}
		}
						
		return this.dataArray;
	}
};

// init the global object
var oupeiManager = new OupeiManager();



