//Main HOST
String baseUrl = "https://crd.atin.vn";

//URI
String uriGetEvent = "/Service/api/historyInOutAreaPort";
String uriGetImageVideoInOut = "/Service/api/imageVideoInOut";

//auth
String uriAuth = "/Service/api/token/auth";
Map<String, String> bodyAuth = {
  "grant_type": "password",
  "client_id": "EPS",
  "client_secret": "b0udcdl8k80cqiyt63uq",
  "username": "",
  "password": ""
};

Map<String, String> bodyRefreshToken = {
  "grant_type": "refresh_token",
  "client_id": "EPS",
  "client_secret": "b0udcdl8k80cqiyt63uq",
  "refresh_token": "",
};

//AUTH
String urlAuth = "$baseUrl$uriAuth";

//DATA
String urlGetEvent = "$baseUrl$uriGetEvent";
String urlGetImageVideoInOut = "$baseUrl$uriGetImageVideoInOut";

//FILE SERVICE
String urlFileService = "$baseUrl/Service/files";
