import 'package:deprem/deprem.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'deprem.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE depremler(bolge TEXT NOT NULL,buyukluk TEXT NOT NULL, tarih TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertDeprem(List<Deprem> depremler) async {
    int result = 0;
    final Database db = await initializeDB();
    db.execute("delete from depremler");
    for(var deprem in depremler){
      result = await db.insert('depremler', deprem.toMap());
    }
    return result;
  }

  Future<List<Deprem>> retrieveDeprem() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('depremler');
    return queryResult.map((e) => Deprem.fromMap(e)).toList();
  }
  Future<List<Deprem>> depremAra(String boyut) async{

    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('SELECT * FROM depremler  WHERE buyukluk>=$boyut');
    return queryResult.map((e) => Deprem.fromMap(e)).toList();
  }
}