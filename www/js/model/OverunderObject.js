
//define Overunder Model
function OverunderObject(name, overChupei, chupan, underChupei, overJishi, jishi, underJishi) {
	this.name = name;
	this.overChupei = overChupei;
	this.chupan = chupan;
	this.underChupei = underChupei;
	this.overJishi = overJishi;
	this.jishi = jishi;
	this.underJishi = underJishi;
}

OverunderObject.prototype = {
	constructor : OverunderObject
};
