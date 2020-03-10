import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koyag_qr/Services/Conexionhttp.dart';
import 'package:koyag_qr/Models/Usuario.dart';
import 'package:koyag_qr/Views/Login/Login.dart';
import 'package:koyag_qr/Views/Profile/Profile.dart';
import 'package:koyag_qr/Views/QR/ViewQR.dart';
import 'package:koyag_qr/utils/Colores.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double alto = 0;
  double ancho = 0;
  bool cargando = true;
  int cantAcreditados = 0;
  String nombreEvents = '';

  conexionHttp conexionHispanos = new conexionHttp();

  List<dynamic> participantes;
  String fechaEvent = '';



  @override
  void initState() {
    inicializar(1,null);
    super.initState();
    participantes = new List<dynamic>();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose(){
    super.dispose();
  }

  inicializar(int tipo,BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cantAcreditados = prefs.getInt('koyagQRCantAcreditados');
    if(cantAcreditados == null){cantAcreditados = 0;}
    nombreEvents =  prefs.getString('koyagQRNombreEvent');

    cargando = true;
    setState(() {});

    try{
      var response = await conexionHispanos.httpListarUser();
      if(response.statusCode == 200){
        var value = jsonDecode(response.body);
        participantes = value['data']['participants'];
        if(value['data']['version_date'] == null){
          fechaEvent = 'Evento fuera de la fecha';
        }else{
          fechaEvent = value['data']['version_date'];
        }

        if(tipo == 2){
          _cerrarsesion(context,'La base de datos de participantes ha sido actualizada.',2);
        }
      }
    }catch(e){
      print(e.toString());
    }

    cargando = false;
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
                  child:  _contenido(),
                ),
              ],
            ),
          ),
          floatingActionButton: Container(
            height: 80.0,
            width: 80.0,
            child: FittedBox(
              child: FloatingActionButton(
                elevation: 20,
                backgroundColor: colorPurple,
                child: Center(
                  child: Image.asset('assets/codigo-qr.png',scale: 1.2,),
                ),
                onPressed: () async {
                  final result =  await Navigator.push(context, new MaterialPageRoute(
                      builder: (BuildContext context) => new ViewQR()));
                  if(result){
                    inicializar(2,context);
                  }
                },
              ),
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
            icon: Icon(Icons.cached,size: alto * 0.04,color: Colors.white,),
            onPressed: (){
              inicializar(2,context);
            },
          ),
        ),
        Expanded(
          flex: 9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _textoHeader('Evento $nombreEvents',FontWeight.bold),
              SizedBox(height: alto * 0.005,),
              _textoHeader('$fechaEvent',FontWeight.normal),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            child: Image.asset('assets/ico_exit.png',scale: 0.8,),
            onTap: (){
              _cerrarsesion(context,'¿Estás seguro que quieres cerrar sesión?',1);
            },
          ),
        ),
      ],
    );
  }

  Widget _textoHeader(String texto,FontWeight negrita){
    return Text(texto,
      style: TextStyle(
          color: Colors.white,
          fontWeight: negrita,
          fontSize: 16
      ),
    );
  }

  Widget _contenido(){
    return Container(
      width: ancho,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: alto * 0.03,bottom: alto * 0.03),
            child: _textoHome('Acreditaciones en este dispositivo: $cantAcreditados',TextAlign.center,FontWeight.bold,alto * 0.025),
          ),
          Container(
            color: Colors.white,
            height: alto * 0.13,
            padding: EdgeInsets.only(top: alto * 0.03,bottom: alto * 0.03,left: ancho * 0.05,right: ancho * 0.05),
            child: _buscador(),
          ),
          cargando ? Container(
            height: alto * 0.65,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colorPurple),
              ),
            ),
          ) : _listado(),
        ],
      ),
    );
  }

  String letraList = '';
  Widget _listado(){
    return Container(
      height: alto * 0.64,
      width: ancho,
      child: participantes.length != 0 ? ListView.builder(
        itemCount: participantes.length,
        itemBuilder: (context,index){

          Usuario usuario = Usuario.fromJson(participantes[index]);

          if(usuario.fullname.toLowerCase().contains(filtro.toLowerCase()) || filtro == ''){
            if(letraList.toUpperCase() != usuario.lastname.toUpperCase().substring(0,1)){
              letraList = usuario.lastname.substring(0,1).toUpperCase();
              return Container(
                child: Column(
                  children: <Widget>[
                    _item('$letraList'),
                    _itemDescrip('${usuario.lastname}, ${usuario.firstname}',usuario,context),
                  ],
                ),
              );
            }
            return _itemDescrip('${usuario.lastname}, ${usuario.firstname}',usuario,context);
          }else{
            return Container();
          }
        },
      ) : Center(
        child: Container(
          height: alto * 0.2,
          width: ancho,
          child: Text('No existen usuarios.',style: TextStyle(fontSize: alto * 0.025),textAlign: TextAlign.center,)
        ),
      ),
    );
  }

  Widget _item(texto){
    return Container(
      padding: EdgeInsets.only(left: ancho * 0.07,right: ancho * 0.07),
      width: ancho,
      height: alto * 0.05,
      child: Center(
        child: Container(
          width: ancho,
          child: _textoLista(texto,TextAlign.left,alto * 0.02),
        )
      ),
    );
  }

  Map<int,bool> mapCheck = Map();
  Widget _itemDescrip(String texto,Usuario usuario,BuildContext context){
    return InkWell(
      child: Card(
        margin: EdgeInsets.all(0.5),
        child: Container(
          padding: EdgeInsets.only(left: ancho * 0.07,right: ancho * 0.07),
          width: ancho,
          height: alto * 0.09,
          color: Colors.white,
          child: Center(
            child: Container(
              width: ancho,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: _textoLista('$texto',TextAlign.left,alto * 0.023)
                  ),
                  Expanded(
                    flex: 1,
                    child: usuario.accreditationStatus == 0 ?
                    Icon(Icons.remove_circle_outline,color: colorCheckOff,) :
                    Icon(Icons.check_circle_outline,color: colorCheck,),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      onTap: () async {
        final result =  await Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) => new Profile(usuarioRes: usuario,)));
        if(result){
          inicializar(2,context);
        }
      },
    );
  }

  Widget _textoLista(String texto,TextAlign alinear,double alto){
    return Text(texto,
      textAlign: alinear,
      style: TextStyle(fontSize: alto,fontWeight: FontWeight.bold,color: colorPurpleT2),
    );
  }

  String filtro = '';
  Widget _buscador(){
    return Container(
      height: alto * 0.05,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0),side: BorderSide(color: colorBordeForm)),
        child: TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'Buscar asistentes',
              border: InputBorder.none,
              contentPadding:EdgeInsets.symmetric(horizontal: ancho * 0.05, vertical: alto * 0.022)
          ),
          onChanged: (value) {
            letraList = '';
            filtro = value;
            setState(() {});
          },
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
  _cerrarsesion(BuildContext context,String texto,int tipo){
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20))
          ),
          height: MediaQuery.of(context).size.height * 0.37,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: alto * 0.05,),
              Container(
                width: ancho,
                padding: EdgeInsets.only(left: ancho * 0.1,right: ancho * 0.1),
                child: Text('$texto',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: alto * 0.025,fontFamily: 'RobotoBlack'),
                ),
              ),
              tipo == 1 ? SizedBox(height: alto * 0.10,) : SizedBox(height: alto * 0.18,),
              tipo == 1 ? _buttonSumitCerrar(context,'ACEPTAR',1,1) : _buttonSumitCerrar(context,'ACEPTAR',2,1),
              tipo == 1 ? SizedBox(height: alto * 0.015,) : Container(),
              tipo == 1 ? _buttonSumitCerrar(context,'CANCELAR',2,2) : Container(),
            ],
          ),
        );
      },
    );
  }

  Widget _buttonSumitCerrar(BuildContext context,String texto,int accion,int tipo){
    return Container(
      width: ancho,
      height: alto * 0.06,
      margin: EdgeInsets.only(left: ancho * 0.05,right: ancho * 0.05),
      child: RaisedButton(
        color: tipo == 1 ? colorPurple : Colors.white,
        child: Text('$texto',
          style: TextStyle(color: tipo == 1 ? Colors.white : colorPurple,
              fontWeight: FontWeight.bold,letterSpacing: 1,fontSize: alto * 0.022),),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: tipo == 1 ? colorPurple : colorBordeButton)
        ),
        onPressed: () async {
          if(accion ==1){
            SharedPreferences prefs = await SharedPreferences.getInstance();
            try{
              var response = await conexionHispanos.httpCerrarSesion();
              if(response.statusCode == 200){
                var value = jsonDecode(response.body);
                if(value['valid']){
                  prefs.remove('koyagQRLogin');
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (BuildContext context) => new Login()));
                }
              }
            }catch(e){
              print(e.toString());
            }
          }
          if(accion ==2){
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  Widget textoDialog(BuildContext context,String texto){
    return Text(texto,
      style: TextStyle(fontSize: alto * 0.025,color: colorPurple,),textAlign: TextAlign.right,);
  }
}
