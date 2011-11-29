
//points(积分排名) model
function PointsObject(type, games, win, draw, lose, score, score_against, score_earn, points, rank, winning_ratio) {
	this.type = type;
	this.games = games;
	this.win = win;
	this.draw = draw;
	this.lose = lose;
	this.score = score;
	this.score_against = score_against;
	this.score_earn = score_earn;
	this.points = points;
	this.rank = rank;
	this.winning_ratio = winning_ratio;
};

PointsObject.prototype = {
	constructor : PointsObject
}; 


//headtohead(对赛往绩) model
function HeadToHeadObject(time, league, home, away, homePoints, awayPoints, homeHalfPoints, awayHalfPoints) {
	this.time = time;
	this.league = league;
	this.home = home;
	this.away = away;
	this.homePoints = homePoints;
	this.awayPoints = awayPoints;
	this.homeHalfPoints = homeHalfPoints;
	this.awayHalfPoints = awayHalfPoints;
};

HeadToHeadObject.prototype = {
	constructor : HeadToHeadObject
}; 

//record(战绩) model
function RecordObject(time, league, home, away, homePoints, awayPoints, odds) {
	this.time = time;
	this.league = league;
	this.home = home;
	this.away = away;
	this.homePoints = homePoints;
	this.awayPoints = awayPoints;
	this.odds = odds;
};

RecordObject.prototype = {
	constructor : RecordObject
}; 

//Near3Games(近3场比赛) model
function Near3GamesObject(time, league, home, away, offsetday) {
	this.time = time;
	this.league = league;
	this.home = home;
	this.away = away;
	this.offsetday = offsetday;
};

Near3GamesObject.prototype = {
	constructor : Near3GamesObject
}; 


//Recommend(心水推荐) model
function RecommendObject(home, homeTrend, homeOdds, away, awayTrend, awayOdds, analysis) {
	this.home = home;
	this.homeTrend = homeTrend;
	this.homeOdds = homeOdds;
	this.away = away;
	this.awayTrend = awayTrend;
	this.awayOdds = awayOdds;
	this.analysis = analysis;
};

RecommendObject.prototype = {
	constructor : RecommendObject
}; 