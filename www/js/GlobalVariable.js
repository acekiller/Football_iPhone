

// all remote request URL
var YAPEI_URL = "http://bf.bet007.com/phone/Handicap.aspx?ID=";
var OVERUNDER_URL = "http://bf.bet007.com/phone/OverUnder.aspx?ID=";
var LINEUP_URL = "http://bf.bet007.com/phone/Lineup.aspx?ID=";
var YAPEI_DETAIL_URL = "http://bf.bet007.com/phone/HandicapDetail.aspx?OddsID=";
var OVERUNDER_DETAIL_URL = "http://bf.bet007.com/phone/OverUnderDetail.aspx?OddsID=";
var MATCH_EVENT_URL = "http://bf.bet007.com/phone/ResultDetail.aspx?ID=";
var OUPEI_URL = "http://bf.bet007.com/phone/1x2.aspx?ID=";
var ANALYSIS_URL = "http://bf.bet007.com/phone/Analysis.aspx?ID=";

var TYPE_YAPEI = 0;
var TYPE_OVERUNDER = 1;

// current language
var language = 0;

// init all global objects
var oupeiManager = new OupeiManager(OUPEI_URL);
var yapeiCompanyManager = new BetCompanyManager(YAPEI_DETAIL_URL, TYPE_YAPEI);
var yapeiManager = new YapeiManager(YAPEI_URL, yapeiCompanyManager, TYPE_YAPEI);
var lineupManager = new LineupManager(LINEUP_URL);
var matchDetailManager = new MatchDetailManager(MATCH_EVENT_URL);
//var overunderManager = new OverunderManager(OVERUNDER_URL);
var overunderCompanyManager = new BetCompanyManager(OVERUNDER_DETAIL_URL, TYPE_OVERUNDER);
var overunderManager = new YapeiManager(OVERUNDER_URL, overunderCompanyManager, TYPE_OVERUNDER);
var analysisManager = new AnalysisManager(ANALYSIS_URL);
var matchService = new MatchService();
var loadingView = null;