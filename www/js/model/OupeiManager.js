
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
function OupeiManager(url){
	this.dataArray = null;
	this.stat = null;
	this.url = url;
}

OupeiManager.prototype = {
	constructor : OupeiManager,
	
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
			this.stat = new OupeiStatObject();			
			this.dataArray = new Array();
		}			
		
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
	},
	
	clearData : function() {
		this.dataArray = null;
		this.stat = null;
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

