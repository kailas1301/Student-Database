import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:week_5/screens/studentmodel.dart';

late Database _database;
Future<void> createDatabase() async {
  _database = await openDatabase(
    "student.db",
    version: 1,
    onCreate: (Database _database, int versionn) async {
      await _database.execute(
          'CREATE TABLE student(id INTEGER PRIMARY KEY NOT NULL, name TEXT, age INTEGER, place TEXT, number REAL, imageurl )');
    },
  );
}

Future<void> addStudent(StudentModel value, BuildContext context) async {
  await _database.rawInsert(
    'INSERT INTO student(id, name, age, place, number, imageurl) VALUES(?, ?, ?, ?, ?, ?)',
    [
      value.id,
      value.name,
      value.age,
      value.place,
      value.number,
      value.imageurl,
    ],
  );
}

Future<List<Map<String, dynamic>>> getAllstudents() async {
  final _values = await _database.rawQuery('SELECT * FROM student');
  return _values;
}

Future<void> deleteStudent(int id) async {
  await _database.rawDelete('DELETE FROM student WHERE id = ?', [id]);
}

Future<void> updateStudent(StudentModel updatedStudent) async {
  await _database.update(
    'student',
    {
      'name': updatedStudent.name,
      'age': updatedStudent.age,
      'place': updatedStudent.place,
      'number': updatedStudent.number,
      'imageurl': updatedStudent.imageurl,
    },
    where: 'id = ?',
    whereArgs: [updatedStudent.id],
  );
}
