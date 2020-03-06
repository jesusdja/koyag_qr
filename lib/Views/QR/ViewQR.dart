import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:koyag_qr/utils/Colores.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class ViewQR extends StatefulWidget {
  @override
  _ViewQRState createState() => _ViewQRState();
}

enum enumStatusQR {inactivo,aceptado,cerrado,acreditado,invalido}

class _ViewQRState extends State<ViewQR> {

  String qr;
  bool camState = false;
  double alto = 0;
  double ancho = 0;
  enumStatusQR statusQR;

  @override
  initState() {
    statusQR = enumStatusQR.inactivo;
    super.initState();
    inicializar();
  }

  inicializar() async {
    await Future.delayed(Duration(milliseconds: 800));
    camState = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    alto = MediaQuery.of(context).size.height;
    ancho = MediaQuery.of(context).size.width;

    return new Scaffold(
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
//            Opacity(
//              opacity: 0.75,
//              child: Container(
//                width: ancho,
//                height: alto,
//                color: colorOpacyt,
//              ),
//            ),
            Container(
              margin: EdgeInsets.only(top: alto * 0.01),
              child: _header(),
            ),
            Container(
              margin: EdgeInsets.only(top: alto * 0.1),
              width: ancho,
              child: _titulo(),
            ),
            statusQR != enumStatusQR.invalido ? Container(
              width: ancho,
              margin: EdgeInsets.only(top: alto * 0.78,left: ancho * 0.1,right: ancho * 0.1),
              child: _mensaje(),
            ) : Container(),
          ],
        )
      /*  new Center(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  child: camState
                      ? new Center(
                    child: new SizedBox(
                      width: 300.0,
                      height: 400.0,
                      child: new QrCamera(
                        onError: (context, error) => Text(
                          error.toString(),
                          style: TextStyle(color: Colors.red),
                        ),
                        qrCodeCallback: (code) {
                          setState(() {
                            qr = code;
                          });
                        },
                        child: new Container(
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.orange, width: 10.0, style: BorderStyle.solid),
                          ),
                        ),
                      ),
                    ),
                  )
                      : new Center(child: new Text("Camera inactive"))),
              new Text("QRCODE: $qr"),
            ],
          ),
        ),*/
      ),
    );
  }

  Widget _mensaje(){

    int status = 3;

    if(status == 1){
      return alertaSmS('Juan Pablo López','Ha sido acreditado','a las 09:41',colorAlert1,1);
    }
    if(status == 2){
      return alertaSmS('Andréa Barros','Fue acreditada','a las 15:34',colorAlert2,2);
    }
    if(status == 3){
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
                  Text(titulo,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  SizedBox(height: alto * 0.01,),
                  Text(mensaje,style: TextStyle(fontSize: 15),),
                  SizedBox(height: alto * 0.01,),
                  Text(hora,style: TextStyle(fontSize: 15),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _camara(){
    return Center(
      child: Container(
        //margin: EdgeInsets.symmetric(horizontal: ancho * 0.08 , vertical: alto * 0.24 ),
//        decoration: BoxDecoration(
//            color: Color.fromRGBO(0, 0, 0, 0.7),
//            borderRadius: BorderRadius.circular(20.0)
//        ),
        child: SizedBox(
          child: camState
              ? new QrCamera(
            fit: BoxFit.fill,
            onError: (context, error) => Text(
              error.toString(),
              style: TextStyle(color: Colors.red),
            ),
            qrCodeCallback: (code) {
              setState(() {
                qr = code;
                //https://koyangdev.koyag.com/8df4fdfc/app/validation?uid=1&u_uid=89fee6e4-9eb4-4cce-9a82-caf963ed24f3
                print(qr);
              });
            },
          )
              : new Center(child: new Text("Cargando lector QR")),
        ),
      ),
    );
  }

  Widget _titulo(){
    return Text('Acreditaciones en este dispositivo: XXXX',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 0.5),
    );
  }

  Widget _header(){
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,),
            onPressed: (){
              Navigator.of(context).pop();
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
