
// constants
var ANALYSIS_SEGMENT_HOMEPOINTS = 0;
var ANALYSIS_SEGMENT_AWAYPOINTS = 1;
var ANALYSIS_SEGMENT_CUP = 2;
var ANALYSIS_SEGMENT_HEADTOHEAD = 3;
var ANALYSIS_SEGMENT_HOMERECORD = 4;
var ANALYSIS_SEGMENT_AWAYRECORD = 5;
var ANALYSIS_SEGMENT_HOMENEAR3GAMES = 6;
var ANALYSIS_SEGMENT_AWAYNEAR3GAMES = 7;
var ANALYSIS_SEGMENT_RECOMMEND = 8;
var ANALYSIS_SEGMENT_COUNT = 9;

//home away points
var POINTS_FIELD_TYPE = 0;
var POINTS_FIELD_GAMES = 1;
var POINTS_FIELD_WIN = 2;
var POINTS_FIELD_DRAW = 3;
var POINTS_FIELD_LOSE = 4;
var POINTS_FIELD_SCORE = 5;
var POINTS_FIELD_SCORE_AGAINST = 6;
var POINTS_FIELD_POINTS = 7;
var POINTS_FIELD_RANK = 8;
var POINTS_FIELD_WINNING_RATIO = 9;
var POINTS_FIELD_COUNT= 10;

//cup points
var CPU_FIELD_RANK = 0;
var CPU_FIELD_HOME = 1;
var CPU_FIELD_GAEMS = 2;
var CPU_FIELD_WIN = 3;
var CPU_FIELD_DRAW = 4;
var CPU_FIELD_LOSE = 5;
var CPU_FIELD_SCORE = 6;
var CPU_FIELD_SCORE_AGAINST = 7;
var CPU_FIELD_POINTS = 8;

//head to head 
var HEAD_FIELD_TIME = 0;
var HEAD_FIELD_LEAGUE = 1;
var HEAD_FIELD_HOME = 2;
var HEAD_FIELD_AWAY = 3;
var HEAD_FIELD_HOME_POINTS = 4;
var HEAD_FIELD_AWAY_POINTS = 5;
var HEAD_FIELD_HOME_HALF_POINTS = 6;
var HEAD_FIELD_AWAY_HALF_POINTS = 7;
var HEAD_FIELD_COUNT = 8;

//record
var RECORD_FIELD_TIME = 0;
var RECORD_FIELD_LEAGUE = 1;
var RECORD_FIELD_HOME = 2;
var RECORD_FIELD_AWAY = 3;
var RECORD_FIELD_HOME_POINTS = 4;
var RECORD_FIELD_AWAY_POINTS = 5;
var RECORD_FIELD_ODDS = 6;
var RECORD_FIELD_COUNT = 7;

//near 3 games
var NEAR_FIELD_TIME = 0;
var NEAR_FIELD_LEAGUE = 1;
var NEAR_FIELD_HOME = 2;
var NEAR_FIELD_AWAY = 3;
var NEAR_FIELD_OFFSET_DAY = 4;
var NEAR_FIELD_COUNT = 5;

//recommend
var RECOMMEND_FIELD_HOME = 0;
var RECOMMEND_FIELD_HOME_TREND = 1;
var RECOMMEND_FIELD_HOME_ODDS = 2;
var RECOMMEND_FIELD_AWAY = 3;
var RECOMMEND_FIELD_AWAY_TREND = 4;
var RECOMMEND_FIELD_AWAY_ODDS = 5;
var RECOMMEND_FIELD_ANALYSIS = 6;
var RECOMMEND_FIELD_COUNT = 7;



function AnalysisManager(url) {
    this.url = url;
    this.hometeam = "";
    this.awayteam = "";
    this.homePointsArray = null;
    this.awayPointsArray = null;
    this.headtoheadArray = null;
    this.homeRecordArray = null;
    this.awayRecordArray = null;
    this.homeNear3GamesArray = null;
    this.awayNear3GamesArray = null;
    this.recommendArray = null;
}

