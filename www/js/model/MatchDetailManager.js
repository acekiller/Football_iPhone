

// constants
var MATCH_DETAIL_SEGMENT_EVENT = 0;
var MATCH_DETAIL_SEGMENT_STAT = 1;
var MATCH_DETAIL_SEGMENT_COUNT = 2;

var EVENT_FIELD_HOMEAWAYFLAG = 0;
var EVENT_FIELD_TYPE = 1;
var EVENT_FIELD_MINUTES = 2;
var EVENT_FIELD_PLAYER = 3;
var EVENT_FIELD_COUNT = 4;

var STAT_FIELD_TYPE = 0;
var STAT_FIELD_HOMEVALUE = 1;
var STAT_FIELD_AWAYVALUE = 2;
var STAT_FIELD_COUNT = 3;

// define Oupei Model
function MatchDetailManager(url){
	this.eventArray = null;
	this.statArray = null;
	this.url = url;
}

MatchDetailManager.prototype = {
	constructor : MatchDetailManager,
	
	readData: function(inputString){	
	
		this.eventArray = null;
		this.statArray = null;
	
		var segmentArray = parseRequestStringWithSegment(inputString);
		if (segmentArray == null) 
			return false;
			
		if (segmentArray.length < MATCH_DETAIL_SEGMENT_COUNT){
			console.log("error, readData for match detail, but segment count not enough");
			return false;
		}

		// init data again
		this.eventArray = new Array();
		this.statArray = new Array();

		// set data into event array
		var segArray1 = segmentArray[MATCH_DETAIL_SEGMENT_EVENT];
		for (var i=0; i<segArray1.length; i++){
			var record = segArray1[i];
			if (record != null && record.length >= EVENT_FIELD_COUNT){
				var obj = new MatchEventObject(record[EVENT_FIELD_HOMEAWAYFLAG],
					record[EVENT_FIELD_TYPE],
					record[EVENT_FIELD_MINUTES],
					record[EVENT_FIELD_PLAYER]);										

				this.eventArray.push(obj);
			}
			else{
				console.log("warning, read event data but field count not enough, i="+i+", field count = "+record.length);
			}
		}
		
		// set data into stat array
		var segArray2 = segmentArray[MATCH_DETAIL_SEGMENT_STAT];
		for (var i=0; i<segArray2.length; i++){
			var record = segArray2[i];
			if (record != null && record.length >= STAT_FIELD_COUNT){
				var obj = new MatchStatObject(record[STAT_FIELD_TYPE],
					record[STAT_FIELD_HOMEVALUE],
					record[STAT_FIELD_AWAYVALUE]);
				
				this.statArray.push(obj);
			}
			else{
				console.log("warning, read statistic data but field count not enough, i="+i+", field count = "+record.length);
			}
		}
						
		return this.eventArray;
	},
	
	clearData : function() {
		this.eventArray = null;
		this.statArray = null;
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


function testReadData(){
	var data = "0^1^3^D.卡里奴!1^1^42^F.蒙迪路!0^1^60^施薩 迪加度$$3^8^6!4^5^4!5^5^3!6^3^3!9^0^3!11^1^2!16^2^4";
	matchDetailManager.readData(data);
	console.log("event array = " + matchDetailManager.eventArray);
	console.log("stat array = " + matchDetailManager.statArray);
}

