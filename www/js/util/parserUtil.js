

// constants
var SEGMENT_SEP = "$$";
var RECORD_SEP = "!";
var FIELD_SEP  = "^";

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


