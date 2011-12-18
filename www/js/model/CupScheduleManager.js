// constants
// segments 
var CUPSCHEDUEL_SEGMENT_GROUP = 0;
var CUPSCHEDUEL_SEGMENT_POINTS = 1;
var CUPSCHEDUEL_SEGMENT_RESULT = 2;
var CUPSCHEDUEL_SEGMENT_COUNT = 3;

//for CupGroupObject
var CUPGROUP_FIELD_ID = 0;
var CUPGROUP_FIELD_NAME = 1;
var CUPGROUP_FIELD_ISCURRENT = 2;
var CUPGROUP_FIELD_COUNT= 3;

//for CupPointsObject
var CUPPOINTS_FIELD_RANK = 0;
var CUPPOINTS_FIELD_TEAMID = 1;
var CUPPOINTS_FIELD_COLOR = 2;
var CUPPOINTS_FIELD_STEAMNAME = 3;
var CUPPOINTS_FIELD_TTEAMNAME = 4;
var CUPPOINTS_FIELD_ETEAMNAME = 5;
var CUPPOINTS_FIELD_MATCHES = 6;
var CUPPOINTS_FIELD_WIN = 7;
var CUPPOINTS_FIELD_DRAW = 8;
var CUPPOINTS_FIELD_LOSE = 9;
var CUPPOINTS_FIELD_SCORE = 10;
var CUPPOINTS_FIELD_SCOREAGAINST = 11;
var CUPPOINTS_FIELD_SCOREEARN = 12;
var CUPPOINTS_FIELD_POINTS = 13;
var CUPPOINTS_FIELD_COUNT = 14;

//for CupScheduelResultObject
var CUPRESULT_FIELD_FENZU = 0;
var CUPRESULT_FIELD_MATCHTIME = 1;
var CUPRESULT_FIELD_SHOMENAME = 2;
var CUPRESULT_FIELD_THOMENAME = 3;
var CUPRESULT_FIELD_SAWAYNAME = 4;
var CUPRESULT_FIELD_TAWAYNAME = 5;
var CUPRESULT_FIELD_STATE = 6;
var CUPRESULT_FIELD_HOMESCORE = 7;
var CUPRESULT_FIELD_HOMEHALFSCORE = 8;
var CUPRESULT_FIELD_AWAYSCORE = 9;
var CUPRESULT_FIELD_AWAYHALFSCORE = 10;
var CUPRESULT_FIELD_COUNT = 11;


function CupScheduleManager(url){
	this.url = url;
	this.groupArray = null;
	this.pointsGroupNameArray = null;
	this.pointsArray = null;
	this.CupFenzuPointsArray = null;
	
	this.matchResultArray = null;
	this.CupFenzuResultArray = null;
}

