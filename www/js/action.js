
//杯赛
function fenzuAction(obj) {
	var subtable = document.getElementById('table_cupGroupPoints'+obj);
    subtable.style.display = subtable.style.display == 'none' ? 'block' : 'none';
    
    var title = document.getElementById('groupPointsTitle'+obj);
	if (subtable.style.display == 'none') {
		title.style.background ='url(images/fx_title.png)';
	} else {
		title.style.background ='url(images/fx_title_2.png)';
	}
	
	addNoDataTips(subtable);
}

function resultAction(obj) {
	var subtable = document.getElementById('table_result'+obj);
    subtable.style.display = subtable.style.display == 'none' ? 'block' : 'none';
    var title = document.getElementById('groupResultTitle'+obj);
	if (subtable.style.display == 'none') {
		title.style.background ='url(images/fx_title.png)';
	} else {
		title.style.background ='url(images/fx_title_2.png)';
	}
	
	addNoDataTips(subtable);
}

//分析

function pointsAction() {
	var subtable = document.getElementById('table_points');
    subtable.style.display = subtable.style.display == 'none' ? 'block' : 'none';
    
    obj = document.getElementById('pointsRankTitle');
	if (subtable.style.display == 'none') {
		obj.style.background ='url(images/fx_title.png)';
	} else {
		obj.style.background ='url(images/fx_title_2.png)';
	}
	
	var pointsRankData = document.getElementById('pointsRankData');
	var html = '<div style = "height:30px"><span style = "margin-left: 120px;">暂无相关数据</span></div>';
	if(pointsRankData==null || pointsRankData==""){
		subtable.innerHTML = html;
	}
	
}

function headtoheadActoin() {
	var subtable = document.getElementById('table_headtohead');
    subtable.style.display = subtable.style.display == 'none' ? 'block' : 'none';
    
    var obj = document.getElementById('headtoheadTitle');
	if (subtable.style.display == 'none') {
		obj.style.background ='url(images/fx_title.png)';
	} else {
		obj.style.background ='url(images/fx_title_2.png)';
	}
	
	var headData = document.getElementById('headData');
	var html = '<div style = "height:30px"><span style = "margin-left: 120px;">暂无相关数据</span></div>';
	if(headData==null || headData==""){
		subtable.innerHTML = html;
	}
}

function recordsAction() {
	var subtable = document.getElementById('table_records');
    subtable.style.display = subtable.style.display == 'none' ? 'block' : 'none';
    
    var obj = document.getElementById('recordsTitle');
	if (subtable.style.display == 'none') {
		obj.style.background ='url(images/fx_title.png)';
	} else {
		obj.style.background ='url(images/fx_title_2.png)';
	}
	
	var recordsData = document.getElementById('recordsData');
	var html = '<div style = "height:30px"><span style = "margin-left: 120px;">暂无相关数据</span></div>';
	if(recordsData==null || recordsData==""){
		subtable.innerHTML = html;
	}
}

function near3gamesAction() {
	var subtable = document.getElementById('table_near3games');
    subtable.style.display = subtable.style.display == 'none' ? 'block' : 'none';
    
    var obj = document.getElementById('near3gamesTitle');
	if (subtable.style.display == 'none') {
		obj.style.background ='url(images/fx_title.png)';
	} else {
		obj.style.background ='url(images/fx_title_2.png)';
	}
	
	var Near3GamesData = document.getElementById('Near3GamesData');
	var html = '<div style = "height:30px"><span style = "margin-left: 120px;">暂无相关数据</span></div>';
	if(Near3GamesData==null || v==""){
		subtable.innerHTML = html;
	}
	
}

function recommendAction() {
	var subtable = document.getElementById('table_recommend');
    subtable.style.display = subtable.style.display == 'none' ? 'block' : 'none';
    
    obj = document.getElementById('recommendTitle'); 
	if (subtable.style.display == 'none') {
		obj.style.background ='url(images/fx_title.png)';
	} else {
		obj.style.background ='url(images/fx_title_2.png)';
	}
	
	addNoDataTips(subtable);
}

function addNoDataTips(obj){
	var v = obj.innerHTML.trim();
	var html = '<div style = "height:30px"><span style = "margin-left: 120px;">暂无相关数据</span></div>';
	if(v==null || v==""){
		obj.innerHTML = html;
	}
}


