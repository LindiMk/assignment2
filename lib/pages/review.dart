import 'package:assignment2/models/user.dart';
import 'package:assignment2/routes/routes.dart';
import 'package:assignment2/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Review extends StatefulWidget {
  const Review({super.key});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hospital = TextEditingController();
  final TextEditingController _review = TextEditingController();

  Future<void> _submitReview() async {
    if (_hospital.text.isNotEmpty && _review.text.isNotEmpty) {
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          // Handle case where user is not logged in
          return;
        }

        await FirebaseFirestore.instance
            .collection('Reviews')
            .doc(currentUser.email.toString())
            .set({
          'Hospital': _hospital.text,
          'Review': _review.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${currentUser.email.toString()}, your review is received'),
          ),
        );
        Navigator.of(context).pushNamed(RouteManager.homePage);
        // Optionally, clear the text fields after submission
        _hospital.clear();
        _review.clear();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit review: $error'),
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
    return Consumer<UserState>(
        builder: (BuildContext context, value, Widget? child) {
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
              const Text("Review"),
              const Icon(
                Icons.list,
                size: 25,
              )
            ],
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.only(right: 13, left: 13),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Center(
                    child: Text(
                      "Leave a review for your last Appointment",
                      style:
                          TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 80,
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
                        child: TextFormField(
                          controller: _hospital,
                          decoration: const InputDecoration(
                            labelText: 'Hospital Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Hospital Name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 192,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Review/Feedback',
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _review,
                              minLines: 3,
                              maxLines: 10,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Review';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MyButton(
                      onTap: () {
                        setState(() {
                          if (_formKey.currentState!.validate()) {
                            _submitReview();
                            // Navigator.of(context)
                            //     .pushNamed(RouteManager.homePage);
                            // Display a Snackbar with the entered username
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "${value.user?.email}, your review is received")),
                            );
                          }
                        });
                      },
                      text: 'Submit')
                ],
              ),
            )),
      );
    });
  }
}
