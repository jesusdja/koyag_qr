import 'package:flutter/material.dart';
import 'package:koyag_qr/Views/Login/Login.dart';
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

  List<String> lista = new List<String>();

  @override
  void initState() {
    inicializar();
    super.initState();
  }

  inicializar(){
    lista.add('Barrera, Julían');
    lista.add('Barros, Andréa');
    lista.add('Gálvez, Antonia');
    lista.add('Gorrido, Eduardo');
    lista.add('González, María');
    lista.add('López, Juan Pablo');
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
          body: Stack(
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
                child: _contenido(),
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
                      onPressed: (){
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
            onPressed: (){},
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
          _listado(),
        ],
      ),
    );
  }

  String letraList = '';
  Widget _listado(){
    return Container(
      height: alto * 0.64,
      width: ancho,
      child: ListView.builder(
        itemCount: lista.length,
        itemBuilder: (context,index){

          if(letraList.toUpperCase() != lista[index].toUpperCase().substring(0,1)){
            letraList = lista[index].substring(0,1).toUpperCase();
            return Container(
              child: Column(
                children: <Widget>[
                  _item('$letraList'),
                  _itemDescrip('${lista[index]}'),
                ],
              ),
            );
          }
          return _itemDescrip('${lista[index]}');
        },
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

  Map<String,bool> mapCheck = Map();
  Widget _itemDescrip(texto){
    return Card(
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
                  child: IconButton(
                    icon: (mapCheck[texto]== null || mapCheck[texto] == false) ?
                    Icon(Icons.remove_circle_outline,color: colorCheckOff,) :
                    Icon(Icons.check_circle_outline,color: colorCheck,),
                    onPressed: (){
                      if(mapCheck[texto] == null){mapCheck[texto] = false;}
                      mapCheck[texto] = !mapCheck[texto];
                      setState(() {});
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
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
