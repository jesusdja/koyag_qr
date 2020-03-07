


import 'package:shared_preferences/shared_preferences.dart';

Future<String> obtenerToken() async {
  SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();
  String token  = prefs.getString('koyagQRToken');
  return token;
}

sumarCredito(int cant) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('koyagQRCantAcreditados',cant);
}

