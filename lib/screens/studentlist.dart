import 'dart:io';
import 'package:flutter/material.dart';
import 'package:week_5/database/studentdb.dart';
import 'package:week_5/screens/editscreen.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

late List<Map<String, dynamic>> listofStudentsData = [];
final SearchController = TextEditingController();

class _StudentListState extends State<StudentList> {
  @override
  Future<void> collectStudentdata() async {
    List<Map<String, dynamic>> listofStudents = await getAllstudents();
    if (SearchController.text.isNotEmpty) {
      listofStudents = listofStudents
          .where((Student) => Student['name']
              .toString()
              .toLowerCase()
              .contains(SearchController.text.toLowerCase()))
          .toList();
    }
    setState(() {
      listofStudentsData = listofStudents;
    });
  }

  void initState() {
    listofStudentsData = [];
    collectStudentdata();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: SearchController,
              onChanged: (value) {
                setState(() {
                  collectStudentdata();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Enter your name to search',
                prefixIcon:
                    IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            if (listofStudentsData.isEmpty)
              Center(child: Text("No students available."))
            else
              Expanded(
                child: ListView.separated(
                  itemCount: listofStudentsData.length,
                  itemBuilder: (context, index) {
                    final studentMap = listofStudentsData[index];
                    final id = studentMap['id'];
                    final imageurl = studentMap['imageurl'];
                    final name = studentMap['name'];
                    return ListTile(
                      title: Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                      leading: CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(imageurl)),
                      ),
                      subtitle: Text(id.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditScreen(
                                            id: id,
                                            name: name,
                                            imageurl: imageurl,
                                            age: studentMap['age'],
                                            place: studentMap['place'],
                                            number: studentMap['number'],
                                          )), // Correct the builder
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm Deletion"),
                                      content: Text(
                                          "Are you sure you want to delete this student?"),
                                      actions: [
                                        TextButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Yes"),
                                          onPressed: () async {
                                            await deleteStudent(id);
                                            await collectStudentdata();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
