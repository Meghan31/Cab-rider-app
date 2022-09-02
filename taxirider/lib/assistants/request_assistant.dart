import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(Uri url) async {
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String jSondata = response.body;
        var decodedData = jSondata;
        return decodedData;
      } else {
        print(response.statusCode);
        return "failed";
      }
    } catch (e) {
      print(e);
      return "failed";
    }
  }
}
