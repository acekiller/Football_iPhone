
function sendRequest(url){
	var xhr = new XMLHttpRequest();
	if (xhr == null)
		return null;
	
	console.log("send url = " + url);
	xhr.open("get", url, false);
	xhr.send(null);
	console.log("recv status = " + xhr.status + ", data = " + xhr.responseText);
	if (xhr.status == 200) {
		return xhr.responseText;
	}
	else{
		return null;
	}
}