// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database?> get db async {
    _db ??= await initialDb();
    return _db;
  }

  Future<Database> initialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'university_database.db');
    Database mydb = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    print("📁 Database opened at path: $path");
    return mydb;
  }

  Future<void> _onCreate(Database db, int version) async {
    print("🛠 Creating database tables...");

    await db.execute('''
      CREATE TABLE student (
        user_id TEXT,
        ID INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT,
        year INTEGER,
        grade REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE course (
        course_ID TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        credit_hours INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE class (
        class_no TEXT PRIMARY KEY,
        building TEXT,
        floor_no TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE session (
        session_ID INTEGER PRIMARY KEY,
        course_ID TEXT,
        instructor TEXT,
        type TEXT,
        day TEXT,
        start_time TEXT,
        end_time TEXT,
        class_no TEXT,
        FOREIGN KEY (course_ID) REFERENCES course(course_ID) ON DELETE CASCADE,
        FOREIGN KEY (class_no) REFERENCES class(class_no) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE enrollment (
        student_id INTEGER,
        course_ID TEXT,
        PRIMARY KEY (student_id, course_ID),
        FOREIGN KEY (student_id) REFERENCES student(ID) ON DELETE CASCADE,
        FOREIGN KEY (course_ID) REFERENCES course(course_ID) ON DELETE CASCADE
      )
    ''');

    print("📥 Inserting initial data...");

    // Insert class data
    List<String> insertClassQueries = [
      "INSERT INTO class (class_no, building, floor_no) VALUES ('NP100', 'Credit', '1')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('NP101', 'Credit', '1')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('NP102', 'Credit', '1')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('NP103', 'Credit', '1')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('NP104', 'Credit', '1')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('NP200', 'Credit', '2')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('NP201', 'Credit', '2')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('NP202', 'Credit', '2')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('NP204', 'Credit', '2')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('NP205', 'Credit', '2')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('NP303', 'Credit', '3')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('NP306', 'Credit', '3')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('NP305', 'Credit', '3')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('NP309', 'Credit', '3')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('SB5-02', 'Mainstream', '5')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('SB5-09', 'Mainstream', '5')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('SB5-15', 'Mainstream', '5')",
      "INSERT INTO class (class_no, building, floor_no) VALUES ('SB5-16', 'Mainstream', '5')"
    ];

    for (String query in insertClassQueries) {
      await db.rawInsert(query);
    }

    // Insert course data
    List<String> courseInserts = [
      "INSERT INTO course (course_ID, name, credit_hours) VALUES ('CCE407', 'Embedded Systems', 3)",
      "INSERT INTO course (course_ID, name, credit_hours) VALUES ('CCE413', 'Database Systems', 4)",
      "INSERT INTO course (course_ID, name, credit_hours) VALUES ('CCE414', 'Artificial Intelligence', 3)",
      "INSERT INTO course (course_ID, name, credit_hours) VALUES ('CCE411', 'Microwave Engineering', 3)",
      "INSERT INTO course (course_ID, name, credit_hours) VALUES ('CCE409', 'Communication Circuits', 3)",
      "INSERT INTO course (course_ID, name, credit_hours) VALUES ('CCE412', 'Mobile Computing', 3)",
      "INSERT INTO course (course_ID, name, credit_hours) VALUES ('CCE401', 'Communication Systems', 3)",
      "INSERT INTO course (course_ID, name, credit_hours) VALUES ('CCE404', 'Digital Signal Processing', 3)",
      "INSERT INTO course (course_ID, name, credit_hours) VALUES ('CCE408', 'Information Theory and Coding', 3)",
      "INSERT INTO course (course_ID, name, credit_hours) VALUES ('CCE410', 'Digital Communications', 3)",
      "INSERT INTO course (course_ID, name, credit_hours) VALUES ('GEN301', 'Leadership', 2)",
      "INSERT INTO course (course_ID, name, credit_hours) VALUES ('GEN302', 'Professional Ethics', 2)",
      "INSERT INTO course (course_ID, name, credit_hours) VALUES ('GEN102', 'Human Resource Management', 2)"
    ];

    for (String query in courseInserts) {
      await db.rawInsert(query);
    }

    // Insert session data
    List<String> sessionQueries = [
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no)
        VALUES (10613, 'CCE414', 'DR: Mohammed Hussien', 'Lecture', 'Sunday', '9:00', '10:30', 'NP200')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no)
        VALUES (10545, 'GEN301', 'DR: Amr Hanafy', 'Lecture', 'Sunday', '12:10', '03:40', 'NP100')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no)
        VALUES (10551, 'GEN302', 'DR: Mahmoud Salah & DR: Amani', 'Lecture', 'Wednesday', '03:45', '05:15', 'NP100')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no)
        VALUES (10614, 'CCE414', 'ENG: Mostafa Amin', 'Section', 'Tuesday', '09:00', '10:30', 'NP200')'''
    ];

    for (String query in sessionQueries) {
      await db.rawInsert(query);
    }

    print("✅ Initial data inserted.");
  }

  Future<List<Map>> readData(String sql) async {
    Database? mydb = await db;
    return await mydb!.rawQuery(sql);
  }

  Future<int> insertData(String sql) async {
    Database? mydb = await db;
    return await mydb!.rawInsert(sql);
  }

  Future<int> updateData(String sql) async {
    Database? mydb = await db;
    return await mydb!.rawUpdate(sql);
  }

  Future<int> deleteData(String sql) async {
    Database? mydb = await db;
    return await mydb!.rawDelete(sql);
  }
}
