import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koyag_qr/Models/Participante.dart';
import 'package:koyag_qr/Models/Usuario.dart';
import 'package:koyag_qr/Services/Conexionhttp.dart';
import 'package:koyag_qr/utils/Colores.dart';
import 'package:koyag_qr/utils/Globales.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile({this.usuarioRes});
  final Usuario usuarioRes;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  Usuario usuario;
  double alto = 0;
  double ancho = 0;
  int cantAcreditados = 0;
  Participante participante;
  bool acreditado = false;
  bool cargando = false;

  conexionHttp conexionHispanos = new conexionHttp();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usuario = widget.usuarioRes;
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
    setState(() {});

    try{
      var response = await conexionHispanos.httpBuscarUser(usuario.uuid);
      if(response.statusCode == 200){
        var value = jsonDecode(response.body);
        participante = Participante.fromJson(value['participant']);
      }
    }catch(e){
      print(e.toString());
    }
    setState(() {});

  }

  Future<bool> exit() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    alto = MediaQuery.of(context).size.height;
    ancho = MediaQuery.of(context).size.width;

    return SafeArea(
      child: WillPopScope(
        onWillPop: exit,
        child: Scaffold(
          backgroundColor: colorFondo,
          body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  width: ancho,
                  height: 56,
                  margin: EdgeInsets.only(left: 15,right: 15,top: 10),
                  child: contentHeader(context),
                ),
                Container(
                  margin: EdgeInsets.only(top: alto * 0.1),
                  decoration: BoxDecoration(
                      color: colorFondo2,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
                  child: Container(
                    width: ancho,
                    height: alto * 0.865,
                    child:  _contenido(),
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }

  Widget contentHeader(BuildContext context){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.arrow_back,size: alto * 0.04,color: Colors.white,),
            onPressed: (){
              Navigator.of(context).pop(acreditado);
            },
          ),
        ),
        Expanded(
          flex: 11,
          child: Text('Participantes',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
                fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _contenido(){
    return Container(
      width: ancho,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: alto * 0.03,bottom: alto * 0.03),
              child: _textoHome('Acreditaciones en este dispositivo: $cantAcreditados',TextAlign.center,FontWeight.bold,alto * 0.025),
            ),
            Container(
              width: ancho,
              height: alto * 0.4,
              padding: EdgeInsets.only(top: alto * 0.04),
              color: Colors.white,
              child: _fotoperfil(),
            ),
            Container(
              width: ancho,
              height: alto * 0.37,
              color: Colors.white,
              child: participante == null ? Container() :
              participante.accreditation == 0 ? (
                cargando ? Container(
                  width: ancho * 0.8,
                  height: alto * 0.06,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(colorPurple),
                    ),
                  ),
                ) : _acreditar()
              ) : _mostrarAcreditacion()  ,
            ),
          ],
        ),
      ),
    );
  }
  Widget _textoHome(String texto,TextAlign alinear,FontWeight negrita,double alto){
    return Text(
      texto,
      style: TextStyle(fontWeight: negrita,fontSize: alto),
      textAlign: alinear,
    );
  }

  Widget _fotoperfil(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: ancho * 0.3,
          height: alto * 0.16,
          decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [ BoxShadow(color: Colors.grey[800],)],
            borderRadius: BorderRadius.circular(20.0),
            image: (participante != null && participante.avatar != '') ? new DecorationImage(
              image: Image.network(participante.avatar).image,
              fit: BoxFit.fill,
            ) : null,
          ),
        ),
         Container(
          width: ancho * 0.6,
          padding: EdgeInsets.only(left: ancho * 0.05),
          child: participante != null ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              textoColumPerfil('Nombre '),
              SizedBox(height: alto * 0.015,),
              textoColumPerfil('${participante.fullname}'),
              SizedBox(height: alto * 0.03,),
              textoColumPerfil('Cargo'),
              SizedBox(height: alto * 0.015,),
              textoColumPerfil('${participante.position}'),
              SizedBox(height: alto * 0.03,),
              textoColumPerfil('Empresa'),
              SizedBox(height: alto * 0.015,),
              textoColumPerfil('${participante.organization}'),
              SizedBox(height: alto * 0.03,),
              textoColumPerfil('Correo con el que se acreditó'),
              SizedBox(height: alto * 0.015,),
              textoColumPerfil('${participante.mail}'),
            ],
          ) : Container(),
        ) ,
      ],
    );
  }

  Widget textoColumPerfil(String texto){
    return Text(texto == '' ? 'No disponible' : texto,style: TextStyle(fontSize: alto * 0.02,fontWeight: FontWeight.bold),);
  }

  Widget _acreditar(){
    return Center(
      child: Container(
        width: ancho * 0.8,
        height: alto * 0.06,
        margin: EdgeInsets.only(left: ancho * 0.05,right: ancho * 0.05),
        child: RaisedButton(
          color: colorButton,
          child: Text('ACREDITAR',style:
          TextStyle(color: Colors.white,letterSpacing: 2,fontWeight: FontWeight.bold,fontSize: alto * 0.022),),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(color: colorButton)
          ),
          onPressed: () async {
            setState(() {
              cargando = true;
            });
            //ACREDITAR USUARIO
            String qr = 'https://koyangdev.koyag.com/8df4fdfc/app/validation?uid=${participante.uid}&u_uid=${participante.u_uid}';
            var response = await conexionHispanos.httpVerificarQR(qr);
            if(response.statusCode == 200){
              //SUMAR CREDITOS
              cantAcreditados++;
              sumarCredito(cantAcreditados);
              //ACTUALIZAR PARTICIPANTE
              inicializar();
              //SE ACREDITO ACTUALIZAR HOME
              acreditado = true;
              setState(() {});
            }else{
              setState(() {
                cargando = false;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _mostrarAcreditacion(){

    Widget widgetAlert = Icon(Icons.check_circle_outline,color: Colors.white,size: alto * 0.06,);

    return Container(
      padding: EdgeInsets.only(top: alto * 0.12,bottom: alto * 0.11,
          right: ancho * 0.05,left: ancho * 0.05),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              decoration: new BoxDecoration(
                  color: colorButton,
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
              padding: EdgeInsets.only(right: ancho * 0.05,left: ancho * 0.05),
              decoration: new BoxDecoration(
                  color: Color.fromRGBO(235, 251, 511, 1),
                  borderRadius: BorderRadius.only(
                      bottomRight: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0)
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(participante.fullname,style: TextStyle(fontFamily: 'RobotoBlack',fontSize: alto * 0.02),),
                  SizedBox(height: alto * 0.015,),
                  Text('Ha sido acreditado',style: TextStyle(fontSize: alto * 0.02),),
                  SizedBox(height: alto * 0.015,),
                  Text('A las ${participante.accretationHour}',style: TextStyle(fontSize: alto * 0.02),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
