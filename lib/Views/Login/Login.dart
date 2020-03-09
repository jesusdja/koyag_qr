import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:koyag_qr/Services/Conexionhttp.dart';
import 'package:koyag_qr/Views/Home/Home.dart';
import 'package:koyag_qr/utils/Colores.dart';
import 'package:koyag_qr/utils/Validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'LoginLock.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  double alto = 0;
  double ancho = 0;
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  SharedPreferences prefs;
  bool block_pass = false;
  bool cargando =false;
  conexionHttp conexionHispanos = new conexionHttp();

  @override
  void initState() {
    inicializar();
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  @override
  dispose(){
    super.dispose();
  }

  inicializar() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> exit() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    alto = MediaQuery.of(context).size.height;
    ancho = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: exit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _contenido(),
      ),
    );
  }

  Widget _contenido(){
    return SafeArea(
      child: Container(
        width: ancho,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                width: ancho,
                height: alto * 0.3,
                margin: EdgeInsets.only(left: ancho * 0.4),
                child: FittedBox(
                  child: Image.asset('assets/curva.png'),
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                width: ancho,
                height: alto * 0.1,
                margin: EdgeInsets.only(left: ancho * 0.15,right: ancho * 0.15,top: alto * 0.15),
                child: FittedBox(
                  child: Image.asset('assets/logo_koyagQR.png'),
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                width: ancho,
                margin: EdgeInsets.only(top: alto * 0.28),
                child: Column(
                  children: <Widget>[
                    _titulo(),
                    SizedBox(height: alto * 0.06,),
                    _formulario(),
                    SizedBox(height: alto * 0.03,),
                    _terminos(),
                    SizedBox(height: alto * 0.03,),
                    cargando ? Container(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(colorPurple),
                      ),
                    ) : _buttonSumit(context),
                    SizedBox(height: alto * 0.03,),
                    _olvidePass(),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _olvidePass(){
    return Container(
      child: InkWell(
        child: Text('¿Olvidaste tu contraseña?',style: TextStyle(fontSize: 16,color: colorPurple),),
        onTap: (){
          Navigator.push(context, new MaterialPageRoute(
              builder: (BuildContext context) => new LoginBlock()));
        },
      ),
    );
  }

  Widget _buttonSumit(BuildContext context){
    return Container(
      width: ancho,
      margin: EdgeInsets.only(left: ancho * 0.05,right: ancho * 0.05),
      child: RaisedButton(
        color: colorPurple,
        child: Text('INICIAR SESIÓN',style: TextStyle(color: Colors.white),),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: colorPurple)
        ),
        onPressed: () async {
          cargando = true;
          setState(() {});

          if(formKey.currentState.validate()){
            if(!checkTerminos){
              _showAlert("Aceptar términos y condiciones de uso");
              cargando = false;
              setState(() {});
            }else{
              formKey.currentState.save();
              try{
//                email = 'julian@koyag.com';
//                password = '123123123';
                var response = await conexionHispanos.httpIniciarSesion(email,password);
                if(response.statusCode == 200){
                  var value = jsonDecode(response.body);
                  if(value['access_token'] != null){

                    await prefs.setInt('koyagQRLogin',1);
                    await prefs.setString('koyagQRToken','${value['access_token']}');

                    String idEvent = value['event'];
                    String nombre = value['events']['$idEvent'];

                    await prefs.setString('koyagQRNombreEvent','$nombre');

                    Navigator.push(context, new MaterialPageRoute(
                        builder: (BuildContext context) => new Home()));

                  }else{
                    String error = '${value['message']['username']} o ${value['message']['password']}';
                    _showAlert(error);
                    cargando = false;
                    setState(() {});
                  }
                }else{
                  String error = 'Datos incorrectos';
                  _showAlert(error);
                  cargando = false;
                  setState(() {});
                }
              }catch(e){
                print(e.toString());
                cargando = false;
                setState(() {});
              }
            }
          }else{
            cargando = false;
            setState(() {});
          }
        },
      ),
    );
  }

  _showAlert(String texto){
    Fluttertoast.showToast(
        msg: texto,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red[900],
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  bool checkTerminos = false;
  Widget _terminos(){
    return Container(
      width: ancho,
      margin: EdgeInsets.only(left: ancho * 0.03),
      child: Row(
        children: <Widget>[
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: checkTerminos,
              activeColor: colorPurple,
              onChanged: (bool value) {
                checkTerminos = value;
                setState(() {});
              },
            ),
          ),
          Text('Acepto los ',style: TextStyle(color: colorfooter),),
          InkWell(
            onTap: () async {
              try{
                const url = 'https://koyagmain.s3.amazonaws.com/Condiciones+y+Terminos+de+Uso+Koyag.pdf';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              }catch(e){
                print(e.toString());
              }
            },
            child: Text('Términos y condiciones de uso',style: TextStyle(color: colorPurple,decoration: TextDecoration.underline,),)
          ),
        ],
      ),
    );
  }

  Widget _formulario(){
    return Container(
      margin: EdgeInsets.only(left: ancho * 0.05,right: ancho * 0.05),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Container(
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Correo electrónico',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: colorBordeForm,
                      width: 1.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: colorBordeForm,
                      width: 1.0,
                    ),
                  ),
                  contentPadding:EdgeInsets.symmetric(horizontal: ancho * 0.05, vertical: alto * 0.026)
                ),
                onSaved: (value) => email = value,
                validator: (value) => Validator.validateEmail(value),
              ),
            ),
            SizedBox(height: alto * 0.04,),
            Container(
              child: TextFormField(
                keyboardType: TextInputType.text,
                obscureText: !block_pass,
                decoration: InputDecoration(
                    hintText: 'Contraseña',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: colorBordeForm,
                        width: 1.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: colorBordeForm,
                        width: 1.0,
                      ),
                    ),
                    contentPadding:EdgeInsets.symmetric(horizontal: ancho * 0.05, vertical: alto * 0.026),
                    suffixIcon: IconButton(
                      icon: !block_pass ? Icon(Icons.remove_red_eye,color: Colors.black,) : Icon(Icons.visibility_off,color: Colors.black),
                      onPressed: (){
                        block_pass = !block_pass;
                        setState(() {});
                      },
                    )
                ),
                onSaved: (value) => password = value,
                validator: (value) => Validator.validatePassword(value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titulo(){
    return Container(
      width: ancho * 0.7,
      child: Text('Inicia sesión y comienza la acreditación de los participantes de tu evento',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14,height: alto * 0.002,fontWeight: FontWeight.bold),),
    );
  }

}
