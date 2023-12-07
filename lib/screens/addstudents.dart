import 'dart:io';

import 'package:flutter/material.dart';
import 'package:week_5/database/studentdb.dart';
import 'package:week_5/screens/studentlist.dart';
import 'package:image_picker/image_picker.dart';
import 'package:week_5/screens/studentmodel.dart';

class AddStudents extends StatefulWidget {
  const AddStudents({super.key});

  @override
  State<AddStudents> createState() => _AddStudentsState();
}

class _AddStudentsState extends State<AddStudents> {
  final formkey = GlobalKey<FormState>();
  final nameEditingController = TextEditingController();
  final ageEditingController = TextEditingController();
  final placeEditingController = TextEditingController();
  final numberEditingController = TextEditingController();
  final idEditingController = TextEditingController();
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Student Information",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentList()),
                );
              },
              icon: Icon(
                Icons.person_search,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        File? pickedimage = await GetImageFromGallery(context);
                        setState(() {
                          selectedImage = pickedimage;
                        });
                      },
                      child: CircleAvatar(
                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!)
                            : null,
                        child: selectedImage == null
                            ? Icon(Icons.image_search)
                            : null,
                        backgroundColor: Colors.grey,
                        radius: 80,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextFormFieldWidget(
                    choice: TextInputType.number,
                    textEditingController: idEditingController,
                    textfieldvalidator: (value) {
                      if (value!.isEmpty) {
                        return "please enter your name";
                      } else if (value.length > 3) {
                        return "enter invalid number";
                      } else {
                        return null;
                      }
                    },
                    labeltext: 'ID',
                    iconname: Icon(Icons.person),
                  ),
                  TextFormFieldWidget(
                    choice: TextInputType.text,
                    textEditingController: nameEditingController,
                    textfieldvalidator: (value) {
                      if (value!.isEmpty) {
                        return "please enter your name";
                      } else if (value.length < 3) {
                        return "enter atleast 3 characters";
                      } else {
                        return null;
                      }
                    },
                    labeltext: "NAME",
                    iconname: Icon(Icons.person),
                  ),
                  TextFormFieldWidget(
                      choice: TextInputType.number,
                      textfieldvalidator: (value) {
                        if (value!.isEmpty) {
                          return "please enter your age";
                        } else if (value.length > 2) {
                          return "enter valid age";
                        } else {
                          return null;
                        }
                      },
                      textEditingController: ageEditingController,
                      labeltext: "AGE",
                      iconname: Icon(Icons.numbers)),
                  TextFormFieldWidget(
                      choice: TextInputType.text,
                      textfieldvalidator: (value) {
                        if (value!.isEmpty) {
                          return "please enter your place";
                        } else {
                          return null;
                        }
                      },
                      textEditingController: placeEditingController,
                      labeltext: "PLACE",
                      iconname: Icon(Icons.location_city)),
                  TextFormFieldWidget(
                      choice: TextInputType.number,
                      textfieldvalidator: (value) {
                        if (value!.isEmpty) {
                          return "please enter your number";
                        } else if (value.length != 10) {
                          return "enter a valid number";
                        } else {
                          return null;
                        }
                      },
                      textEditingController: numberEditingController,
                      labeltext: "NUMBER",
                      iconname: Icon(Icons.phone)),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          if (selectedImage == null) {
                            showSnackbar(
                                context, "please select a image", Colors.red);
                          } else {
                            final student = StudentModel(
                                id: int.parse(idEditingController.text),
                                name: nameEditingController.text,
                                age: int.parse(ageEditingController.text),
                                place: placeEditingController.text,
                                number: int.parse(numberEditingController.text),
                                imageurl: selectedImage!.path);
                            await addStudent(student, context);
                            showSnackbar(context, "Data successfully submitted",
                                Colors.green);
                            idEditingController.clear();
                            nameEditingController.clear();
                            ageEditingController.clear();
                            placeEditingController.clear();
                            numberEditingController.clear();
                            setState(() {
                              selectedImage = null;
                            });
                          }
                        }
                      },
                      child: Text("SUBMIT"),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.deepPurple)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required this.labeltext,
    required this.iconname,
    required this.textEditingController,
    required this.textfieldvalidator,
    required this.choice,
  });
  final String labeltext;
  final TextInputType choice;
  final Icon iconname;
  final TextEditingController textEditingController;
  final String? Function(String?)? textfieldvalidator;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: choice,
          validator: textfieldvalidator,
          controller: textEditingController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.deepPurple,
                width: 3,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.deepPurple,
                width: 3,
              ),
            ),
            prefixIcon: iconname,
            label: Text(labeltext),
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

Future<File?> GetImageFromGallery(BuildContext context) async {
  File? Image;
  try {
    final pickimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickimage != null) {
      Image = File(pickimage.path);
    }
  } catch (e) {
    // ignore: use_build_context_synchronously
    showSnackbar(context, e.toString(), Colors.red);
  }
  return Image;
}

void showSnackbar(
  BuildContext context,
  String content,
  Color color,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    backgroundColor: color,
  ));
}
