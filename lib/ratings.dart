import 'package:cab_go_driver/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewRatingsScreen extends StatelessWidget {
  final String driverId;

  ViewRatingsScreen({required this.driverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLBlack,
        title: Text('Ratings & Reviews'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reviews')
            .where('driverId', isEqualTo: driverId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.data?.docs.isEmpty ?? true) {
            return Center(
              child: Text('No ratings or reviews found.'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs[index].data() as Map<String, dynamic>?;
              final rating = data!['rating'];
              final review = data['comment'];
              final user = data['userName'];
              final tip = data['tip'];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(user[0].toUpperCase()),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(user),
                      Text("tip: ${tip.toString()}"),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          SizedBox(width: 4),
                          Text(rating.toStringAsFixed(1)),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(review),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
