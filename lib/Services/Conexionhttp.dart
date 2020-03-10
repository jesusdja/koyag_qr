import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:koyag_qr/utils/Globales.dart';

class conexionHttp{

  //**************
  //INICIAR SESION
  //**************
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
  //**************
  //CERRAR SESION
  //**************
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
  //**************
  //RECUPERAR CONTRASEÑA
  //**************
  Future<http.Response> httpRecuperarPass(String correo) async{
    var response;
    try{
      String url = 'https://koyangdev.koyag.com/auth/password/email?username=$correo';
      response = await http.post(url,);
    }catch(ex){
      print(ex.toString());
    }
    return response;
  }
  //**************
  //VERIFICAR QR
  //**************
  Future<http.Response> httpVerificarQR(String qr) async{
    var response;

    try{
      String token  = await obtenerToken();
      response = await http.get(qr,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"}
      );
    }catch(e){
      print(e.toString());
    }

    return response;
  }
  //**************
  //LISTAR TODOS LOS USUARIOS
  //**************
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
  //**************
  //BUSCAR USUARIO ESPECIFICO
  //**************
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