import 'package:flutter/material.dart';
import 'package:week_5/database/studentdb.dart';
import 'package:week_5/screens/addstudents.dart';
import 'package:week_5/screens/studentlist.dart';
import 'dart:io';

import 'package:week_5/screens/studentmodel.dart';

class EditScreen extends StatefulWidget {
  const EditScreen(
      {super.key,
      required this.id,
      required this.name,
      required this.age,
      required this.place,
      required this.number,
      required this.imageurl});
  final int id;
  final String name;
  final int age;
  final String place;
  final double number;
  final dynamic imageurl;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formkey = GlobalKey<FormState>();
  late TextEditingController nameEditingController;
  late TextEditingController ageEditingController;
  late TextEditingController placeEditingController;
  late TextEditingController numberEditingController;
  late TextEditingController idEditingController;
  File? selectedImage;

  @override
  void initState() {
    nameEditingController = TextEditingController(text: widget.name);
    ageEditingController = TextEditingController(text: widget.age.toString());
    placeEditingController = TextEditingController(text: widget.place);
    int number = widget.number.toInt();
    numberEditingController = TextEditingController(text: number.toString());
    idEditingController = TextEditingController(text: widget.id.toString());
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "UPDATE DETAILS",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
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
                            : FileImage(File(widget.imageurl)),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
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
                          if (selectedImage != null ||
                              widget.imageurl != null) {
                            final student = StudentModel(
                                id: int.parse(idEditingController.text),
                                name: nameEditingController.text,
                                age: int.parse(ageEditingController.text),
                                place: placeEditingController.text,
                                number: int.parse(numberEditingController.text),
                                imageurl: selectedImage == null
                                    ? widget.imageurl
                                    : selectedImage!.path);
                            await updateStudent(student);
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
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StudentList(),
                            ));
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
