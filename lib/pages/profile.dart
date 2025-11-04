import 'package:assignment2/models/user.dart';
import 'package:assignment2/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late final TextEditingController nameController;
  late final TextEditingController lastnameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController dobController;
  late final TextEditingController idNrController;
  late final TextEditingController cellphoneNrController;

  late String _userEmail = '';
  late User? _currentUser;
  bool _loading = false;

  void initializeControllers() {
    nameController = TextEditingController();
    lastnameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    dobController = TextEditingController();
    idNrController = TextEditingController();
    cellphoneNrController = TextEditingController();
  }

  @override
  void initState() {
    initializeControllers();
    super.initState();
    _getCurrentUser();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  void disposeControllers() {
    nameController.dispose();
    emailController.dispose();
    lastnameController.dispose();
    passwordController.dispose();
    dobController.dispose();
    idNrController.dispose();
    cellphoneNrController.dispose();
  }

  Future<void> _getCurrentUser() async {
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _userEmail = _currentUser!.email!;
      final userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(_userEmail)
          .get();
      if (userDoc.exists) {
        setState(() {
          nameController.text = userDoc['Name'];
          emailController.text = userDoc['Email'];
          lastnameController.text = userDoc['Surname'];
          dobController.text = userDoc['DOB'];
          idNrController.text = userDoc['Identity Number'];
          cellphoneNrController.text = userDoc['Contact Number'];
          passwordController.text = userDoc['Password'];
          _loading = false;
        });
      }
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        lastnameController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        idNrController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        cellphoneNrController.text.isNotEmpty) {
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser!.email != null) {
          await FirebaseFirestore.instance
              .collection('User')
              .doc(currentUser.email)
              .update({
            'Name': nameController.text,
            'Surname': lastnameController.text,
            'Email': emailController.text,
            'Identity Number': idNrController.text,
            'DOB': dobController.text,
            'Contact Number': cellphoneNrController.text,
            'Password': passwordController.text,
          });

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('${nameController.text}, your profile has been updated'),
            ),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $error'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Text("My Profile"),
            const Icon(
              Icons.list,
              size: 25,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 13, left: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Card(
                color: Colors.white,
                shadowColor: Colors.black,
                elevation: 15,
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Email: ${emailController.text}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        IconButton(
                          onPressed: () {
                            dialogEditor(context, emailController);
                          },
                          icon: const Icon(
                            Icons.mode_edit,
                            size: 25,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Card(
                color: Colors.white,
                shadowColor: Colors.black,
                elevation: 15,
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 15, bottom: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name(s): ${nameController.text}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        IconButton(
                          onPressed: () {
                            dialogEditor(context, nameController);
                          },
                          icon: const Icon(
                            Icons.mode_edit,
                            size: 25,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Card(
                color: Colors.white,
                shadowColor: Colors.black,
                elevation: 15,
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Surname: ${lastnameController.text}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        IconButton(
                          onPressed: () {
                            dialogEditor(context, lastnameController);
                          },
                          icon: const Icon(
                            Icons.mode_edit,
                            size: 25,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Card(
                color: Colors.white,
                shadowColor: Colors.black,
                elevation: 15,
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "DOB: ${dobController.text}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        IconButton(
                          onPressed: () {
                            dialogEditor(context, dobController);
                          },
                          icon: const Icon(
                            Icons.mode_edit,
                            size: 25,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Card(
                color: Colors.white,
                shadowColor: Colors.black,
                elevation: 15,
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ID No: ${idNrController.text}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        IconButton(
                          onPressed: () {
                            dialogEditor(context, idNrController);
                          },
                          icon: const Icon(
                            Icons.mode_edit,
                            size: 25,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Card(
                color: Colors.white,
                shadowColor: Colors.black,
                elevation: 15,
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Password: ${passwordController.text}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        IconButton(
                          onPressed: () {
                            dialogEditor(context, passwordController);
                          },
                          icon: const Icon(
                            Icons.mode_edit,
                            size: 25,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: Container(
                height: 60,
                width: 187,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _updateProfile;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> dialogEditor(BuildContext context, text) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
                height: 110,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: text,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                text = text;
                                Navigator.pop(context);
                              });
                            },
                            child: const Text("Done"),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          );
        });
  }
}
