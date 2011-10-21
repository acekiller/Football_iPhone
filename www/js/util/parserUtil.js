

// constants
var SEGMENT_SEP = "$$";
var RECORD_SEP = "!";
var FIELD_SEP  = "^";

var GoalCn =["平手","平手/半球","半球","半球/一球","一球","一球/球半","球半","球半/两球","两球","两球/两球半","两球半","两球半/三球","三球","三球/三球半","三球半","三球半/四球","四球","四球/四球半","四球半","四球半/五球","五球","五球/五球半","五球半","五球半/六球","六球","六球/六球半","六球半","六球半/七球","七球","七球/七球半","七球半","七球半/八球","八球","八球/八球半","八球半","八球半/九球","九球","九球/九球半","九球半","九球半/十球","十球"];

var Goal =["0","0/0.5","0.5","0。5/1","1","1/1.5","1.5","1.5/2","2","2/2.5","2.5","2.5/3","3","3/3.5","3.5","3.5/4","4","4/4.5","4.5","4.5/5","5","5/5.5","5.5","5.5/6","6","6/6.5","6.5","6.5/7","7","7/7.5","7.5","7.5/8","8","8/8.5","8.5","8.5/9","9","9/9.5","9.5","9.5/10","10"];

function Goal2GoalCn(goal) {
	var Goal2GoalCn = "";
	if (goal == null || goal.length == 0) {
		return "";
	}
	if (goal >= 0) {
		Goal2GoalCn = GoalCn[goal * 4];
	} else {
		Goal2GoalCn = "受" + GoalCn[(-goal) * 4];
	}
	return Goal2GoalCn;
	console.log("ParseGoal2GoalCn, result = " + Goal2GoalCn);
}

function Goal2Goals(goal) {
	var Goal2Goals = "";
	if (goal == null || goal.length == 0) {
		return "";
	}
	if (goal >= 0) {
		Goal2Goals = Goal[goal * 4];
	} else {
		Goal2Goals = Goal[(-goal) * 4];
	}
	console.log("ParseGoal2Goals, result = " + Goal2Goals);
	return Goal2Goals;
}

// return array of array
function parseRequestString(inputString){
	
	if (inputString == null)
		return null;

//	console.log(inputString);
	
	var retArray = new Array();		
	var recordArray = inputString.split(RECORD_SEP);			
	for (var i=0; i<recordArray.length; i++){
		var record = recordArray[i];
		var fieldsArray = record.split(FIELD_SEP);
//		console.log(fieldsArray);
		retArray.push(fieldsArray);
	}

	return retArray;	
}

// return array of array
function parseRequestStringWithSegment(inputString){
	
	if (inputString == null)
		return null;
	
	var retArray = new Array();				
	var segmentArray = inputString.split(SEGMENT_SEP);					
	for (var i=0; i<segmentArray.length; i++){
		var segmentString = segmentArray[i];
		var recordArray = parseRequestString(segmentString);
		console.log("parseRequestStringWithSegment, seg = "+recordArray);
		retArray.push(recordArray);
	}

	// log for test
	console.log("parseRequestStringWithSegment, result = " + retArray);	
	return retArray;	
}


