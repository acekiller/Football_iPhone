
//define Points Model
function JifenObject(rank, teamId, simplifiedTeamName, traditionalTeamName, matches, win, draw, lose, goals, goalsAgainst, points, remark ) {
	this.rank = rank;
	this.teamId = teamId;
	this.simplifiedTeamName =simplifiedTeamName;
	this.traditionalTeamName = traditionalTeamName;
	this.matches = matches;
	this.win = win;
	this.draw = draw;
	this.lose = lose;
	this.goals = goals;
	this.goalsAgainst = goalsAgainst;
	this.points = points;
	this.remark = remark;
	
	
}

JifenObject.prototype = {
	constructor : JifenObject
};