CupScheduleManager.prototype = {
		constructor : CupScheduleManager,
		
		readData: function(inputString){
	
			this.groupArray = null;
			
			this.pointsGroupNameArray = null;
			this.pointsArray = null;
			this.CupFenzuPointsArray = null;
			
			this.matchResultArray = null;
			this.CupFenzuResultArray = null;
		
			var segmentArray = parseRequestStringWithSegment(inputString);
			if (segmentArray == null) 
				return false;
				
			if (segmentArray.length < CUPSCHEDUEL_SEGMENT_COUNT){
				console.log("error, readData for cupSchedule, but segment count not enough " + segmentArray.length);
				return false;
			}
		
			// init data again
			this.groupArray = new Array();
			
			this.pointsGroupNameArray = new Array();
			this.pointsArray = new Array();
			this.CupFenzuPointsArray = new Array();
			
			this.matchResultArray = new Array();
			this.CupFenzuResultArray = new Array();
			
			
			// set data into group array
			var segArray1 = segmentArray[CUPSCHEDUEL_SEGMENT_GROUP];
			for (var i=0; i<segArray1.length; i++){
				var record = segArray1[i];
				if (record != null && record.length >= CUPGROUP_FIELD_COUNT){
					var obj = new CupGroupObject(record[CUPGROUP_FIELD_ID],
							record[CUPGROUP_FIELD_NAME],
							record[CUPGROUP_FIELD_ISCURRENT]);								
		
					this.groupArray.push(obj);
				}
				else{
					console.log("warning, read cup group data but field count not enough, i="+i+", field count = "+record.length);
				}
			}
						
			// set data into cup points array
			var segArray2 = segmentArray[CUPSCHEDUEL_SEGMENT_POINTS];
			var groupName = null;
			
			for (var i=0; i<segArray2.length; i++){
				var record = segArray2[i];
				if (record != null && record.length == 1){
					this.pointsGroupNameArray.push(record);
					
					if(this.pointsArray !=null && this.pointsArray.length > 0 && groupName != null) {
						var fenzu = new CupFenzuPointsObject(groupName,  this.pointsArray);
						this.CupFenzuPointsArray.push(fenzu);
						this.pointsArray = new Array();
					}
					groupName = record;	
				}
				else if (record != null && record.length >= CUPPOINTS_FIELD_COUNT){
					var obj = new CupPointsObject(record[CUPPOINTS_FIELD_RANK],
							record[CUPPOINTS_FIELD_TEAMID],record[CUPPOINTS_FIELD_COLOR],
							record[CUPPOINTS_FIELD_STEAMNAME],record[CUPPOINTS_FIELD_TTEAMNAME],
							record[CUPPOINTS_FIELD_ETEAMNAME],record[CUPPOINTS_FIELD_MATCHES],
							record[CUPPOINTS_FIELD_WIN],record[CUPPOINTS_FIELD_DRAW],
							record[CUPPOINTS_FIELD_LOSE],record[CUPPOINTS_FIELD_SCORE],
							record[CUPPOINTS_FIELD_SCOREAGAINST],record[CUPPOINTS_FIELD_SCOREEARN],
							record[CUPPOINTS_FIELD_POINTS]);
		
					this.pointsArray.push(obj);
				}
				else{
//					console.log("warning, read cup points data but field count not enough, i="+i+", field count = "+record.length);
					var fenzu = new CupFenzuPointsObject(groupName,  this.pointsArray);
					this.CupFenzuPointsArray.push(fenzu);
					this.pointsArray = new Array();
				}
				
			}
			console.log("cup  pointsfenzu number: " + this.CupFenzuPointsArray.length);
			
			
			// set data into matchResultArray 
			var segArray3 = segmentArray[CUPSCHEDUEL_SEGMENT_RESULT];
			var fenzuName = null;
			var fenzu = new Array();
			for (var i=0; i<segArray3.length; i++){
				var record = segArray3[i];
				if (record != null && record.length >= CUPRESULT_FIELD_COUNT){
					var obj = new CupScheduelResultObject(record[CUPRESULT_FIELD_FENZU],
							record[CUPRESULT_FIELD_MATCHTIME],record[CUPRESULT_FIELD_SHOMENAME],
							record[CUPRESULT_FIELD_THOMENAME],record[CUPRESULT_FIELD_SAWAYNAME],
							record[CUPRESULT_FIELD_TAWAYNAME],record[CUPRESULT_FIELD_STATE],
							record[CUPRESULT_FIELD_HOMESCORE],record[CUPRESULT_FIELD_HOMEHALFSCORE],
							record[CUPRESULT_FIELD_AWAYSCORE],record[CUPRESULT_FIELD_AWAYHALFSCORE]);
					if (record[CUPRESULT_FIELD_FENZU] != "") {
						if (fenzuName != null && record[CUPRESULT_FIELD_FENZU] != fenzuName) {
							// put fenzu into this.CupFenzuResultArray
							this.CupFenzuResultArray.push(fenzu);
							var fenzu = new Array();
						}
						fenzu.push(obj);
						fenzuName = record[CUPRESULT_FIELD_FENZU];
					}
					
					//last fenzu into this.CupFenzuResultArray
					if(i == segArray3.length-1) {
						this.CupFenzuResultArray.push(fenzu);
					}
					
					this.matchResultArray.push(obj);
				}
				else{
					console.log("warning, read cupScheduleResult data but field count not enough, i="+i+", field count = "+record.length);
				}
			}
			for (var i=0; i<this.CupFenzuResultArray.length; i++){
				console.log(this.CupFenzuResultArray[i].length);
			}
				
									
			return this.groupArray;
		},
		
		clearData : function() {
			this.groupArray = null;
			this.pointsArray = null;
			this.pointsGroupNameArray = null;
			this.matchResultArray = null;
		},
		
		requestDataFromServer : function(leagueId, season, groupId, lang){
			this.clearData();
			
			var data = sendRequest(this.url + "id=" + leagueId + "&season=" +  season + "&groupid=" + groupId);
			if (data == null)
				return false;
				
			this.readData(data);
			return true;
		}
	};