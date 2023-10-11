import 'package:client_cp_final/components/button.dart';
import 'package:client_cp_final/pages/freelancer_profile.dart';
import 'package:client_cp_final/pages/nav.dart';
import 'package:client_cp_final/pages/view_jobs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BidDetailsPage extends StatefulWidget {
  final DocumentSnapshot bidSnapshot;
  final String appointId;

  const BidDetailsPage(
      {Key? key, required this.bidSnapshot, required this.appointId})
      : super(key: key);

  @override
  _BidDetailsPageState createState() => _BidDetailsPageState();
}

class _BidDetailsPageState extends State<BidDetailsPage> {
  //Declaring variables
  late String freelancer;
  late String estimatedDuration;
  late String amount;
  late String bidId;

  //Load data on initialisation
  @override
  void initState() {
    super.initState();
    loadJobData();
  }

  //Load bid data based on job Id
  Future<void> loadJobData() async {
    final snapshot = widget.bidSnapshot;
    freelancer = snapshot['User_ID'];
    amount = snapshot['Amount'];
    estimatedDuration = snapshot['Estimated_duration'];
    bidId = snapshot.id;
  }

  //Check if a bid has been accepted by client
  void acceptedBid(String bidId) {
    final appointmentRef =
        FirebaseFirestore.instance.collection('Appointments');
    //Get appointment data that matched appointment selected by client
    appointmentRef
        .where('Appointment_ID', isEqualTo: widget.appointId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        //Check if document found has a field called 'winningBidId'
        final documentId = querySnapshot.docs.first.id;
        FirebaseFirestore.instance
            .collection('Appointments')
            .doc(documentId)
            .update({
          'winningBidId': bidId,
        }).then((value) {
          //If its found
          print('Updated appointment with winning bid ID: $bidId');
        }).catchError((error) {
          //If its not found
          print('Failed to update appointment with error: $error');
        });
      } else {
        // No matching documents were found
        print('No document found with Appointment_ID: ${widget.appointId}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.portrait_sharp),
        title: const Text('Bid Details'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estimated Duration:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(estimatedDuration, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Amount:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(amount, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            button(
                onTap: () async {
                  acceptedBid(bidId);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => nav(),
                  ));
                },
                text: 'Accept bid'),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => freelancerProfile(
                              userId: freelancer,
                            ),
                          ));
                        },
                        child: const Text('View Freelancer Profile')))),
          ],
        ),
      ),
    );
  }
}
