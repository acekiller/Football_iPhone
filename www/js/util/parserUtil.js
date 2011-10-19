

// constants
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

	// release objects
	recordArray = null;	
	return retArray;	
}


