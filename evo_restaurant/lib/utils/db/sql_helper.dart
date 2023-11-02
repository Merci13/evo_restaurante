import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""
    CREATE TABLE family(
    id TEXT PRIMARY KEY NOT NULL UNIQUE, 
    name TEXT NOT NULL, 
    img TEXT
    )
    """);

    await database.execute("""
      CREATE TABLE subfamily(
    id TEXT PRIMARY KEY NOT NULL UNIQUE, 
    name TEXT NOT NULL, 
    img TEXT
    )
      """);

    await database.execute("""" 
    CREATE TABLE article(
    id INTEGER PRIMARY KEY NOT NULL UNIQUE, 
    id_family INTEGER NOT NULL, 
    name TEXT, 
    img TEXT, 
    cod_bar TEXT, 
    reg_iva_vta TEXT, 
    pvp INTEGER, 
    beb BIT,
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
        path.join(await sql.getDatabasesPath(), 'evorestaurant.db'),
        version: 1, onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

  static Future<int> createFamily(
      String idFamily, String name, String? img) async {
    final db = await SQLHelper.db();
    final data = {'id': idFamily, 'name': name, 'img': img};
    final id = await db.insert('family', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> createSubFamily(
      String idSubFamily, String name, String? img) async {
    final db = await SQLHelper.db();
    final data = {'id': idSubFamily, 'name': name, 'img': img};
    final id = await db.insert('subfamily', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> createArticle(
      {required String idArticle,
      required String idFamily,
      String? name,
      String? img,
      String? codBar,
      String? regIvaVta,
      int? pvp,
      bool beb = false}) async {
    final db = await SQLHelper.db();
    final data = {
      'id': idArticle,
      'id_family': idFamily,
      'name': name,
      'img': img,
      'cod_bar': codBar,
      'reg_iva_vta': regIvaVta,
      'pvp': pvp,
      'beb': beb ? 1 : 0
    };
    final id = await db.insert('article', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getFamilies() async {
    final db = await SQLHelper.db();
    return db.query('family', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getSubFamilies() async {
    final db = await SQLHelper.db();
    return db.query('subfamily', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getArticles() async {
    final db = await SQLHelper.db();
    return db.query('article', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getFamily(String id) async {
    final db = await SQLHelper.db();
    return db.query('family', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getSubFamily(String id) async {
    final db = await SQLHelper.db();
    return db.query('subfamily', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getArticle(String id) async {
    final db = await SQLHelper.db();
    return db.query('article', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateFamily(
      {required String id, required String name, required String image}) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'image': image};
    final result =
        await db.update('family', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> updateSubFamily(
      {required String id, required String name, required String image}) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'image': image};
    final result =
        await db.update('subfamily', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> updateArticle(
      {required String idArticle,
      required String idFamily,
      required String name,
      required String img,
      required String codBar,
      required String regIvaVta,
      required int pvp,
      required bool beb}) async {
    final db = await SQLHelper.db();
    final data = {
      'id_family': idFamily,
      'name': name,
      'img': img,
      'cod_bar': codBar,
      'reg_iva_vta': regIvaVta,
      'pvp': pvp,
      'beb': beb ? 1 : 0
    };
    final result = await db
        .update('family', data, where: "id = ?", whereArgs: [idArticle]);
    return result;
  }

  static Future<void> deleteDatabase() async {
    String pathDatabase = await sql.getDatabasesPath();

    sql.databaseFactory.deleteDatabase(pathDatabase);
  }
}
