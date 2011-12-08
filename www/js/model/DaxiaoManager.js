
// constants
var DAXIAO_RANK = 0;
var DAXIAO_TEAMID = 1;
var DAXIAO_SIMPLIFIED_TEAM_NAME = 2;
var DAXIAO_TRADITIONAL_TEAM_NAME = 3;
var DAXIAO_MATCHES = 4;
var DAXIAO_BIG = 5;
var DAXIAO_ZOU = 6;
var DAXIAO_SMALL = 7;
var DAXIAO_DAQIULV = 8;
var DAXIAO_ZOULV = 9;
var DAXIAO_XIAOLV = 10;
var DAXIAO_COUNT = 11;

function DaxiaoManager(url){
	this.dataArray = null;
	this.url = url;
}

DaxiaoManager.prototype = {
	constructor : DaxiaoManager,
	
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
			if (record != null && record.length >= DAXIAO_COUNT) {
				var obj = new DaxiaoObject(record[DAXIAO_RANK], record[DAXIAO_TEAMID], record[DAXIAO_SIMPLIFIED_TEAM_NAME], record[DAXIAO_TRADITIONAL_TEAM_NAME], 
									record[DAXIAO_MATCHES], record[DAXIAO_BIG], record[DAXIAO_ZOU], record[DAXIAO_SMALL], record[DAXIAO_DAQIULV],
									record[DAXIAO_ZOULV], record[DAXIAO_XIAOLV]);				
				this.dataArray.push(obj);
				
			}
			else {
				console.log("<warning> readDaxiaoData, but field in record is null or field count not enough");
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

