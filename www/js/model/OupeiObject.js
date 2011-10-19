
// define Oupei Model
function OupeiObject(name, chupanWin, chupanDraw, chupanLost, jishiWin, jishiDraw, jishiLost){
	this.name = name;
	this.chupanWin = chupanWin;
	this.chupanDraw = chupanDraw;
	this.chupanLost = chupanLost;	
	this.jishiWin = jishiWin;
	this.jishiDraw = jishiDraw;
	this.jishiLost = jishiLost;
}

OupeiObject.prototype = {
	constructor : OupeiObject,
	displayName : function(){
		alert(this.name);
	}	
};

// define Oupei Statistic Model
function OupeiStatObject(){

	this.chupanWinMax = Number.MIN_VALUE;
	this.chupanDrawMax = Number.MIN_VALUE;
	this.chupanLostMax = Number.MIN_VALUE;	
	this.jishiWinMax = Number.MIN_VALUE;
	this.jishiDrawMax = Number.MIN_VALUE;
	this.jishiLostMax = Number.MIN_VALUE;
	
	this.chupanWinMin = Number.MAX_VALUE;
	this.chupanDrawMin = Number.MAX_VALUE;
	this.chupanLostMin = Number.MAX_VALUE;	
	this.jishiWinMin = Number.MAX_VALUE;
	this.jishiDrawMin = Number.MAX_VALUE;
	this.jishiLostMin = Number.MAX_VALUE;
	
	this.chupanWinAvg = 0.0;
	this.chupanDrawAvg = 0.0;
	this.chupanLostAvg = 0.0;	
	this.jishiWinAvg = 0.0;
	this.jishiDrawAvg = 0.0;
	this.jishiLostAvg = 0.0;		
	
	this.chupanWinTotal = 0.0;
	this.chupanDrawTotal = 0.0;
	this.chupanLostTotal = 0.0;	
	this.jishiWinTotal = 0.0;
	this.jishiDrawTotal = 0.0;
	this.jishiLostTotal = 0.0;		

	this.count = 0;	
}

OupeiStatObject.prototype = {
	constructor : OupeiStatObject,	
	updateStat : function(oupeiObject){
		
		// calc MAX
		if (oupeiObject.chupanWin >= this.chupanWinMax)
			this.chupanWinMax = oupeiObject.chupanWin;
			
		if (oupeiObject.chupanDraw >= this.chupanDrawMax)
			this.chupanDrawMax = oupeiObject.chupanDraw;

		if (oupeiObject.chupanLost >= this.chupanLostMax)
			this.chupanLostMax = oupeiObject.chupanLost;

		if (oupeiObject.jishiWin >= this.jishiWinMax)
			this.jishiWinMax = oupeiObject.jishiWin;
			
		if (oupeiObject.jishiDraw >= this.jishiDrawMax)
			this.jishiDrawMax = oupeiObject.jishiDraw;

		if (oupeiObject.jishiLost >= this.jishiLostMax)
			this.jishiLostMax = oupeiObject.jishiLost;
		
		// calculate MIN
		if (oupeiObject.chupanWin <= this.chupanWinMin)
			this.chupanWinMin = oupeiObject.chupanWin;
			
		if (oupeiObject.chupanDraw <= this.chupanDrawMin)
			this.chupanDrawMin = oupeiObject.chupanDraw;

		if (oupeiObject.chupanLost <= this.chupanLostMin)
			this.chupanLostMin = oupeiObject.chupanLost;

		if (oupeiObject.jishiWin <= this.jishiWinMin)
			this.jishiWinMin = oupeiObject.jishiWin;
			
		if (oupeiObject.jishiDraw <= this.jishiDrawMin)
			this.jishiDrawMin = oupeiObject.jishiDraw;

		if (oupeiObject.jishiLost <= this.jishiLostMin)
			this.jishiLostMin = oupeiObject.jishiLost;
						
		// calc AVG / TOTAL
		this.count += 1;		
		
		this.chupanWinTotal += parseFloat(oupeiObject.chupanWin);
		this.chupanDrawTotal += parseFloat(oupeiObject.chupanDraw);
		this.chupanLostTotal +=  parseFloat(oupeiObject.chupanLost);
		this.jishiWinTotal += parseFloat(oupeiObject.jishiWin);
		this.jishiDrawTotal += parseFloat(oupeiObject.jishiDraw);
		this.jishiLostTotal +=  parseFloat(oupeiObject.jishiLost);
		
		this.chupanWinAvg = (this.chupanWinTotal / this.count).toFixed(2);
		this.chupanDrawAvg = (this.chupanDrawTotal / this.count).toFixed(2);
		this.chupanLostAvg =  (this.chupanLostTotal / this.count).toFixed(2);
		this.jishiWinAvg = (this.jishiWinTotal / this.count).toFixed(2);
		this.jishiDrawAvg = (this.jishiDrawTotal / this.count).toFixed(2);
		this.jishiLostAvg =  (this.jishiLostTotal / this.count).toFixed(2);							
	}
};

