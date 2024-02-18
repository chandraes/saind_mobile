import 'dart:convert';

import 'constant.dart';
import 'package:http/http.dart' as http;

class API {
  postRequest({
    required String route,
    required Map<String, String> data,
  }) async {
    String url = apiUrl + route;
    print(url);
    try {
      return await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: _header(),
      );
    } catch (e) {
      print(e.toString());
      return jsonEncode(e);
    }
  }

  _header() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}