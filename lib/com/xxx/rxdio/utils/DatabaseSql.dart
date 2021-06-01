import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

///数据库做缓存sqlite
class DatabaseSql {
  static late Database database;
  static bool isDatabaseReady = false;
  static int dbVersion = 1;
  static String dbName = "httpCache.db";
  static String dbTableName = "HttpCache";

  // 初始化
  static Future initDatabase() {
    Future future = new Future(() async {
      String databasePath = await createDatabase();
      Database database = await openCacheDatabase(databasePath);
      DatabaseSql.database = database;
      isDatabaseReady = true;
      print("====数据库初始化完毕==>");
      return "0";
    });
    return future;
  }

  //创建数据库
  static Future<String> createDatabase() async {
    //获取数据库基本路径
    var databasePath = await getDatabasesPath();
    //创建数据的表名
    return join(databasePath, dbName);
  }

  //删除数据库
  static delDB() async {
    createDatabase().then((path) => {deleteDatabase(path)});
  }

  //打开数据库
  static Future<Database> openCacheDatabase(String paths) async {
    Database database =
        await openDatabase(paths, singleInstance: false, version: dbVersion,
            //如果没有表则创建表
            onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE If Not Exists $dbTableName (cacheKey TEXT PRIMARY KEY ,value TEXT)');
    },
            //如果表存在则直接打开
            onOpen: (Database db) async {
      await db.execute(
          'CREATE TABLE If Not Exists $dbTableName (cacheKey TEXT PRIMARY KEY ,value TEXT)');
    });
    return database;
  }

  //关闭数据库
  static closeDatabase(Database db) async {
    return db.close();
  }

  /*
   * 查询
   */
  static Future<List<Map<String, dynamic>>> queryHttp(
      Database database, String cacheKey) async {
    return await database.rawQuery(
        'SELECT value FROM $dbTableName WHERE cacheKey = \'' + cacheKey + "\'");
  }

  /*
   * 插入
   */
  static Future<int> insertHttp(
      Database database, String cacheKey, String value) async {
    cacheKey = cacheKey.replaceAll("\"", "\"\"");
    return await database.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO $dbTableName(cacheKey, value) VALUES( \'' +
              cacheKey +
              '\', \'' +
              value +
              '\')');
    });
  }

  /*
   * 更新
   */
  static Future<int> updateHttp(
      Database? database, String cacheKey, String value) async {
    cacheKey = cacheKey.replaceAll("\"", "\\\"");
    return await database!.rawUpdate('UPDATE $dbTableName SET '
            ' value = \'' +
        value +
        '\' WHERE '
            'cacheKey = \'' +
        cacheKey +
        '\'');
  }

  /*
   * 删除
   */
  static Future<int> deleteHttpCache(Database? database, String cacheKey) async {
    return await database!.rawDelete(
        'DELETE FROM $dbTableName WHERE name = \'' + cacheKey + '\'');
  }
}
