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
    print("Database opened at path: $path");
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

    print("Inserting initial data...");

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
       //group 1 computer
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time,class_no) VALUES (10613, 'CCE414', 'DR: Mohammed Hussien', 'Lecture', 'Sunday', '9:00', '10:30','NP200')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time,class_no) VALUES (10617, 'CCE413', 'DR: Walaa Gouda', 'Lecture', 'Sunday', '10:40', '12:10','NP100')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10619, 'CCE413', 'ENG: Mohammed Muhie', 'Lab', 'Tuesday', '02:10', '4:30','SB5-09')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10624, 'CCE407', 'ENG: Anas AL-Said', 'Lab', 'Sunday', '12:30', '02:55','SB5-09')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10623, 'CCE407', 'DR: Ashraf Hafez', 'Lecture', 'Thursday', '12:30', '02:00','NP306')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10614, 'CCE414', 'ENG: Mostafa Amin', 'Section', 'Tuesday', '09:00', '10:30','NP200')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10655, 'CCE408', 'DR: Maher Abd EL-Rasoul', 'Lecture', 'Thursday', '09:00', '10:30','NP305')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10656, 'CCE408', 'ENG: Shaimaa Ezzat', 'Section', 'Thursday', '10:40', '12:10','NP204')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10668, 'CCE412', 'TA: Mostafa Amin', 'Lab', 'Tuesday', '10:40', '12:55','NP103')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10667, 'CCE412', 'DR: Lamiaa ALrefaai', 'Lecture', 'Wednesday', '09:00', '10:30','NP305')''',
      //group 1 First semester
      
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10650, 'CCE401', 'DR: Ali Gomaa & DR: Shimaa Salama', 'Lecture', 'Wednesday', '09:00', '10:30','NP103')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10652, 'CCE401', 'TA: Salah Khalil', 'Lab', 'Tuesday', '09:45', '12:10','SB5-02')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10674, 'CCE404', 'DR: Michael Nasif & DR: Christina' , 'Lecture', 'Wednesday', '10:40', '12:10','NP104')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10675, 'CCE404', 'TA: Ahmed Tolba', 'Section', 'Tuesday', '02:10', '03:40','NP104')''',
      //group 1 (communication)
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time,class_no) VALUES (10661, 'CCE409', 'DR: Eslam Mansour', 'Lecture', 'Sunday', '12:30', '02:00', 'NP200')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10662, 'CCE409', 'TA: Basma Ashraf', 'Section', 'Sunday', '02:10', '03:40', 'NP104')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time,class_no) VALUES (10671, 'CCE410', 'DR: Reham Samir & DR: Shimaa Salama','Lecture', 'Wednesday', '12:30', '02:00','NP305')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10673, 'CCE409', 'TA: Shaimaa Ezzat', 'Lab', 'Wednesday', '01:15', '03:40','SB5-02')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10629, 'CCE411', 'DR: Gehan Samy', 'Lecture', 'Sunday', '10:40', '12:10','NP101')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10630, 'CCE411', 'TA: Sara Lotfy', 'Lab', 'Wednesday', '10:40', '01:15','SB5-15')''',
      //group 2 computer
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10615, 'CCE414', 'DR: Mohammed Hussien', 'Lecture', 'Sunday', '10:40', '12:10','NP200')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10620, 'CCE413', 'DR: Walaa Gouda', 'Lecture', 'Sunday', '12:30', '02:00','NP100')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10622, 'CCE413', 'ENG: Mohammed Muhie', 'Lab', 'Tuesday', '09:45', '12:10','SB5-09')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10626, 'CCE407', 'ENG: Anas AL-Said', 'Lab', 'Wednesday', '12:30', '02:55','SB5-09')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10625, 'CCE407', 'DR: Ashraf Hafez', 'Lecture', 'Thursday', '10:40', '12:10','NP306')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10616, 'CCE414', 'ENG: Mostafa Amin', 'Section', 'Tuesday', '02:10', '03:40','NP200')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10657, 'CCE408', 'DR: Maher Abd EL-Rasoul', 'Lecture', 'Thursday', '12:30', '02:00','NP305')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10658, 'CCE408', 'ENG: Shaimaa Ezzat', 'Section', 'Thursday', '02:10', '03:40','NP204')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10670, 'CCE412', 'TA: Mostafa Amin', 'Lab', 'Tuesday', '03:45', '06:00','NP104')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10669, 'CCE412', 'DR: Lamiaa ALrefaai', 'Lecture', 'Wednesday', '10:40', '12:10','NP305')''',
      //group 3
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10628, 'CCE407', 'ENG: Anas AL-Said', 'Lab', 'Thursday', '02:10', '04:30','SB5-09')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10627, 'CCE407', 'DR: Ashraf Hafez', 'Lecture', 'Thursday', '09:00', '10:30','NP306')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10659, 'CCE408', 'DR: Maher Abd EL-Rasoul', 'Lecture', 'Thursday', '10:40', '12:10','NP305')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10660, 'CCE408', 'ENG: Shaimaa Ezzat', 'Section', 'Thursday', '12:30', '02:00','NP204')''',
      //General session
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10545, 'GEN301', 'DR: Amr Hanafy', 'Lecture', 'Sunday', '12:10', '03:40','NP100')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10546, 'GEN402', 'DR: Mahmoud Salah', 'Lecture', 'Sunday', '03:45', '05:15','NP100')''',
      '''INSERT INTO session (session_ID, course_ID, instructor, type, day, start_time, end_time, class_no) VALUES (10551, 'GEN302', 'DR: Mahmoud Salah & DR: Amani', 'Lecture', 'Wednesday', '03:45', '05:15','NP100')''',
    ];

    for (String query in sessionQueries) {
      await db.rawInsert(query);
    }

    print("Initial data inserted.");
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
