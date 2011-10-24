
//define Yapei Model
function BetCompanyObject(name, betId) {
	this.name = name;
	this.betId = betId;
}

BetCompanyObject.prototype = {
	constructor : BetCompanyObject
};

function OddsChangeObject(homeOdds, pankou, awayOdds, modifyDate) {
	this.homeOdds = homeOdds;
	this.pankou = pankou;
	this.awayOdds = awayOdds;
	this.modifyDate = modifyDate;
}

OddsChangeObject.prototype = {
	constructor : OddsChangeObject,
	
	getPankouText : function(){
		return Goal2GoalCn(parseFloat(this.pankou));	// TODO need implementation
	},
	
	getModifyDate : function(){
		return this.modifyDate; // TODO need implementation
	}
};