AnalysisManager.prototype = {
	constructor : AnalysisManager,
	
	readData: function(inputString, home, away){
		this.hometeam = home;
		this.awayteam = away;
		this.homePointsArray = null;
		this.awayPointsArray = null;
		this.headtoheadArray = null;
		this.homeRecordArray = null;
		this.awayRecordArray = null;
		this.homeNear3GamesArray = null;
		this.awayNear3GamesArray = null;
		this.recommendArray = null;
	
		var segmentArray = parseRequestStringWithSegment(inputString);
		if (segmentArray == null) 
			return false;
			
		if (segmentArray.length < ANALYSIS_SEGMENT_COUNT){
			console.log("error, readData for analysis, but segment count not enough " + segmentArray.length);
			return false;
		}

		// init data again
		this.homePointsArray = new Array();
		this.awayPointsArray = new Array();
		this.headtoheadArray = new Array();
		this.homeRecordArray = new Array();
		this.awayRecordArray = new Array();
		this.homeNear3GamesArray = new Array();
		this.awayNear3GamesArray = new Array();
		this.recommendArray = new Array();

		// set data into home points array
		var segArray1 = segmentArray[ANALYSIS_SEGMENT_HOMEPOINTS];
		for (var i=0; i<segArray1.length; i++){
			var record = segArray1[i];
			if (record != null && record.length >= POINTS_FIELD_COUNT){
				var obj = new PointsObject(record[POINTS_FIELD_TYPE],
					record[POINTS_FIELD_GAMES],
					record[POINTS_FIELD_WIN],
					record[POINTS_FIELD_DRAW],	
					record[POINTS_FIELD_LOSE],
					record[POINTS_FIELD_SCORE],
					record[POINTS_FIELD_SCORE_AGAINST],
					record[POINTS_FIELD_SCORE]-record[POINTS_FIELD_SCORE_AGAINST],
					record[POINTS_FIELD_POINTS],
					record[POINTS_FIELD_RANK],
					record[POINTS_FIELD_WINNING_RATIO]);									

				this.homePointsArray.push(obj);
			}
			else{
				console.log("warning, read home points data but field count not enough, i="+i+", field count = "+record.length);
			}
		}
		
		// set data into away points array
		var segArray2 = segmentArray[ANALYSIS_SEGMENT_AWAYPOINTS];
		for (var i=0; i<segArray2.length; i++){
			var record = segArray2[i];
			if (record != null && record.length >= POINTS_FIELD_COUNT){
				var obj = new PointsObject(record[POINTS_FIELD_TYPE],
					record[POINTS_FIELD_GAMES],
					record[POINTS_FIELD_WIN],
					record[POINTS_FIELD_DRAW],	
					record[POINTS_FIELD_LOSE],
					record[POINTS_FIELD_SCORE],
					record[POINTS_FIELD_SCORE_AGAINST],
					record[POINTS_FIELD_SCORE]-record[POINTS_FIELD_SCORE_AGAINST],
					record[POINTS_FIELD_POINTS],
					record[POINTS_FIELD_RANK],
					record[POINTS_FIELD_WINNING_RATIO]);									

				this.awayPointsArray.push(obj);
			}
			else{
				console.log("warning, read away points data but field count not enough, i="+i+", field count = "+record.length);
			}
		}
		
		// set data into headtohead array
		var segArray3 = segmentArray[ANALYSIS_SEGMENT_HEADTOHEAD];
		for (var i=0; i<segArray3.length; i++){
			var record = segArray3[i];
			if (record != null && record.length >= HEAD_FIELD_COUNT){
				var obj = new HeadToHeadObject(record[HEAD_FIELD_TIME],
					record[HEAD_FIELD_LEAGUE],
					record[HEAD_FIELD_HOME],
					record[HEAD_FIELD_AWAY],	
					record[HEAD_FIELD_HOME_POINTS],
					record[HEAD_FIELD_AWAY_POINTS],
					record[HEAD_FIELD_HOME_HALF_POINTS],
					record[HEAD_FIELD_AWAY_HALF_POINTS]);									

				this.headtoheadArray.push(obj);
			}
			else{
				console.log("warning, read headtohead data but field count not enough, i="+i+", field count = "+record.length);
			}
			this.groupHeadtoheadArray = groupHeadtoHeadByYear(this.headtoheadArray);
		}
		
		
		// set data into home record array
		var segArray4 = segmentArray[ANALYSIS_SEGMENT_HOMERECORD];
		for (var i=0; i<segArray4.length; i++){
			var record = segArray4[i];
			if (record != null && record.length >= RECORD_FIELD_COUNT){
				var obj = new RecordObject(record[RECORD_FIELD_TIME],
					record[RECORD_FIELD_LEAGUE],
					record[RECORD_FIELD_HOME],
					record[RECORD_FIELD_AWAY],	
					record[RECORD_FIELD_HOME_POINTS],
					record[RECORD_FIELD_AWAY_POINTS],
					record[RECORD_FIELD_ODDS]);									

				this.homeRecordArray.push(obj);
			}
			else{
				console.log("warning, read records data but field count not enough, i="+i+", field count = "+record.length);
			}
		}
		
		// set data into home record array
		var segArray5 = segmentArray[ANALYSIS_SEGMENT_AWAYRECORD];
		for (var i=0; i<segArray5.length; i++){
			var record = segArray5[i];
			if (record != null && record.length >= RECORD_FIELD_COUNT){
				var obj = new RecordObject(record[RECORD_FIELD_TIME],
					record[RECORD_FIELD_LEAGUE],
					record[RECORD_FIELD_HOME],
					record[RECORD_FIELD_AWAY],	
					record[RECORD_FIELD_HOME_POINTS],
					record[RECORD_FIELD_AWAY_POINTS],
					record[RECORD_FIELD_ODDS]);									

				this.awayRecordArray.push(obj);
			}
			else{
				console.log("warning, read records data but field count not enough, i="+i+", field count = "+record.length);
			}
		}
		
		// set data into home near3games array
		var segArray6 = segmentArray[ANALYSIS_SEGMENT_HOMENEAR3GAMES];
		for (var i=0; i<segArray6.length; i++){
			var record = segArray6[i];
			if (record != null && record.length >= NEAR_FIELD_COUNT){
				var obj = new Near3GamesObject(record[NEAR_FIELD_TIME],
					record[NEAR_FIELD_LEAGUE],
					record[NEAR_FIELD_HOME],
					record[NEAR_FIELD_AWAY],	
					record[NEAR_FIELD_OFFSET_DAY]);									

				this.homeNear3GamesArray.push(obj);
			}
			else{
				console.log("warning, read home near 3 games data but field count not enough, i="+i+", field count = "+record.length);
			}
		}
		
		// set data into away near3games array
		var segArray7 = segmentArray[ANALYSIS_SEGMENT_AWAYNEAR3GAMES];
		for (var i=0; i<segArray7.length; i++){
			var record = segArray7[i];
			if (record != null && record.length >= NEAR_FIELD_COUNT){
				var obj = new Near3GamesObject(record[NEAR_FIELD_TIME],
					record[NEAR_FIELD_LEAGUE],
					record[NEAR_FIELD_HOME],
					record[NEAR_FIELD_AWAY],	
					record[NEAR_FIELD_OFFSET_DAY]);									

				this.awayNear3GamesArray.push(obj);
			}
			else{
				console.log("warning, read away near 3 games data but field count not enough, i="+i+", field count = "+record.length);
			}
		}
		
		// set data into recommend array
		var segArray8 = segmentArray[ANALYSIS_SEGMENT_RECOMMEND];
            for (var i = 0; i < segArray8.length; i++) {
                var record = segArray8[i];
                if (record != null && record.length >= RECOMMEND_FIELD_COUNT) {
                    var obj = new RecommendObject(record[RECOMMEND_FIELD_HOME], 
					record[RECOMMEND_FIELD_HOME_TREND], 
					record[RECOMMEND_FIELD_HOME_ODDS], 
					record[RECOMMEND_FIELD_AWAY], 
					record[RECOMMEND_FIELD_AWAY_TREND], 
					record[RECOMMEND_FIELD_AWAY_ODDS], 
					record[RECOMMEND_FIELD_ANALYSIS]);
                    
                    this.recommendArray.push(obj);
                }
                else {
                    console.log("warning, read recommend data but field count not enough, i=" + i + ", field count = " + record.length);
                }
            }
						
		return this.homePointsArray;
	},
	
	clearData : function() {
        this.hometeam = "";
        this.awayteam = "";
        this.homePointsArray = null;
        this.awayPointsArray = null;
        this.headtoheadArray = null;
        this.homeRecordArray = null;
        this.awayRecordArray = null;
        this.homeNear3GamesArray = null;
        this.awayNear3GamesArray = null;
        this.recommendArray = null;
	},
	
	requestDataFromServer : function(matchId, homeTeam, awayTeam, lang){
		this.clearData();

		var data = sendRequest(this.url + matchId + "&lang=" + lang);
		if (data == null)
			return false;
		this.readData(data, homeTeam, awayTeam);
		return true;
	}
};

