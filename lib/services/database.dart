import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClass {
  static DatabaseClass? databaseClass;
  static Database? _database;

  String table = "Expense";
  String id = "id";
  String name = "name";
  String expense = "expense";
  String date = "date";
  String timeStamp = "timeStamp";

  DatabaseClass._createInstance();

  factory DatabaseClass() {
    // ignore: unnecessary_null_comparison, prefer_conditional_assignment
    if (databaseClass == null) {
      databaseClass = DatabaseClass._createInstance();
    }
    return databaseClass!;
  }

  Future<Database> get database async {
    // ignore: unnecessary_null_comparison, prefer_conditional_assignment
    if (_database == null) {
      _database = await initializeDb();
    }

    return _database!;
  }

  Future<Database> initializeDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}Expenses.db';

    var expenseDatabase =
        await openDatabase(path, version: 1, onCreate: createDb);
    return expenseDatabase;
  }

  void createDb(Database db, int version) async {
    await db
        .execute('CREATE TABLE $table($id INTEGER PRIMARY KEY AUTOINCREMENT,'
            '$name TEXT, $expense TEXT, $date TEXT, $timeStamp TEXT)');
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    Database db = await database;
    var result =
        await db.rawQuery('SELECT * FROM $table ORDER BY $timeStamp DESC');

    return result;
  }

  Future<int> insertData(Expense e) async {
    Database db = await database;
    var result = await db.insert(table, e.toMap());
    return result;
  }

  Future<int> deleteData(int i) async {
    Database db = await database;
    var result = db.rawDelete('DELETE FROM $table WHERE $id = $i');
    return result;
  }
}
