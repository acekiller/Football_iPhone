
function sendRequest(url){
	var xhr = new XMLHttpRequest();
	if (xhr == null)
		return null;
	
	xhr.open("get", url, false);
	xhr.send(null);
	if (xhr.status == 200) {
		return xhr.responseText;
	}
	else{
		return null;
	}
}