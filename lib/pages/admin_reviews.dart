import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviewsManagementPage extends StatelessWidget {
  const ReviewsManagementPage({super.key});

  Future<void> _deleteReview(String email) async {
    try {
      await FirebaseFirestore.instance
          .collection('Reviews')
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
          'Manage Reviews',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Reviews').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching reviews'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reviews found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['Hospital']),
                subtitle: Text(data['Review']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteReview(doc.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
