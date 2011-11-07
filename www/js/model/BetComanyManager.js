
var YAPEI_CHANGE_FIELD_HOME = 0; // 主队赔率
var YAPEI_CHANGE_FIELD_PANKOU = 1;// 盘口
var YAPEI_CHANGE_FIELD_AWAY = 2;// 客队赔率
var YAPEI_CHANGE_FIELD_MODIFYDATE = 3;// 变化时间
var YAPEI_CHANGE_FIELD_COUNT = 4;

//define Yapei Model
function BetCompanyManager(url, type) {
	this.type = type;
	this.selectCompanyId = null;
	this.betCompanyList = new Array();
	this.oddsChangeList = null;
	this.url = url;
}

BetCompanyManager.prototype = {
	constructor : BetCompanyManager,
	
	add : function (betId, name){
		var obj = new BetCompanyObject(name, betId);
		this.betCompanyList.push(obj); 
	},
	
	clear : function(){
		this.betCompanyList = new Array();
	},
	
	toString : function(){
		return this.betCompanyList.toString();
	},
	
	parseOddsChangeRecord : function(inputString){

		// clear data firstly
		this.oddsChangeList = null;
		
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
			this.oddsChangeList = new Array();			
		}			
		
		for (var i = 0; i < len; i++) {
			var record = recordArray[i];
			if (record != null && record.length >= YAPEI_CHANGE_FIELD_COUNT) {
				var obj = new OddsChangeObject( 
					record[YAPEI_CHANGE_FIELD_HOME], 
					record[YAPEI_CHANGE_FIELD_PANKOU], 
					record[YAPEI_CHANGE_FIELD_AWAY], 
					record[YAPEI_CHANGE_FIELD_MODIFYDATE]);				
				this.oddsChangeList.push(obj);				
			}
			else {
				console.log("<warning> read odds change record, but field in record is null or field count not enough");
			}
		}
						
		return this.oddsChangeList;
	},
	
	clearData : function() {
        this.oddsChangeList = null;
	},
	
	requestOddsChangeFromServer : function(companyBetId){
		 this.clearData();	
		
		  var xhr = new XMLHttpRequest();
		  xhr.open("get", this.url + companyBetId, false);
		  // --allow-file-access-from-files
		  // xhr.setRequestHeader("Access-Control-Allow-Origin", "*");
		  xhr.send(null);
		  if (xhr.status == 200) {
		 	 this.parseOddsChangeRecord(xhr.responseText);
		  }			
	}
};

