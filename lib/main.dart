import 'package:flutter/material.dart';

import 'App.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: App(),
        theme: ThemeData(
          fontFamily: 'roboto',
        )
    );
  }
}