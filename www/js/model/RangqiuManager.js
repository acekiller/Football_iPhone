
// constants
var RANGQIU_RANK = 0;
var RANGQIU_TEAMID = 1;
var RANGQIU_SIMPLIFIED_TEAM_NAME = 2;
var RANGQIU_TRADITIONAL_TEAM_NAME = 3;
var RANGQIU_MATCHES = 4;
var RANGQIU_UP = 5;
var RANGQIU_DRAW = 6;
var RANGQIU_DOWN = 7;
var RANGQIU_WIN = 8;
var RANGQIU_ZOU = 9;
var RANGQIU_LOSE = 10;
var RANGQIU_SCORE_EARN = 11;
var RANGQIU_COUNT = 12;

function RangqiuManager(url){
	this.dataArray = null;
	this.url = url;
}

RangqiuManager.prototype = {
	constructor : RangqiuManager,
	
	readData: function(inputString){
		
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
			if (record != null && record.length >= RANGQIU_COUNT) {
				var obj = new RangqiuObject(record[RANGQIU_RANK], record[RANGQIU_TEAMID], 
				record[RANGQIU_SIMPLIFIED_TEAM_NAME], record[RANGQIU_TRADITIONAL_TEAM_NAME], 
				record[RANGQIU_MATCHES], record[RANGQIU_UP], 
				record[RANGQIU_DRAW], record[RANGQIU_DOWN], 
				record[RANGQIU_WIN],record[RANGQIU_ZOU], 
				record[RANGQIU_LOSE], record[RANGQIU_SCORE_EARN]);				
				this.dataArray.push(obj);
				
			}
			else {
				console.log("<warning> readRangqiuData, but field in record is null or field count not enough"+record.length);
			}
		}
						
		return this.dataArray;
	},
	
	clearData : function() {
		this.dataArray = null;
	},
	
	requestDataFromServer : function(leagueId, season, lang){
		this.clearData();
		
		var data = sendRequest(this.url + "ID=" + leagueId + "&Season=" +  season + "&lang=" + lang);
		if (data == null)
			return false;
			
		this.readData(data);
		return true;
	}
};

