import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

///数据库做缓存sqlite
class DatabaseSql {
  Database? database;
  bool isDatabaseReady = false;
  int dbVersion = 1;
  String dbName = "httpCache.db";
  String dbTableName = "HttpCache";

  DatabaseSql() {
    initDatabase();
  }

  /// 初始化
  Future initDatabase() {
    Future future = new Future(() async {
      String databasePath = await createDatabase();
      Database database = await openCacheDatabase(databasePath);
      this.database = database;
      isDatabaseReady = true;
      print("====数据库初始化完毕==>");
      return "0";
    });
    return future;
  }

  ///创建数据库
  Future<String> createDatabase() async {
    //获取数据库基本路径
    var databasePath = await getDatabasesPath();
    //创建数据的表名
    return join(databasePath, dbName);
  }

  ///删除数据库
  delDB() async {
    createDatabase().then((path) => {deleteDatabase(path)});
  }

  ///删除表
  Future<bool?> clearData(Database? db) async {
    return await database
        ?.rawQuery('SELECT * FROM $dbTableName limit 1')
        .then((value) {
      return closeDb(db, value);
    });
  }

  ///删除表并关闭数据库
  Future<bool> closeDb(Database? db, List<Map<String, dynamic>> list) async {
    if (list.length > 0 && db != null) {
      db.execute('DROP TABLE $dbTableName');
      db.close();
      deleteDatabase(db.path);
      isDatabaseReady = false;
    } else {
      return false;
    }
    return true;
  }

  ///打开数据库
  Future<Database> openCacheDatabase(String paths) async {
    Database database =
        await openDatabase(paths, singleInstance: false, version: dbVersion,
            //如果没有表则创建表
            onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE If Not Exists $dbTableName (cacheKey TEXT PRIMARY KEY ,value TEXT)');
    }, //如果表存在则直接打开
            onOpen: (Database db) async {
      await db.execute(
          'CREATE TABLE If Not Exists $dbTableName (cacheKey TEXT PRIMARY KEY ,value TEXT)');
    });
    return database;
  }

  //关闭数据库
  closeDatabase(Database db) async {
    isDatabaseReady = false;
    return db.close();
  }

  //查询单条数据
  Future<String?> queryHttp(Database? database, String cacheKey) async {
    return await database
        ?.rawQuery('SELECT value FROM $dbTableName WHERE cacheKey = \'' +
            cacheKey +
            "\'")
        .then((value) {
      if (value.length > 0) {
        return value.first.values.first.toString();
      } else {
        return "";
      }
    });
  }

  ///查询
  Future<List<Map<String, dynamic>>> queryAll(
      Database database, String cacheKey) async {
    return await database.rawQuery(
        'SELECT value FROM $dbTableName WHERE cacheKey = \'' + cacheKey + "\'");
  }

  ///插入
  Future<int?> insertHttp(
      Database? database, String cacheKey, String value) async {
    cacheKey = cacheKey.replaceAll("\"", "\"\"");
    return await database?.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO $dbTableName(cacheKey, value) VALUES( \'' +
              cacheKey +
              '\', \'' +
              value +
              '\')');
    });
  }

  ///更新
  Future<int> updateHttp(
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

  ///删除
  Future<int> deleteHttpCache(Database? database, String cacheKey) async {
    return await database!.rawDelete(
        'DELETE FROM $dbTableName WHERE name = \'' + cacheKey + '\'');
  }
}
