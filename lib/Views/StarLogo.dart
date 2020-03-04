import 'package:flutter/material.dart';
import 'package:koyag_qr/Services/auth.dart';
import 'package:provider/provider.dart';

class StartLogo extends StatefulWidget {
  @override
  _StarLogoState createState() => _StarLogoState();
}

class _StarLogoState extends State<StartLogo> with SingleTickerProviderStateMixin{
  AuthService auth;
  Future<bool> exit() async {
    return false;
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthService>(context);

    return WillPopScope(
        child: FutureBuilder(
          future: auth.init(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
                return LogoJesus();
                break;
              case ConnectionState.waiting:
                  return LogoJesus();
                break;
              case ConnectionState.active:
                return LogoJesus();
                break;
              case ConnectionState.done:
                return LogoJesus();
                break;
            }
            return LogoJesus();
          },
        ),
        onWillPop: exit
    );
  }
  LogoJesus(){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/logoKY.png',width: MediaQuery.of(context).size.width * 0.8,),
      ),
    );
  }
}