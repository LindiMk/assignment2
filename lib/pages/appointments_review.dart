import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentsManagementPage extends StatelessWidget {
  const AppointmentsManagementPage({super.key});

  Future<void> _deleteAppointment(String email) async {
    try {
      await FirebaseFirestore.instance
          .collection('Appointments')
          .doc(email)
          .delete();
      // Optionally, show a confirmation message
    } catch (error) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Manage Appointments',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('Appointments').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching appointments'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No appointments found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['Reason']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${doc.id}'),
                    Text('Date: ${data['Date']}'),
                    Text('Time: ${data['Time']}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteAppointment(doc.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
