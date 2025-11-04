import 'package:assignment2/models/user.dart';
import 'package:assignment2/routes/routes.dart';
import 'package:assignment2/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/button.dart';
import '../widgets/textField.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

String role = '';
final FirebaseAuthService _auth = FirebaseAuthService();
TextEditingController _controller = TextEditingController();
TextEditingController _email = TextEditingController();
TextEditingController _firstNames = TextEditingController();
TextEditingController _lastName = TextEditingController();
TextEditingController _password = TextEditingController();
TextEditingController _dOB = TextEditingController();
TextEditingController _iDNum = TextEditingController();
TextEditingController _contact = TextEditingController();
bool obscureText = true;

class _RegisterPageState extends State<RegisterPage> {
  //final _auth = FirebaseAuth.instance;
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
                      "Let's create an account for you",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Register as Admin ",
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
                          Navigator.of(context).pushNamed(RouteManager.admin);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldW(
                    icon: const Icon(Icons.email),
                    labelTxt: 'First Name',
                    hintTxt: 'first name(s)',
                    controller: _firstNames,
                    validator: (value) {
                      // Validate that the Email is not empty
                      if (value!.isEmpty) {
                        return 'Please enter your First Name(s)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFieldW(
                    icon: const Icon(Icons.email),
                    labelTxt: 'Last Name',
                    hintTxt: 'surname',
                    controller: _lastName,
                    validator: (value) {
                      // Validate that the Email is not empty
                      if (value!.isEmpty) {
                        return 'Please enter your Last Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFieldW(
                    icon: const Icon(Icons.email),
                    labelTxt: 'Email',
                    hintTxt: 'someone@gmail.com',
                    controller: _email,
                    validator: (value) {
                      // Validate that the Email is not empty
                      if (value!.isEmpty) {
                        return 'Please enter your Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFieldW(
                    icon: const Icon(Icons.email),
                    labelTxt: 'Date of Birth',
                    hintTxt: 'DD/MM/YYY',
                    controller: _dOB,
                    validator: (value) {
                      // Validate that the Email is not empty
                      if (value!.isEmpty) {
                        return 'Please enter your Date of birth';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFieldW(
                    icon: const Icon(Icons.email),
                    labelTxt: 'ID Number',
                    hintTxt: 'ID Number',
                    controller: _iDNum,
                    validator: (value) {
                      // Validate that the Email is not empty
                      if (value!.isEmpty) {
                        return 'Please enter your ID Number';
                      } else if (value.length < 12) {
                        return 'ID must be at least 13 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFieldW(
                    icon: const Icon(Icons.email),
                    labelTxt: 'Contact number',
                    hintTxt: 'Contact number',
                    controller: _contact,
                    validator: (value) {
                      // Validate that the Email is not empty
                      if (value!.isEmpty) {
                        return 'Please enter your Contact Number';
                      } else if (value.length < 9) {
                        return 'Contact must at least be 10 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
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
                    height: 15,
                  ),
                  MyButton(onTap: _signUp, text: 'Sign Up'),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already a member?',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  )
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
    String name = _firstNames.text;
    String email = _email.text;
    String password = _password.text;
    role = "User";
    postDetailsToFirestore(name);

    Future<User?> user = _auth.signUpWithEmailAndPassword(email, password);
    Navigator.of(context).pushNamed(RouteManager.login);
    // Display a Snackbar with the entered username
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$email successfully registered'),
      ),
    );
  }

  Future<void> postDetailsToFirestore(firstName) async {
    //Saving users data to firestore users collection
    FirebaseAuth auth = FirebaseAuth.instance;

    if (role == 'User') {
      await FirebaseFirestore.instance.collection("User").doc(_email.text).set({
        'Name': firstName,
        'Surname': _lastName.text,
        'Email': _email.text,
        'role': role,
        'DOB': _dOB.text,
        'Identity Number': _iDNum.text,
        'Contact Number': _contact.text,
        'Password': _password.text,
      });
      return;
    }
  }
}
