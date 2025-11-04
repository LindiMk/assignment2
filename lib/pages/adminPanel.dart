import 'package:assignment2/pages/admin_reviews.dart';
import 'package:assignment2/pages/appointments_review.dart';
import 'package:assignment2/routes/routes.dart';
import 'package:assignment2/service/login_or_register.dart';
import 'package:assignment2/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    //LoyOut
    logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const LoginOrRegister();
      }));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo3.jpg'),
            MyButton(
                onTap: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const AppointmentsManagementPage(),
                      ),
                    );
                  });
                },
                text: 'View Appointments'),
            const SizedBox(height: 16),
            MyButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReviewsManagementPage(),
                    ),
                  );
                },
                text: 'View Reviews')
          ],
        ),
      ),
    );
  }
}
