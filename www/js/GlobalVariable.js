

// all remote request URL
var YAPEI_URL = "http://bf.bet007.com/phone/Handicap.aspx?ID=";
var OVERUNDER_URL = "http://bf.bet007.com/phone/OverUnder.aspx?ID=";
var LINEUP_URL = "http://bf.bet007.com/phone/Lineup.aspx?ID=";

// current language
var language = 0;

// init all global objects
var oupeiManager = new OupeiManager();
var yapeiCompanyManager = new BetCompanyManager();
var yapeiManager = new YapeiManager(YAPEI_URL, yapeiCompanyManager);
var lineupManager = new LineupManager(LINEUP_URL);
var matchDetailManager = new MatchDetailManager();
//var overunderManager = new OverunderManager(OVERUNDER_URL);
var overunderCompanyManager = new BetCompanyManager();
var overunderManager = new YapeiManager(OVERUNDER_URL, overunderCompanyManager);

var matchService = new MatchService();

