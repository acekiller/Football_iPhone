
//define Scorer Model
function ScorerObject(rank, simplifiedScorerName, traditionalScorerName, country, 
		simplifiedTeamName, traditionalTeamName, scoreCount, homeScoreCount, awayScoreCount) {
	this.rank = rank;
	this.simplifiedScorerName = simplifiedScorerName;
	this.traditionalScorerName =traditionalScorerName;
	this.country = country;
	this.simplifiedTeamName = simplifiedTeamName;
	this.traditionalTeamName = traditionalTeamName;
	this.scoreCount = scoreCount;
	this.homeScoreCount = homeScoreCount;
	this.awayScoreCount = awayScoreCount;
}

ScorerObject.prototype = {
	constructor : ScorerObject
};


