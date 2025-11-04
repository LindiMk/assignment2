import 'package:assignment2/routes/routes.dart';
import 'package:assignment2/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  final _formKey = GlobalKey<FormState>();
  DateTime eventDate = DateTime.now();
  TimeOfDay eventTime = TimeOfDay.now();
  String reason = '';
  TextEditingController appDate = TextEditingController();
  TextEditingController appTime = TextEditingController();
  TextEditingController appReason = TextEditingController();

  Future<DateTime> _selectEventDate(
      BuildContext context, TextEditingController textEditingController) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: eventDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    textEditingController.text =
        "${pickedDate!.day}/${pickedDate.month}/${pickedDate.year}";

    setState(() {
      eventDate = pickedDate!;
    });
    return eventDate;
  }

  //Time Picker
  Future<TimeOfDay> _selectEventTime(
      BuildContext context, TextEditingController textEditingController) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: eventTime,
    );
    if (pickedTime != null) {
      String formattedTime =
          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
      textEditingController.text = formattedTime;
      eventTime = pickedTime;
    }

    return eventTime;
  }

  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  void disposeControllers() {
    appDate.dispose();
    appTime.dispose();
    appReason.dispose();
  }

  Future<void> _getCurrentUser() async {
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      setState(() {});
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
            const Text("Appointments"),
            const Icon(
              Icons.list,
              size: 25,
            )
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 13, right: 13),
          child: Consumer<User?>(
            builder: (BuildContext context, value, Widget? child) {
              return ListView(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Center(
                    child: Text(
                      "Let's book your next hospital appointment",
                      style:
                          TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: appDate,
                    onChanged: (value) {
                      eventDate = value as DateTime;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 1),
                      labelText: 'Date',
                      hintText: 'DD/MM/YYY',
                      suffixIcon: InkWell(
                        child: const Icon(Icons.calendar_today),
                        onTap: () async {
                          DateTime? pickedDate =
                              await _selectEventDate(context, appDate);
                          // ignore: unnecessary_null_comparison
                          if (pickedDate != null) {
                            setState(() {
                              // Update the eventDate with the pickedDate
                              eventDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ),
                    validator: (value) {
                      // Validate that the Email is not empty
                      if (value!.isEmpty) {
                        return 'Please select Date';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: appTime,
                    onChanged: (value) {
                      // Parse the time string into a TimeOfDay object
                      List<String> timeComponents = value.split(':');
                      if (timeComponents.length == 2) {
                        int hour = int.tryParse(timeComponents[0]) ?? 0;
                        int minute = int.tryParse(timeComponents[1]) ?? 0;
                        eventTime = TimeOfDay(hour: hour, minute: minute);
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 1),
                      labelText: 'Time',
                      hintText: 'HH:MM',
                      suffixIcon: InkWell(
                        child: const Icon(Icons.watch_later_outlined),
                        onTap: () {
                          setState(() {
                            _selectEventTime(context, appTime);
                            eventTime = appDate.text as TimeOfDay;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      // Validate that the Email is not empty
                      if (value!.isEmpty) {
                        return 'Please select Time';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Reason: ',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: appReason,
                    minLines: 5,
                    maxLines: 10,
                    onChanged: (value) {
                      reason = appReason.text;
                    },
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    validator: (value) {
                      // Validate that the Email is not empty
                      if (value!.isEmpty) {
                        return 'Please enter a reason for appointment';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MyButton(
                      onTap: () {
                        setState(() {
                          if (_formKey.currentState!.validate()) {
                            postDetailsToFirestore();
                            Navigator.of(context)
                                .pushNamed(RouteManager.homePage);
                          }
                        });
                      },
                      text: 'Set Appointmnet')
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> postDetailsToFirestore() async {
    if (appDate.text.isNotEmpty &&
        appReason.text.isNotEmpty &&
        appTime.text.isNotEmpty) {
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          // Handle case where user is not logged in
          return;
        }

        await FirebaseFirestore.instance
            .collection('Appointments')
            .doc(currentUser.email.toString())
            .set({
          'Reason': appReason.text,
          'Date': appDate.text,
          'Time': appTime.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${currentUser.email.toString()}, your Appointment is received'),
          ),
        );
        Navigator.of(context).pushNamed(RouteManager.homePage);
        // Optionally, clear the text fields after submission
        appReason.clear();
        appDate.clear();
        appTime.clear();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit Appointment: $error'),
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
}
