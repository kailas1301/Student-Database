import 'package:flutter/material.dart';
import 'package:week_5/database/studentdb.dart';
import 'package:week_5/screens/addstudents.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await createDatabase();
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AddStudents(),
    );
  }
}
