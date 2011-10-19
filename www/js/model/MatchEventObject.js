
// define MatchEventObject Model
function MatchEventObject(homeAwayFlag, type, minutes, player){
	this.homeAwayFlag = homeAwayFlag;
	this.type = type;
	this.minutes = minutes;
	this.player = player;	
}

MatchEventObject.prototype = {
	constructor : MatchEventObject,
	toString : function(){
		return this.homeAwayFlag + ", " + this.type + ", " + this.minutes + ", " + this.player;
	}
};
