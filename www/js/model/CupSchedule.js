
//define CupGroup Model
function CupGroupObject(groupId,groupName,isCurrent) {
	
	this.groupId = groupId;
	this.groupName = groupName;
	this.isCurrent = isCurrent;
}

CupGroupObject.prototype = {
	constructor : CupGroupObject
};

function CupPointsObject(rank,teamId,color,simplifiedTeamName,englishTeamName,traditionalTeamName,
						matches,win,draw,lose,score,scoreAgainst,scoreEarn,points){
	this.rank = rank;
	this.teamId = teamId;
	this.color = color;
	this.simplifiedTeamName = simplifiedTeamName;
	this.englishTeamName = englishTeamName;
	this.traditionalTeamName = traditionalTeamName;
	this.matches = matches;
	this.win = win;
	this.draw = draw;
	this.lose = lose;
	this.score = score;
	this.scoreAgainst = scoreAgainst;
	this.scoreEarn = scoreEarn;
	this.points = points;
}

CupPointsObject.prototype = {
	constructor : CupPointsObject
};

function CupFenzuPointsObject(CupGroupName,  CupPointsArray){
	this.CupGroupName = CupGroupName;
	this.CupPointsArray = CupPointsArray;
}

CupFenzuPointsObject.prototype = {
		constructor : CupFenzuPointsObject
	};


function CupScheduelResultObject(fenzu,matchTime,simplifiedHomeName,traditionalHomeName,simplifiedAwayName,traditionalAwayName,
									state,homeScore,awayScore,homeHalfScore,awayHalfScore){
	this.fenzu = fenzu;
	this.matchTime = matchTime;
	this.simplifiedHomeName = simplifiedHomeName;
	this.traditionalHomeName = traditionalHomeName;
	this.simplifiedAwayName = simplifiedAwayName;
	this.traditionalAwayName = traditionalAwayName;
	this.state = state;
	this.homeScore = homeScore;
	this.awayScore = awayScore;
	this.homeHalfScore = homeHalfScore;
	this.awayHalfScore = awayHalfScore;	
}

CupScheduelResultObject.prototype = {
	constructor	 : CupScheduelResultObject
};