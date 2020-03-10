import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Services/auth.dart';
import 'Views/Home/Home.dart';
import 'Views/Login/Login.dart';
import 'Views/StarLogo.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App>{

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => AuthService.instance(),
      child: Consumer(
        // ignore: missing_return
        builder: (context, AuthService auth, _){
          switch (auth.status) {
            case Status.Logo:
              return StartLogo();
            case Status.Login:
              return Login();
            case Status.home:
              return Home();
              break;
          }
        },
      ),
    );
  }

}