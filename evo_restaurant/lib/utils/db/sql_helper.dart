import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""
    CREATE TABLE families(
    id TEXT PRIMARY KEY NOT NULL UNIQUE, 
    name TEXT NOT NULL, 
    img TEXT
    )
    """);

    await database.execute("""
      CREATE TABLE subfamilies(
    id TEXT PRIMARY KEY NOT NULL UNIQUE, 
    id_family TEXT NOT NULL,
    name TEXT NOT NULL, 
    img TEXT
    )
      """);

    await database.execute(""" 
    CREATE TABLE articles(
    id INTEGER PRIMARY KEY NOT NULL UNIQUE, 
    id_family TEXT NOT NULL, 
    id_sub_family TEXT,
    name TEXT, 
    img TEXT, 
    cod_bar TEXT, 
    reg_iva_vta TEXT, 
    pvp INTEGER, 
    beb BIT
    )
    """);
  }

  ///
  /// Open the data base is exist, otherwise create a new data base
  ///
  ///
  static Future<sql.Database> db() async {
    return sql.openDatabase(
        path.join(await sql.getDatabasesPath(), 'evorestaurant.db'),
        version: 1, onCreate: (sql.Database database, int version) async {
      await createTable(database);
      debugPrint("......Created database......");
    });
  }

  static Future<int> createFamily(
      String idFamily, String name, String? img) async {
    final db = await SQLHelper.db();
    final data = {'id': idFamily, 'name': name, 'img': img};
    final id = await db.insert('families', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  ///This method helps insert a map of values into the specified
  ///table and returns the id of the last inserted row.
  ///return int
  static Future<int> createSubFamily(
      {required String idSubFamily,
      required String idFamily,
      required String name,
      required String img}) async {
    final db = await SQLHelper.db();
    final data = {
      'id': idSubFamily,
      'id_family': idFamily,
      'name': name,
      'img': img
    };
    final id = await db.insert('subfamilies', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  ///
  /// This method helps insert a map of values into
  /// the specified table and returns the id of the last inserted row.
  ///
  /// return int: last id inserted
  static Future<int> createArticle(
      {required String idArticle,
      required String idFamily,
      String? idSubfamily,
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
      'id_sub_family': idSubfamily,
      'name': name,
      'img': img,
      'cod_bar': codBar,
      'reg_iva_vta': regIvaVta,
      'pvp': pvp,
      'beb': beb ? 1 : 0
    };
    final id = await db.insert('articles', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  ///
  /// Open de Data base calling SQLHelper.db().
  /// if data base isn't exist, it will create the data base.
  ///
  /// return a list that contains families that are in the data base
  /// ordered by id.
  ///
  ///
  static Future<List<Map<String, dynamic>>> getFamilies() async {
    final db = await SQLHelper.db();
    return db.query('families', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getSubFamilies() async {
    final db = await SQLHelper.db();
    return db.query('subfamilies', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getArticles() async {
    final db = await SQLHelper.db();

    return db.query('articles');
  }

  static Future<List<Map<String, dynamic>>> getFamily(String id) async {
    final db = await SQLHelper.db();
    return db.query('families', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getSubFamily(String id) async {
    final db = await SQLHelper.db();
    return db.query('subfamilies', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getSubFamiliesByIdOfFamily(
      String idFamily) async {
    final db = await SQLHelper.db();
    return db.query('subfamilies',
        where: "id_family =?", whereArgs: [idFamily]);
  }

  static Future<List<Map<String, dynamic>>> getArticle(String id) async {
    final db = await SQLHelper.db();
    return await db.query('articles', where: "id = ?", whereArgs: [int.tryParse(id)], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getArticlesByFamilyId(
      String familyId) async {
    final db = await SQLHelper.db();
    return db.query('articles', where: "id_family = ?", whereArgs: [familyId]);
  }

  static Future<List<Map<String, dynamic>>> getArticlesBySubFamilyId(
      String subFamilyId) async {
    final db = await SQLHelper.db();
    return db.query('articles',
        where: "id_sub_family = ?", whereArgs: [subFamilyId]);
  }

  static Future<int> updateFamily(
      {required String id, required String name, required String image}) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'image': image};
    final result =
        await db.update('families', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> updateSubFamily(
      {required String id, required String name, required String image}) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'image': image};
    final result =
        await db.update('subfamilies', data, where: "id = ?", whereArgs: [id]);
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
    final batch = db.batch();
    batch.update('articles', data, where: "id = ?", whereArgs: [idArticle]);
    List<Object?> result = await batch.commit();
    return result.first as int;
  }

  static Future<int> deleteFamily(String id) async {
    final db = await SQLHelper.db();
    final batch = db.batch();
    batch.delete('families', where: 'id = ?', whereArgs: [id]);
    List<Object?> result = await batch.commit();
    return result.first as int;
  }

  static Future<int> deleteSubFamily(String id) async {
    final db = await SQLHelper.db();
    final batch = db.batch();
    batch.delete('subfamilies', where: 'id = ?', whereArgs: [id]);
    List<Object?> result = await batch.commit();
    return result.first as int;
  }

  static Future<int> deleteArticle(String id) async {
    final db = await SQLHelper.db();
    final result = db.delete('articles', where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteDatabase() async {
    String pathDatabase = await sql.getDatabasesPath();

    sql.databaseFactory.deleteDatabase(pathDatabase);
  }

  static Future close() async {
    final db = await SQLHelper.db();
    db.close();
  }
}
