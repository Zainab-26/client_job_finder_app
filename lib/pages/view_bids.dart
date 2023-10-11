import 'package:client_cp_final/components/button.dart';
import 'package:client_cp_final/pages/bid_detail.dart';
import 'package:client_cp_final/pages/view_jobs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class viewAllBids extends StatefulWidget {
  String appointmentId;
  viewAllBids({super.key, required this.appointmentId});

  @override
  State<viewAllBids> createState() => _viewAllBidsState();
}

class _viewAllBidsState extends State<viewAllBids> {
  //Current user
  final user = FirebaseAuth.instance.currentUser!;

  //Get bids based on appointment ID
  Stream<QuerySnapshot<Map<String, dynamic>>> readAppointments() {
    String userId = user.uid;
    final apppRef = FirebaseFirestore.instance.collection('Bids');
    return apppRef
        .where('Appointment_ID', isEqualTo: widget.appointmentId)
        .snapshots();
  }

  //Check if winning bid exists, if not, add it
  void acceptedBid(String bidId) {
    final appointmentRef =
        FirebaseFirestore.instance.collection('Appointments');
    appointmentRef
        .where('Appointment_ID', isEqualTo: widget.appointmentId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        //
        final documentId = querySnapshot.docs.first.id;
        FirebaseFirestore.instance
            .collection('Appointments')
            .doc(documentId)
            .update({
          'winningBidId': bidId,
        }).then((value) {
          //
          print('Updated appointment with winning bid ID: $bidId');
        }).catchError((error) {
          //
          print('Failed to update appointment with error: $error');
        });
      } else {
        //
        print('No document found with Appointment_ID: ${widget.appointmentId}');
      }
    });
  }

  void goToJobs() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => myJobs()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.portrait_sharp),
        title: const Text('Bids placed'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: readAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            print('SOMETHINGG + $snapshot.data');
            final bids = snapshot.data!.docs;
            return ListView.builder(
              itemCount: bids.length,
              itemBuilder: (context, index) {
                final bid = bids[index];
                return ListTile(
                  title: Text(bid['Amount']),
                  subtitle: Text(bid['Estimated_duration'].toString()),
                  trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BidDetailsPage(
                            bidSnapshot: bids[index],
                            appointId: widget.appointmentId,
                          ),
                        ));
                      },
                      child: Text('View details')),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Text('SOMETHING WENT WRONG');
          }
        },
      ),
    );
  }
}
