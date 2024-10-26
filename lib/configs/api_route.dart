//Main HOST
String baseUrl = "https://crd.atin.vn";

//URI
//GET
String uriGetCamera = "/Service/api/Device";
String uriGetCheckPoint = "/Service/api/checkPoint?page=1&itemsPerPage=999";
String uriGetLane = "/Service/api/lane";
String uriGetCameraFunction = "/Service/api/camera-function";
String uriGetBlackList = "/Service/api/plate-in-blacklist";

//POST
String uriPostSeal = "/api/v1/recognize/seal";

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

//URL

//AUTH
String urlAuth = "$baseUrl$uriAuth";

//DATA
String urlGetCamera = "$baseUrl$uriGetCamera";
String urlGetCheckPoint = "$baseUrl$uriGetCheckPoint";
String urlGetLane = "$baseUrl$uriGetLane";
String urlGetCameraFunction = "$baseUrl$uriGetCameraFunction";
String urlGetBlackList = "$baseUrl$uriGetBlackList";

//FILE SERVICE
String urlFileService = "$baseUrl/Service/files";
