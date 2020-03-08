import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koyag_qr/Services/Conexionhttp.dart';
import 'package:koyag_qr/utils/Colores.dart';
import 'package:koyag_qr/utils/Validator.dart';

class LoginBlock extends StatefulWidget {
  @override
  _LoginBlockState createState() => _LoginBlockState();
}

class _LoginBlockState extends State<LoginBlock> {
  double alto = 0;
  double ancho = 0;
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool cargando = false;
  bool sendEmail = false;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
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
        body: _contenido(context),
      ),
    );
  }

  Widget _contenido(BuildContext contexto){
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
              _circuleBack(context),
              Container(
                width: ancho,
                margin: EdgeInsets.only(top: alto * 0.22,left: ancho * 0.08,right: ancho * 0.08),
                child: Column(
                  children: <Widget>[
                    sendEmail ? Container() : _titulo(),
                    sendEmail ? SizedBox(height: alto * 0,) : SizedBox(height: alto * 0.02,) ,
                    sendEmail ? Container() : _titulo2(),
                    sendEmail ? SizedBox(height: alto * 0,) : SizedBox(height: alto * 0.05,) ,
                    sendEmail ? Container() : _formulario(),
                    sendEmail ? SizedBox(height: alto * 0,) : SizedBox(height: alto * 0.05,) ,
                    sendEmail ? Container() : cargando ? _cargandoW() : _buttonSumit(contexto),
                    sendEmail ? _imagenEmailSend() : Container(),
                    sendEmail ? SizedBox(height: alto * 0.035,) : SizedBox(height: alto * 0,) ,
                    sendEmail ? _textoCorreoEnviado('Te hemos enviado tu nueva contraseña a:') : Container(),
                    sendEmail ? SizedBox(height: alto * 0.01,) : SizedBox(height: alto * 0,) ,
                    sendEmail ? _textoCorreoEnviado(email,negrita: FontWeight.bold) : Container(),
                    sendEmail ? SizedBox(height: alto * 0.03,) : SizedBox(height: alto * 0,) ,
                    sendEmail ? Divider(color: colorLine,thickness: 2,) : Container(),
                    SizedBox(height: alto * 0.02,),
                    _buttonBack(contexto),
                    SizedBox(height: alto * 0.05,),
                    _footer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _cargandoW(){
    return Container(
      //width: ancho,
      //margin: EdgeInsets.only(left: ancho * 0.05,right: ancho * 0.05),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(colorPurple),
      ),
    );
  }

  Widget _textoCorreoEnviado(String texto,{FontWeight negrita : FontWeight.normal}){
    return Text(texto,style: TextStyle(fontWeight: negrita,fontSize: 16),);
  }

  Widget _imagenEmailSend(){
    return Container(
      width: ancho * 0.3,
      height: alto * 0.12,
      //margin: EdgeInsets.only(left: ancho * 0.4),
      child: FittedBox(
        child: Image.asset('assets/mobile.png'),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _footer(){
    return Container(
      width: ancho,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Copyright © 2019 ',style: TextStyle(color: colorfooter,fontSize: alto * 0.02),),
          Text('EventVice',style: TextStyle(color: colorfooter,fontSize: alto * 0.02,fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }

  Widget _buttonBack(BuildContext context){
    return Container(
      width: ancho,
      margin: EdgeInsets.only(left: ancho * 0.05,right: ancho * 0.05),
      child: RaisedButton(
        color: Colors.white,
        child: Text('VOLVER',style: TextStyle(color: colorPurple,fontWeight: FontWeight.bold),),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: colorPurple)
        ),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),
    );
  }

  conexionHttp conexionHispanos = new conexionHttp();
  Widget _buttonSumit(BuildContext context){
    return Container(
      width: ancho,
      margin: EdgeInsets.only(left: ancho * 0.05,right: ancho * 0.05),
      child: RaisedButton(
        color: colorPurple,
        child: Text('CONTINUAR',style: TextStyle(color: Colors.white),),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: colorPurple)
        ),
        onPressed: () async {

          setState(() {
            cargando = true;
          });

          if(formKey.currentState.validate()){
            formKey.currentState.save();

            try{
              var response = await conexionHispanos.httpRecuperarPass(email);
              if(response.statusCode == 200){
                var value = jsonDecode(response.body);
                sendEmail = true;
                setState(() {});
              }else{
                setState(() {
                  cargando = false;
                });
              }
            }catch(e){
              setState(() {
                cargando = false;
              });
              print(e.toString());
            }
          }else{
            setState(() {
              cargando = false;
            });
          }
        },
      ),
    );
  }

  Widget _formulario(){
    return Container(
      child: Form(
        key: formKey,
        child: Container(
          child: Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0),side: BorderSide(color: colorBordeForm)),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'Correo electrónico',
                  border: InputBorder.none,
                  contentPadding:EdgeInsets.symmetric(horizontal: ancho * 0.05, vertical: alto * 0.022)
              ),
              onSaved: (value) => email = value,
              validator: (value) => Validator.validateEmail(value),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titulo2(){
    return Container(
      width: ancho,
      child: Text('Te enviaremos una nueva contraseña a tu correo electrónico.',textAlign: TextAlign.left,
        style: TextStyle(fontSize: alto * 0.02,color: colorPurpleT2),),
    );
  }

  Widget _titulo(){
    return Container(
      width: ancho,
      child: Text('Restablecer contraseña',textAlign: TextAlign.left,
        style: TextStyle(fontSize: alto * 0.032,color: colorPurple,fontWeight: FontWeight.bold),),
    );
  }

  Widget _circuleBack(BuildContext context){
    return Container(
      margin: EdgeInsets.only(left: ancho * 0.03,top: alto * 0.03),
      child: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: colorbuttonBack,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Center(child: Icon(Icons.arrow_back_ios,size: alto * 0.05,color: colorbuttonBackArrow,),),
        ),
      ),
    );
  }
}
