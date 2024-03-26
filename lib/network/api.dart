import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  final String _url = 'https://hydai_api.apperza.tech';

  auth(data, apiURL) async {
    var fullUrl = Uri.parse(_url + apiURL);
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiURL) async {
    var fullUrl = Uri.parse(_url + apiURL);
    return await http.get(
      fullUrl,
      headers: _setHeaders(),
    );
  }

  postData(apiURL, body) async {
    var fullUrl = Uri.parse(_url + apiURL);
    return await http.post(fullUrl,
        headers: _setHeaders(), body: jsonEncode(body));
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
