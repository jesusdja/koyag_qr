import 'dart:convert';
import 'dart:io';
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

  Future<http.Response> httpCerrarSesion() async{
    var response;
    try{
      String token  = await obtenerToken();
      String url = 'https://koyangdev.koyag.com/auth/logout';
      response = await http.post(url,headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    }catch(ex){
      print(ex.toString());
    }
    return response;
  }

  Future<http.Response> httpVerificarQR(String qr) async{
    var response;

    try{
      String token  = await obtenerToken();
      Map<String, String> requestHeaders = {
        'Authorization': '$token'
      };
      response = await http.get(qr,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"}
      );
    }catch(e){
      print(e.toString());
    }

    return response;
  }

  Future<http.Response> httpListarUser() async{
    var response;

    try{
      String url = 'https://koyangdev.koyag.com/8df4fdfc/app';
      String token  = await obtenerToken();
      response = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"}
      );
    }catch(e){
      print(e.toString());
    }

    return response;
  }

  Future<http.Response> httpBuscarUser(String id) async{
    var response;

    try{
      String url = 'https://koyangdev.koyag.com/8df4fdfc/app/participant?u_uid=$id';
      String token  = await obtenerToken();
      response = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"}
      );
    }catch(e){
      print(e.toString());
    }

    return response;
  }



}