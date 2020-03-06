import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:koyag_qr/utils/Globales.dart';

class conexionHttp{

  Future<http.Response> httpIniciarSesion(String correo, String pasw) async{
    var response;
    try{

      String url = 'https://koyangdev.koyag.com/auth/login?username=$correo&password=$pasw';
      response = await http.post(url,);

    }catch(ex){
      print(ex.toString());
    }
    return response;
  }


}