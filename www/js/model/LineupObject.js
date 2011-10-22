
//define lineup Model
function LineupObject(homeLineup,homeReserve,awayLineup,awayReserve){
	this.homeLineup = homeLineup;
	this.homeReserve = homeReserve;
	this.awayLineup = awayLineup;
	this.awayReserve = awayReserve;
}

LineupObject.prototype = {
	constructor : LineupObject
};
