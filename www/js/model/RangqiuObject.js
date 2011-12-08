
//define Rangqiu Model
function RangqiuObject(rank, teamId, simplifiedTeamName, traditionalTeamName, matches, up, draw, down, win, zou, lose, scoreEarn ) {
	this.rank = rank;
	this.teamId = teamId;
	this.simplifiedTeamName =simplifiedTeamName;
	this.traditionalTeamName = traditionalTeamName;
	this.matches = matches;
	this.up = up;
	this.draw = draw;
	this.down = down;
	this.win = win;
	this.zou = zou;
	this.lose = lose;
	this.scoreEarn = scoreEarn;
}

RangqiuObject.prototype = {
	constructor : RangqiuObject
};


