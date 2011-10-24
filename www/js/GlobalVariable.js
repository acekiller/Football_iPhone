
// init all global objects

var YAPEI_URL = "http://bf.bet007.com/phone/Handicap.aspx?ID=";
var OVERUNDER_URL = "http://bf.bet007.com/phone/OverUnder.aspx?ID=";

var language = 0;

var oupeiManager = new OupeiManager();
var yapeiManager = new YapeiManager(YAPEI_URL);
var yapeiCompanyManager = new BetCompanyManager();
var lineupManager = new LineupManager();
var matchDetailManager = new MatchDetailManager();
var overunderManager = new OverunderManager(OVERUNDER_URL);

var matchService = new MatchService();

