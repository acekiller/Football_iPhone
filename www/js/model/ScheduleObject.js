

//define Schedule Model
function ScheduleObject(round, playingTime, simplifiedHomeTeamName, traditionalHomeTeamName, 
						simplifiedAwayTeamName, traditionalAwayTeamName, 
						state, homeTeamScore, awayTeamScore, homeTeamHalfScore, awayTeamHalfScore) {
	this.round = round;
	this.playingTime = playingTime;
	this.simplifiedHomeTeamName =simplifiedHomeTeamName;
	this.traditionalHomeTeamName = traditionalHomeTeamName;
	this.simplifiedAwayTeamName = simplifiedAwayTeamName;
	this.traditionalAwayTeamName = traditionalAwayTeamName;
	this.state = state;
	this.homeTeamScore = homeTeamScore;
	this.awayTeamScore = awayTeamScore;
	this.homeTeamHalfScore = homeTeamHalfScore;
	this.awayTeamHalfScore = awayTeamHalfScore;
}

ScheduleObject.prototype = {
	constructor : ScheduleObject
};


