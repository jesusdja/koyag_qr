import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:koyag_qr/Services/Conexionhttp.dart';
import 'package:koyag_qr/utils/Colores.dart';
import 'package:koyag_qr/utils/Globales.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewQR extends StatefulWidget {
  @override
  _ViewQRState createState() => _ViewQRState();
}

enum enumStatusQR {inactivo,accreditation_valid,event_closed,accredited,invalid_qr}

class _ViewQRState extends State<ViewQR> {

  String qr;
  bool camState = false;
  double alto = 0;
  double ancho = 0;
  enumStatusQR statusQR;
  int cantAcreditados = 0;

  @override
  initState() {
    statusQR = enumStatusQR.inactivo;
    super.initState();
    inicializar();
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    cantAcreditados = prefs.getInt('koyagQRCantAcreditados');
    if(cantAcreditados == null){cantAcreditados = 0;}

    await Future.delayed(Duration(milliseconds: 800));
    camState = true;
    setState(() {});
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
      child: new Scaffold(
        backgroundColor: colorOpacyt,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  color: colorOpacyt,
                  width: ancho,
                  height: alto * 0.8,
                  child: _camara(),
                ),
              ),
              Opacity(
                opacity: 0.90,
                child: Container(
                  width: ancho,
                  height: alto,
                  child: _fondo1(),
                ),
              ),
              Container(
                width: ancho,
                height: alto,
                child: _enfoque(),
              ),
              Container(
                margin: EdgeInsets.only(top: alto * 0.01),
                child: _header(),
              ),
              Container(
                margin: EdgeInsets.only(top: alto * 0.1),
                width: ancho,
                child: _titulo(),
              ),
              statusQR != enumStatusQR.inactivo ? Container(
                width: ancho,
                margin: EdgeInsets.only(top: alto * 0.78,left: ancho * 0.1,right: ancho * 0.1),
                child: _mensaje(),
              ) : Container(),
            ],
          )
        ),
      ),
    );
  }

  Widget _enfoque(){
    return Center(
      child: Container(
        width: ancho * 0.82,
        height: alto * 0.45,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: statusQR == enumStatusQR.inactivo ?
            Image.asset('assets/marco_inactivo.png').image :
            Image.asset('assets/marco_activo.png').image,
            fit: BoxFit.fill,
          ),
        ),
      )


    );
  }


  String qrOld = '';
  Widget _camara(){
    return Center(
      child: Container(
        child: SizedBox(
          child: camState
              ? new QrCamera(
            fit: BoxFit.fill,
            onError: (context, error) => Text(
              error.toString(),
              style: TextStyle(color: Colors.red),
            ),
            qrCodeCallback: (code) {
              qr = code;
              //https://koyangdev.koyag.com/8df4fdfc/app/validation?uid=1&u_uid=89fee6e4-9eb4-4cce-9a82-caf963ed24f3
              print(qr);
              if(qrOld != qr || checkQR == false){
                qrOld = qr;
                checkQR = true;
                setState(() {});
                _verificarQR();
              }
            },
          )
              : new Center(child: new Text("Cargando lector QR")),
        ),
      ),
    );
  }

  String nombreAcredit = '';
  String horaAcredit = '';

  _verificarQR() async {
    try{
      //String qr2 = 'https://koyangdev.koyag.com/8df4fdfc/app/validation?uid=1&u_uid=89fee6e4-9eb4-4cce-9a82-caf963ed24f3';
      var response = await conexionHispanos.httpVerificarQR(qr);

      if(response != null){
        if(response.statusCode == 200){
          var value = jsonDecode(response.body);
          if(value['status'] == 'accredited'){
            statusQR = enumStatusQR.accredited;
            nombreAcredit = value['fullname'];
            horaAcredit = value['accreditationHour'];
          }
          if(value['status'] == 'accreditation_valid'){
            statusQR = enumStatusQR.accreditation_valid;
            nombreAcredit = value['fullname'];
            horaAcredit = value['accreditationHour'];
            acreditado = true;
            cantAcreditados++;
            sumarCredito(cantAcreditados);
          }
          if(value['status'] == 'invalid_qr'){statusQR = enumStatusQR.invalid_qr;}
          if(value['status'] == 'event_closed'){statusQR = enumStatusQR.event_closed;}
        }
      }else{
        statusQR = enumStatusQR.invalid_qr;
      }

      setState(() {});
      esperarLeerMismo();
      print('SIGO');

    }catch(e){
      print(e.toString());
    }
  }

  esperarLeerMismo() async {
    await Future.delayed(Duration(seconds: 50));
    setState(() {
      checkQR = false;
    });
  }

  bool checkQR = false;
  conexionHttp conexionHispanos = new conexionHttp();
  Widget _mensaje() {

    if(statusQR == enumStatusQR.accreditation_valid){
      return alertaSmS('$nombreAcredit','Ha sido acreditado','A las $horaAcredit',colorAlert1,1);
    }
    if(statusQR == enumStatusQR.accredited){
      return alertaSmS('$nombreAcredit','Fue acreditada','A las $horaAcredit',colorAlert2,2);
    }
    if(statusQR == enumStatusQR.invalid_qr){
      return alertaSmS('','Este código QR no pertenece a este evento','',colorAlert3,3);
    }
    return Container();
  }

  Widget alertaSmS(String titulo,String mensaje,String hora,Color color,int tipo){

    Widget widgetAlert = Icon(Icons.check_circle_outline,color: Colors.white,size: alto * 0.06,);
    if(tipo == 2){
      widgetAlert = Icon(Icons.cancel,color: Colors.white,size: alto * 0.06,);
    }
    if(tipo == 3){
      widgetAlert = FittedBox(
        fit: BoxFit.fill,
        child: Image.asset('assets/sad-emoji.png',scale: 0.8,),
      );
    }


    return Container(
      height: alto * 0.12,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              decoration: new BoxDecoration(
                  color: color,
                  boxShadow: [ BoxShadow(color: Colors.grey[800],)],
                  borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(20.0),
                      topLeft: const Radius.circular(20.0)
                  )
              ),
              child: Center(
                child: widgetAlert,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.only(right: ancho * 0.05,left: ancho * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(titulo,style: TextStyle(fontWeight: FontWeight.bold,fontSize: alto * 0.02),),
                  SizedBox(height: alto * 0.01,),
                  Text(mensaje,style: TextStyle(fontSize: alto * 0.02),),
                  SizedBox(height: alto * 0.01,),
                  Text(hora,style: TextStyle(fontSize: alto * 0.02),)
                ],
              ),
            ),
          ),
        ],
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

  Widget _titulo(){
    return Text('Acreditaciones en este dispositivo: $cantAcreditados',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 0.5),
    );
  }

  bool acreditado = false;
  Widget _header(){
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,),
            onPressed: (){
              Navigator.of(context).pop(acreditado);
            },
          ),
        ),
        Expanded(
          flex: 8,
          child: Text('Escanear',textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 0.5),),
        ),
      ],
    );
  }

  Widget _fondo1(){
    return FittedBox(
      child: Image.asset('assets/fondoScanQRP.png',color: colorOpacyt,),
      fit: BoxFit.fill,
    );
  }
}
