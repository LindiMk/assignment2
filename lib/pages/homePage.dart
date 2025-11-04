import 'package:assignment2/routes/routes.dart';
import 'package:assignment2/service/login_or_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController emailController;

  late String _userEmail = '';
  late User? _currentUser;
  bool _loading = false;

  void initializeControllers() {
    emailController = TextEditingController();
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
    emailController.dispose();
  }

  //LoyOut
  _logout() async {
    FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const LoginOrRegister();
    }));
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
          emailController.text = userDoc['Email'];
        });
      }
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text('Hospital Management App'),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Center(
            child: Text(
              "Welcome: ${emailController.text}",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
          SizedBox(
            height: 450,
            child: Image.asset('assets/logo3.jpg'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 60,
                width: 198,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context)
                            .pushNamed(RouteManager.appointment);
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.black)),
                    child: Row(
                      children: [
                        const Text('Appointment',
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w400,
                                color: Colors.white)),
                        const SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.create,
                          color: Colors.blue[500],
                        )
                      ],
                    )),
              ),
              Container(
                height: 60,
                width: 187,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pushNamed(RouteManager.review);
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.black)),
                    child: Row(
                      children: [
                        const Text(
                          'Review',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.list_alt_outlined,
                            size: 30, color: Colors.blue[500])
                      ],
                    )),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 60,
            width: 197,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pushNamed(RouteManager.profile);
                  });
                },
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.black)),
                child: Container(
                  child: Row(
                    children: [
                      const Text(
                        'My Profile',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.blue[500],
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
        tooltip: 'Log out',
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.lock),
      ),
    );
  }
}
