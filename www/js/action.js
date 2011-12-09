
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
}

//分析

function pointsAction(obj) {
	var subtable = document.getElementById('table_points');
    subtable.style.display = subtable.style.display == 'none' ? 'block' : 'none';
	if (subtable.style.display == 'none') {
		obj.style.background ='url(images/fx_title.png)';
	} else {
		obj.style.background ='url(images/fx_title_2.png)';
	}
}

function headtoheadActoin(obj) {
	var subtable = document.getElementById('table_headtohead');
    subtable.style.display = subtable.style.display == 'none' ? 'block' : 'none';
	if (subtable.style.display == 'none') {
		obj.style.background ='url(images/fx_title.png)';
	} else {
		obj.style.background ='url(images/fx_title_2.png)';
	}
}

function recordsAction(obj) {
	var subtable = document.getElementById('table_records');
    subtable.style.display = subtable.style.display == 'none' ? 'block' : 'none';
	if (subtable.style.display == 'none') {
		obj.style.background ='url(images/fx_title.png)';
	} else {
		obj.style.background ='url(images/fx_title_2.png)';
	}
}

function near3gamesAction(obj) {
	var subtable = document.getElementById('table_near3games');
    subtable.style.display = subtable.style.display == 'none' ? 'block' : 'none';
	if (subtable.style.display == 'none') {
		obj.style.background ='url(images/fx_title.png)';
	} else {
		obj.style.background ='url(images/fx_title_2.png)';
	}
}

function recommendAction(obj) {
	var subtable = document.getElementById('table_recommend');
    subtable.style.display = subtable.style.display == 'none' ? 'block' : 'none';
	if (subtable.style.display == 'none') {
		obj.style.background ='url(images/fx_title.png)';
	} else {
		obj.style.background ='url(images/fx_title_2.png)';
	}
}


