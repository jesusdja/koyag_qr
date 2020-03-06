import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:koyag_qr/utils/Colores.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class ViewQR extends StatefulWidget {
  @override
  _ViewQRState createState() => _ViewQRState();
}

class _ViewQRState extends State<ViewQR> {

  String qr;
  bool camState = false;
  double alto = 0;
  double ancho = 0;

  @override
  initState() {
    super.initState();
    inicializar();
  }

  inicializar() async {
    await Future.delayed(Duration(milliseconds: 500));
    camState = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    alto = MediaQuery.of(context).size.height;
    ancho = MediaQuery.of(context).size.width;

    return new Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: ancho,
              height: alto,
              child: _fondo1(),
            ),
            Opacity(
              opacity: 0.75,
              child: Container(
                width: ancho,
                height: alto,
                color: colorOpacyt,
              ),
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
          ],
        )        
//        new Center(
//          child: new Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              new Expanded(
//                  child: camState
//                      ? new Center(
//                    child: new SizedBox(
//                      width: 300.0,
//                      height: 400.0,
//                      child: new QrCamera(
//                        onError: (context, error) => Text(
//                          error.toString(),
//                          style: TextStyle(color: Colors.red),
//                        ),
//                        qrCodeCallback: (code) {
//                          setState(() {
//                            qr = code;
//                          });
//                        },
//                        child: new Container(
//                          decoration: new BoxDecoration(
//                            color: Colors.transparent,
//                            border: Border.all(color: Colors.orange, width: 10.0, style: BorderStyle.solid),
//                          ),
//                        ),
//                      ),
//                    ),
//                  )
//                      : new Center(child: new Text("Camera inactive"))),
//              new Text("QRCODE: $qr"),
//            ],
//          ),
//        ),
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
      child: Image.asset('assets/fondoScanQR.png'),
      fit: BoxFit.fill,
    );
  }
}
