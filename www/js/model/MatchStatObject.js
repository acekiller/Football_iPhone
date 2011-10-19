
// define MatchEventObject Model
function MatchStatObject(type, homeValue, awayValue){
	this.type = type;
	this.homeValue = homeValue;
	this.awayValue = awayValue;
}

MatchStatObject.prototype = {
	constructor : MatchStatObject,
	toString : function(){
		return this.type + ", " + this.homeValue + ", " + this.awayValue;
	}

};
