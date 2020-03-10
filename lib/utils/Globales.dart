import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<String> obtenerToken() async {
  SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();
  String token  = prefs.getString('koyagQRToken');
  return token;
}

sumarCredito(int cant) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('koyagQRCantAcreditados',cant);
}

Future<Database> getDatabaseInstanace() async {
  Directory directory = await getApplicationDocumentsDirectory();
  String path = join(directory.path, "koyagdb.db");
  return await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE Participantes("
                "uid INTEGER primary key,"
                "fullname TEXT, "
                "avatar TEXT, "
                "mail TEXT, "
                "position TEXT, "
                "organization TEXT, "
                "accreditation INT, "
                "u_uid TEXT "
                ")");
        await db.execute(
            "CREATE TABLE Usuarios("
                "participantId INTEGER primary key, "
                "firstname TEXT, "
                "lastname TEXT, "
                "fullname TEXT, "
                "email TEXT, "
                "accreditationStatus INT, "
                "accreditation INT, "
                "uuid TEXT "
                ")");
      });
}

