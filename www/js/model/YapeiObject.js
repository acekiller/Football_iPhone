
//define Yapei Model
function YapeiObject(name, homeChupei, chupan, awayChupei, homeJishi, jishi, awayJishi) {
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
