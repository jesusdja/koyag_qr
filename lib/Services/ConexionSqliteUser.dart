import 'package:koyag_qr/Models/UsuarioLocal.dart';
import 'package:koyag_qr/utils/Globales.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabaseProvider{
  UserDatabaseProvider._();

  static final  UserDatabaseProvider db = UserDatabaseProvider._();
  Database _database;


  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await getDatabaseInstanace();
    return _database;
  }
  //ELIMINAR INSTANCIA
  Future deleteDatabaseInstance() async {
    final db = await database;
    db.delete('Usuarios');
  }
  //OBTENER USUARIO
  Future<UsuarioLocal> getCodeId(String codigo) async {
      try{
        final db = await database;
        var response = await db.query("Usuarios", where: "participantId = ?", whereArgs: [codigo]);
        return response.isNotEmpty ? UsuarioLocal.fromMap(response.first) : null;
      }catch(e){
        return null;
      }
  }
  Future<List<UsuarioLocal>> getAll() async {
    List<UsuarioLocal> listUser = new List<UsuarioLocal>();
    final db = await database;
    try{
      List<Map> list = await db.rawQuery('SELECT * FROM Usuarios');
      list.forEach((mapa){
        UsuarioLocal usuario = new UsuarioLocal.fromMap(mapa);
        listUser.add(usuario);
      });
    }catch(e){
      print(e.toString());
    }
    return listUser;
  }

  //Insert
  Future<int> saveUser(UsuarioLocal user) async {
    int res = 0;
    try{
      var dbClient = await database;
      res = await dbClient.insert("Usuarios", user.toMap());
    }catch(e){
      print(e.toString());
    }

    return res;
  }
  //MODIFICAR
  Future<int> updateUser(UsuarioLocal user) async {
    var dbClient = await  database;
    int res = 0;
    try{
      res = await dbClient.update('Usuarios', user.toMap(),where: 'participantId = ?', whereArgs: [user.participantId]);
    }catch(e){
      print(e.toString());
    }
    return res;
  }
}
