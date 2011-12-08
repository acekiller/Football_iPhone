
// constants
var SCORER_RANK = 0;
var SCORER_SIMPLIFIED_SCORER_NAME = 1;
var SCORER_TRADITIONAL_SCORER_NAME = 2;
var SCORER_COUNTRY = 3;
var SCORER_SIMPLIFIED_TEAM_NAME = 4;
var SCORER_TRADITIONAL_TEAM_NAME = 5;
var SCORER_SCORE_COUNT = 6;
var SCORER_HOME_SCORE_COUNT = 7;
var SCORER_AWAY_SCORE_COUNT = 8;
var SCORER_COUNT = 9;

function ScorerManager(url){
	this.dataArray = null;
	this.url = url;
}

ScorerManager.prototype = {
	constructor : ScorerManager,
	
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
			if (record != null && record.length >= SCORER_COUNT) {
				var obj = new ScorerObject(record[SCORER_RANK], record[SCORER_SIMPLIFIED_SCORER_NAME], 
				record[SCORER_TRADITIONAL_SCORER_NAME], record[SCORER_COUNTRY], 
				record[SCORER_SIMPLIFIED_TEAM_NAME], record[SCORER_TRADITIONAL_TEAM_NAME], 
				record[SCORER_SCORE_COUNT], record[SCORER_HOME_SCORE_COUNT], 
				record[SCORER_AWAY_SCORE_COUNT]);				
				this.dataArray.push(obj);
				
			}
			else {
				console.log("<warning> readScorerData, but field in record is null or field count not enough");
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

