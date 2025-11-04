// ignore_for_file: unused_local_variable

import 'package:assignment2/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
bool obscureText = true;

@override
void Dispose() {
  _email.dispose();
  _password.dispose();
}

class _LoginPageState extends State<LoginPage> {
  //final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Container(
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                height: 300,
                width: 150,
                child: const Text(
                  "Hospital\n   Management",
                  style: TextStyle(
                      fontSize: 50,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    hintText: 'someone@gmail.com',
                  ),
                  controller: _email,
                  validator: (value) {
                    // Validate that the Email is not empty
                    if (value!.isEmpty) {
                      return 'Please enter your Email';
                    } else if (!value.contains(RegExp(r'@'))) {
                      return 'The inclusion of  an @ is missing';
                    }
                    return null;
                  },
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25),
                child: TextFormField(
                  controller: _password,
                  validator: (value) {
                    // Validate that the password is not empty and has at least 8 characters
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }

                    return null;
                  },
                  obscureText: obscureText,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'xxxxx',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: obscureText
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      )),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      try {
                        String email = _email.text;
                        String password = _password.text;
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, password: password);
                        //
                        var kk = FirebaseFirestore.instance
                            .collection('User')
                            .doc(email)
                            .get()
                            .then((DocumentSnapshot documentSnapshot) {
                          if (documentSnapshot.exists) {
                            if (documentSnapshot.get('role') == "User") {
                              Navigator.of(context)
                                  .pushNamed(RouteManager.homePage);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Signed in as: $email')),
                              );
                            }
                          }
                        });
                        var ka = FirebaseFirestore.instance
                            .collection('Admin')
                            .doc(email)
                            .get()
                            .then((DocumentSnapshot documentSnapshot) {
                          if (documentSnapshot.exists) {
                            if (documentSnapshot.get('role') == "Admin") {
                              Navigator.of(context)
                                  .pushNamed(RouteManager.adminPanel);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Signed in as: $email')),
                              );
                            }
                          }
                        });
                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.transparent)),
                    child: const Text('Sign in',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not a member?',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
