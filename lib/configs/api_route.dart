//Main HOST
// String baseUrl = "https://crd.atin.vn";
String baseUrl = "http://192.168.1.21:9962";

//URI
String uriGetEvent = "/api/v1/container-event";

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

//FILE SERVICE
String urlFileService = "https://crd.atin.vn/Service/files";
