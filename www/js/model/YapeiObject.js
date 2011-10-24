
//define Yapei Model
function YapeiObject(betCompanyId, name, homeChupei, chupan, awayChupei, homeJishi, jishi, awayJishi) {
	
	this.betCompanyId = betCompanyId;
	this.name = name;
	this.homeChupei = homeChupei;
	this.chupan = chupan;
	this.awayChupei = awayChupei;
	this.homeJishi = homeJishi;
	this.jishi = jishi;
	this.awayJishi = awayJishi;
}

YapeiObject.prototype = {
	constructor : YapeiObject
};


