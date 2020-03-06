import 'package:flutter/material.dart';
import 'package:koyag_qr/Models/Usuario.dart';

class Profile extends StatefulWidget {
  Profile({this.usuarioRes});
  final Usuario usuarioRes;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  Usuario usuario;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usuario = widget.usuarioRes;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
