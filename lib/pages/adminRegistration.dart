import 'package:assignment2/routes/routes.dart';
import 'package:assignment2/service/auth_service.dart';
import 'package:assignment2/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminRegistration extends StatefulWidget {
  const AdminRegistration({super.key});

  @override
  State<AdminRegistration> createState() => _AdminRegistrationState();
}

class _AdminRegistrationState extends State<AdminRegistration> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool obscureText = true;
  String role = '';
  final FirebaseAuthService _auth = FirebaseAuthService();

  void Dispose() {
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          child: Container(
            color: Colors.grey[100],
            child: Container(
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 180,
                    width: 150,
                    child: const Text(
                      "Hospital\n   Management",
                      style: TextStyle(
                          fontSize: 50,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Let's create an account for you as Admin",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Register as User ",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                      GestureDetector(
                        child: const Text(
                          "Here",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(RouteManager.login);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
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
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25, left: 25),
                    child: TextFormField(
                      controller: _password,
                      obscureText: obscureText,
                      validator: (value) {
                        // Validate that the password is not empty and has at least 8 characters
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        if (!value.contains(RegExp(r'@'))) {
                          return 'The inclusion on an @ is missing';
                        }
                        return null;
                      },
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
                    height: 35,
                  ),
                  MyButton(
                      onTap: () {
                        setState(() {
                          _signUp();
                        });
                      },
                      text: 'Sign Up Admin')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    String email = _email.text;
    String password = _password.text;
    role = "Admin";
    postDetailsToFirestore(email);

    Future<User?> user = _auth.signUpWithEmailAndPassword(email, password);
    Navigator.of(context).pushNamed(RouteManager.login);
    // Display a Snackbar with the entered username
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Admin $email successfully registered'),
      ),
    );
  }

  Future<void> postDetailsToFirestore(firstName) async {
    //Saving users data to firestore users collection
    FirebaseAuth auth = FirebaseAuth.instance;

    if (role == 'Admin') {
      await FirebaseFirestore.instance.collection("Admin").doc(_email.text).set(
          {'Email': _email.text, 'role': role, 'Password': _password.text});
      return;
    }
  }
}
