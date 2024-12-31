import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // 싱글턴(Singleton) 패턴
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // DB 인스턴스를 얻는 getter
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('your_database_name.db'); // 파일명 적절히
    // Log.info("Database init at $_database"); // logger 사용시
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    Directory documentsDirectory;
    // iOS는 getLibraryDirectory, Android는 getApplicationDocumentsDirectory
    if (Platform.isIOS) {
      documentsDirectory = await getLibraryDirectory();
    } else {
      documentsDirectory = await getApplicationDocumentsDirectory();
    }

    final dbPath = join(documentsDirectory.path, dbName);

    // DB 오픈
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDB,
      // onUpgrade: _upgradeDB, // 필요시 구현
    );
  }

  // DB 테이블 생성
  Future<void> _createDB(Database db, int version) async {
    // pick 테이블 생성
    await db.execute('''
      CREATE TABLE pick (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    // 필요하다면 다른 테이블도 생성
    // await db.execute('''
    //   CREATE TABLE some_other_table (
    //     ...
    //   )
    // ''');
  }

// 필요하다면 DB 버전 업그레이드 로직도 추가할 수 있음
// Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
//   if (oldVersion < newVersion) {
//     // 테이블 추가, 마이그레이션 로직 등
//   }
// }
}
