import 'package:flutter/cupertino.dart';

double deviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

String apiUrl = 'https://dev-tik.unsri.ac.id/api/v1';

String loginRoute = '$apiUrl/login';
String logoutRoute = '$apiUrl/logout';
