
// constants

var SCHEDULE_RECORD_SEG = 1;
var SCHEDULE_ROUND_SEG = 0;
var SCHEDULE_ROUND = 0;
var SCHEDULE_PLAYING_TIME = 1;
var SCHEDULE_SIMPLIFIED_HOMETEAM_NAME = 2;
var SCHEDULE_TRADITIONAL_HOMETEAM_NAME = 3;
var SCHEDULE_SIMPLIFIED_AWAYTEAM_NAME = 4;
var SCHEDULE_TRADITIONAL_AWAYTEAM_NAME = 5;
var SCHEDULE_STATE = 6;
var SCHEDULE_HOMETEAM_SCORE = 7;
var SCHEDULE_AWAYTEAM_SCORE = 8;
var SCHEDULE_HOMETEAM_HALF_SCORE = 9;
var SCHEDULE_AWAY_HALF_SCORE = 10;
var SCHEDULE_COUNT = 11;


function ScheduleManager(url){
	this.dataArray = null;
	this.url = url;
}

ScheduleManager.prototype = {
	constructor : ScheduleManager,
	
	readData: function(inputString){
		
		// clear data firstly
		this.dataArray = null;

		if (inputString == null || inputString.length == 0)
			return null;
			
		var recordArray = parseRequestStringWithSegment(inputString);
		if (recordArray == null) 
			return null;
		
		var len = recordArray.length;
		if (len == 0){
			return null;
		}	
		
		seg2 = recordArray[SCHEDULE_RECORD_SEG];
		
		if(seg2 == null || seg2.length == 0)
		{
			return null;
		}
		len = seg2.length;
		this.dataArray = new Array();
		var round = "";
		for (var i = 0; i < len; i++) {
			var record = seg2[i];
			if (record != null && record.length >= SCHEDULE_COUNT) {			
			var obj = new ScheduleObject(record[SCHEDULE_ROUND],record[SCHEDULE_PLAYING_TIME], 
                record[SCHEDULE_SIMPLIFIED_HOMETEAM_NAME], record[SCHEDULE_TRADITIONAL_HOMETEAM_NAME], 
                record[SCHEDULE_SIMPLIFIED_AWAYTEAM_NAME], record[SCHEDULE_TRADITIONAL_AWAYTEAM_NAME], 
                record[SCHEDULE_STATE], record[SCHEDULE_HOMETEAM_SCORE], record[SCHEDULE_AWAYTEAM_SCORE],
                record[SCHEDULE_HOMETEAM_HALF_SCORE], record[SCHEDULE_AWAY_HALF_SCORE]);				
				this.dataArray.push(obj);
				
                
                round = record[SCHEDULE_ROUND];
			}
			else {
				console.log("<warning> readScheduleData, but field in record is null or field count not enough");
			}
		}
        var ret = recordArray[SCHEDULE_ROUND_SEG][0]+"$$"+round;
		return ret;
	},
	
	clearData : function() {
		this.dataArray = null;
	},
	
	requestDataFromServer : function(leagueId, season, round, lang){
		this.clearData();
		
		var data = sendRequest(this.url + "ID=" + leagueId + "&Season=" +  season + "&Round=" +  round + "&lang=" + lang);
		if (data == null)
			return false;
		return this.readData(data);
	}
};