function testReadAnalysisData(){
	var data = "总^13^5^4^4^18^14^19^7^38%!主^6^4^1^1^10^4^13^5^67%!客^7^1^3^3^8^10^6^12^14%!近^6^4^1^1^10^5^13^^67%$$总^13^3^4^6^11^18^13^18^23%!主^7^2^3^2^6^7^9^15^29%!客^6^1^1^4^5^11^4^17^17%!近^6^0^3^3^2^8^3^^0%$$20111101033000^法乙^南特^朗斯^1^0^0^0!20070415020000^法甲^南特^朗斯^0^0^0^0!20061119033000^法甲^朗斯^南特^2^0^1^0!20060514020000^法甲^朗斯^南特^3^1^2^1!20050731020000^法甲^南特^朗斯^2^0^2^0!20050220030000^法甲^朗斯^南特^2^0^1^0!20040927030000^法甲^南特^朗斯^1^0^0^0!20040111030000^法甲^朗斯^南特^0^0^0^0$$20111025023000^法乙^博莱格尼^南特^2^1^输!20111015022000^法乙^南特^伊斯特^3^1^赢!20111001203000^法乙^勒阿弗尔^南特^1^1^输!20110925230000^法乙^南特^克莱蒙特^1^0^赢!20110921020000^法乙^梅斯^南特^1^3^赢!20110917020000^法乙^沙托鲁^南特^2^2^输!20110910022000^法乙^南特^勒芒^1^1^走!20110901020000^法联杯^色当^南特^2^0^输!20110827203000^法乙^图尔斯^南特^2^1^输!20110823023000^法乙^南特^甘冈^4^0^赢$$20111026024500^法联杯^马赛^朗斯^4^0^输!20111022020000^法乙^朗斯^甘冈^0^2^输!20111015203000^法乙^巴斯蒂亚^朗斯^2^2^输!20111001020000^法乙^朗斯^拉瓦尔^0^0^输!20110924203000^法乙^阿尔勒^朗斯^3^0^输!20110921020000^法乙^朗斯^安格斯^0^0^输!20110917022000^法乙^朗斯^博莱格尼^2^0^赢!20110913023000^法乙^亚眠^朗斯^1^2^赢!20110902020000^法联杯^朗斯^伊维恩^1^0^赢!20110830023000^法乙^朗斯^摩纳哥^2^2^输$$20111106020000^法乙^特鲁瓦^南特^5!20111126030000^法乙^南特^摩纳哥^25!20111203030000^法乙^兰斯^南特^32$$20111108033000^法乙^朗斯^色当^7!20111126030000^法乙^勒芒^朗斯^25!20111203030000^法乙^朗斯^图尔斯^32$$";
	analysisManager.readData(data);
	console.log("homePointsArray = " + analysisManager.homePointsArray);
	console.log("awayPointsArray " + analysisManager.awayPointsArray);
	console.log("headtoheadArray = " + analysisManager.headtoheadArray);
	console.log("recordArray " + analysisManager.homeRecordArray);
	console.log("recordArray " + analysisManager.awayRecordArray);
	console.log("near3gamesArray = " + analysisManager.homeNear3GamesArray);
	console.log("near3gamesArray = " + analysisManager.awayNear3GamesArray);
	console.log("recommendArray " + analysisManager.recommendArray);
	
	groupHeadtoHeadByYear(analysisManager.headtoheadArray);
}

//将对赛往绩按年份排列
function groupHeadtoHeadByYear(headtoheadArray){
    if (headtoheadArray == null || headtoheadArray.length == 0) {
        return;
    }
    else 
        if (headtoheadArray.length == 1) {
            var lastYear = headtoheadArray[0].time.substring(0, 4);
            var lastYearArray = new Array();
            var allYearArray = new Array();
            lastYearArray.push(headtoheadArray[0]);
            allYearArray.push(lastYearArray);
            return allYearArray;
        }
        else {
            var lastYear = headtoheadArray[0].time.substring(0, 4);
            var lastYearArray = new Array();
            var allYearArray = new Array();
            lastYearArray.push(headtoheadArray[0]);
            for (var i = 1; i < headtoheadArray.length; i++) {
                var year = headtoheadArray[i].time.substring(0, 4);
                if (lastYear == year) {
                    lastYearArray.push(headtoheadArray[i]);
                    if (i == headtoheadArray.length - 1) {
                        allYearArray.push(lastYearArray);
                    }
                }
                else {
                    allYearArray.push(lastYearArray);
                    lastYearArray = new Array();
                    lastYearArray.push(headtoheadArray[i]);
                    lastYear = year;
                }
            }
            return allYearArray;
        }
    
}

