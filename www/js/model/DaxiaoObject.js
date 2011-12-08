
//define Daxiao Model
function DaxiaoObject(rank, teamId, simplifiedTeamName, traditionalTeamName, matches, big, zou, small, daqiulv, zoulv, xiaoqiulv ) {
	this.rank = rank;
	this.teamId = teamId;
	this.simplifiedTeamName =simplifiedTeamName;
	this.traditionalTeamName = traditionalTeamName;
	this.matches = matches;
	this.big = big;
	this.zou = zou;
	this.small = small;
	this.daqiulv = daqiulv;
	this.zoulv = zoulv;
	this.xiaoqiulv = xiaoqiulv;
}

DaxiaoObject.prototype = {
	constructor : DaxiaoObject
};


