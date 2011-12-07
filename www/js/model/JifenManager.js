
// constants
var JIFEN_RANK = 0;
var JIFEN_TEAMID = 1;
var JIFEN_SIMPLIFIEDTEAMNAME = 2;
var JIFEN_TRADITIONALTEAMNAME = 3;
var JIFEN_MATCHES = 4;
var JIFEN_WIN = 5;
var JIFEN_DRAW = 6;
var JIFEN_LOSE = 7;
var JIFEN_GOALS = 8;
var JIFEN_GOALSAGAINST = 9;
var JIFEN_POINTS = 10;
var JIFEN_REMARK = 11;
var JIFEN_COUNT = 12;

function JifenManager(url){
	this.dataArray = null;
	this.url = url;
}

JifenManager.prototype = {
	constructor : JifenManager,
	
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
			if (record != null && record.length >= JIFEN_COUNT) {
				var obj = new JifenObject(record[JIFEN_RANK], record[JIFEN_TEAMID], record[JIFEN_SIMPLIFIEDTEAMNAME], record[JIFEN_TRADITIONALTEAMNAME], 
									record[JIFEN_MATCHES], record[JIFEN_WIN], record[JIFEN_DRAW], record[JIFEN_LOSE], record[JIFEN_GOALS],
									record[JIFEN_GOALSAGAINST], record[JIFEN_POINTS], record[JIFEN_REMARK]);				
				this.dataArray.push(obj);
				
			}
			else {
				console.log("<warning> readJifenData, but field in record is null or field count not enough");
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

