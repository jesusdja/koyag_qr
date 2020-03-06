import 'dart:convert';

import 'package:flutter/material.dart';
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

  conexionHttp conexionHispanos = new conexionHttp();

  List<dynamic> participantes;

  @override
  void initState() {
    inicializar();
    super.initState();
    participantes = new List<dynamic>();
  }

  inicializar() async {
    cargando = true;
    setState(() {});

    try{
      var response = await conexionHispanos.httpListarUser();
      var value = jsonDecode(response.body);
      participantes = value['data']['participants'];
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
                  child: contentHeader(),
                ),
                Container(
                  margin: EdgeInsets.only(top: alto * 0.1),
                  decoration: BoxDecoration(
                      color: colorFondo2,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
                  child:  _contenido(),
                ),
                Positioned(
                  left: ancho * 0.75,
                  top: alto * 0.7,
                  child: Container(
                    height: 80.0,
                    width: 80.0,
                    child: FittedBox(
                      child: FloatingActionButton(
                        backgroundColor: colorPurple,
                        child: Center(
                          child: Image.asset('assets/codigo-qr.png',scale: 1.2,),
                        ),
                        onPressed: () async {

                          Navigator.push(context, new MaterialPageRoute(
                              builder: (BuildContext context) => new ViewQR()));

                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

        ),
      ),
    );
  }

  Widget contentHeader(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.cached,size: alto * 0.04,color: Colors.white,),
            onPressed: (){
              inicializar();
            },
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _textoHeader('Evento XXX',FontWeight.bold),
              _textoHeader('Lun, 24 de marzo 2020 9:00 a.m',FontWeight.normal),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            child: Image.asset('assets/ico_exit.png',scale: 0.8,),
            onTap: (){
              _cerrarsesion();
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
            child: _textoHome('Acreditaciones en este dispositivo: XXXX',TextAlign.center,FontWeight.bold,alto * 0.025),
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

          if(letraList.toUpperCase() != usuario.lastname.toUpperCase().substring(0,1)){
            letraList = usuario.lastname.substring(0,1).toUpperCase();
            return Container(
              child: Column(
                children: <Widget>[
                  _item('$letraList'),
                  _itemDescrip('${usuario.lastname},${usuario.firstname}',usuario),
                ],
              ),
            );
          }
          return _itemDescrip('${usuario.lastname},${usuario.firstname}',usuario);
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
      padding: EdgeInsets.only(left: ancho * 0.05,right: ancho * 0.05),
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
  Widget _itemDescrip(String texto,Usuario usuario){
    return InkWell(
      child: Card(
        margin: EdgeInsets.all(0.5),
        child: Container(
          padding: EdgeInsets.only(left: ancho * 0.05,right: ancho * 0.05),
          width: ancho,
          height: alto * 0.09,
          color: Colors.white,
          child: Center(
            child: Container(
              width: ancho,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: _textoLista('$texto',TextAlign.left,alto * 0.022)
                  ),
                  Expanded(
                    flex: 1,
                    child: usuario.accreditationStatus == 0 ?
                    Icon(Icons.remove_circle_outline,color: colorCheckOff,) :
                    Icon(Icons.check_circle_outline,color: colorCheck,),
//                    IconButton(
//                      icon: (mapCheck[usuario.participantId]== null || mapCheck[usuario.participantId] == false) ?
//                      Icon(Icons.remove_circle_outline,color: colorCheckOff,) :
//                      Icon(Icons.check_circle_outline,color: colorCheck,),
//                      onPressed: (){
//                        if(mapCheck[usuario.participantId] == null){mapCheck[usuario.participantId] = false;}
//                        mapCheck[usuario.participantId] = !mapCheck[usuario.participantId];
//                        setState(() {});
//
//                        //MODIFICAR EN API
//
//                      },
//                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      onTap: (){
        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) => new Profile()));
      },
    );
  }

  Widget _textoLista(String texto,TextAlign alinear,double alto){
    return Text(texto,
      textAlign: alinear,
      style: TextStyle(fontWeight: FontWeight.bold,fontSize: alto),
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
          onSaved: (value) {
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

  _cerrarsesion(){
    showDialog(
        context: context,
        builder: ( context ) {
          return AlertDialog(
            title: Text(''),
            content: textoDialog(context,'¿Esta seguro que desea salir?'),
            actions: <Widget>[
              Container(
                width: ancho * 0.7,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        child: textoDialog(context,'Ok'),
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.remove('koyagQRLogin');
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (BuildContext context) => new Login()));
                        },
                      ),
                    ),
                    Expanded(child: Container(),),
                    Expanded(
                      child: FlatButton(
                        child: textoDialog(context,'Cancelar'),
                        onPressed: ()=> Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          );
        }
    );
  }

  Widget textoDialog(BuildContext context,String texto){
    return Text(texto,
      style: TextStyle(fontSize: alto * 0.025,color: colorPurple,),textAlign: TextAlign.right,);
  }
}
