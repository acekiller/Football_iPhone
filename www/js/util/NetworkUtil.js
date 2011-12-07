
function sendRequest(url){
	var xhr = new XMLHttpRequest();
	if (xhr == null)
		return null;
	
//	if (loadingView == null){
//		loadingView = new Ext.LoadMask(Ext.getBody(), {msg:"加载中..."});		
//	}
//	loadingView.show();
	console.log("send url = " + url);
	xhr.open("get", url, false);
	xhr.send(null);
	console.log("recv status = " + xhr.status + ", data = " + xhr.responseText);
//	loadingView.hide();
	if (xhr.status == 200) {
		return xhr.responseText;
	}
	else{
		return null;
	}
}