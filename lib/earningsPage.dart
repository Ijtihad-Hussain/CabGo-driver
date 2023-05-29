import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EarningsPage extends StatefulWidget {
  @override
  _EarningsPageState createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  double totalEarnings = 0;
  double walletBalance = 0;
  List<DocumentSnapshot> rides = [];

  @override
  void initState() {
    super.initState();
    // Initialize Firebase in your app
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });

    // Retrieve data from 'completedTrips' collection
    FirebaseFirestore.instance
        .collection('completedTrips')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        totalEarnings = 0;
        walletBalance = 0;
        rides = snapshot.docs;
        // Calculate total earnings and wallet balance
        for (var i = 0; i < rides.length; i++) {
          totalEarnings += rides[i]['fare'];
        }
        walletBalance = totalEarnings;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/requestspage'),
        ),
        title: Center(child: Text('Earnings')),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 500.h, // give a fixed height
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Total Earnings: \$${totalEarnings.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: rides.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Pickup: ${rides[index]['pickupAddress']}'),
                                      ),
                                      SizedBox(height: 4),
                                      Text('Destination: ${rides[index]['destinationAddress']}'),
                                      SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                                Text('\$${rides[index]['fare'].toStringAsFixed(2)}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
