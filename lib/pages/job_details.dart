import 'package:client_cp_final/components/button.dart';
import 'package:client_cp_final/pages/paymentInstance.dart';
import 'package:client_cp_final/pages/rating.dart';
import 'package:client_cp_final/pages/view_bids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JobDetailsPage extends StatefulWidget {
  final DocumentSnapshot jobSnapshot;

  const JobDetailsPage({Key? key, required this.jobSnapshot}) : super(key: key);

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
//Declaring variables
  late String jobTitle;
  late String jobType;
  late String jobDescription;
  late String appointmentDate;
  late String appointmentTime;
  late String appointmentId;
  late String freelancerId = '';
  late String winningBidId = '';
  late String winningBidAmount = '';
  bool isLoading = true;
  bool isViewBidsButtonEnabled = true;
  bool isAddReviewButtonEnabled = true;

//Load data on initialisation
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await loadJobData();
    await checkWinningBid(appointmentId);
    setState(() {
      isLoading = false;
      isViewBidsButtonEnabled = winningBidId.isEmpty;
      isAddReviewButtonEnabled = winningBidId.isNotEmpty;
    });
  }

//Load job details based on appointment Id
  Future<void> loadJobData() async {
    final snapshot = widget.jobSnapshot;
    jobTitle = snapshot['Job_title'];
    jobType = snapshot['Job_type'];
    jobDescription = snapshot['Appointment_address'];
    appointmentDate = snapshot['Appointment_date'];
    appointmentTime = snapshot['Appointment_time'];
    appointmentId = snapshot['Appointment_ID'];
  }

  //Current user ID
  final user = FirebaseAuth.instance.currentUser!;

  //Check if winning bid has been selected
  Future<void> checkWinningBid(String appId) async {
    final appRef = FirebaseFirestore.instance.collection('Appointments');
    //Get appointment details based on appointment ID
    final querySnapshot =
        await appRef.where('Appointment_ID', isEqualTo: appId).get();

    if (querySnapshot.docs.isNotEmpty) {
      final appointmentSnapshot = querySnapshot.docs.first;
      final appointmentData = appointmentSnapshot.data();

      if (appointmentData.containsKey('winningBidId')) {
        //If the field exists
        winningBidId = appointmentData['winningBidId'];

        //Get the user ID from the bids collection that matches the winning bid ID
        final bidsRef = FirebaseFirestore.instance.collection('Bids');
        final bidSnapshot = await bidsRef.doc(winningBidId).get();

        if (bidSnapshot.exists) {
          final bidData = bidSnapshot.data();
          freelancerId = bidData!['User_ID'];
          winningBidAmount = bidData['Amount'];
        } else {}
      } else {}
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    String userId = user.uid;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.portrait_sharp),
        title: Text(jobTitle),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Job Description:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(jobDescription, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Date:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(appointmentDate, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Time:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(appointmentTime, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Job Type:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(jobType, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Winning Bid:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(winningBidAmount, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  //Disable Add a review button if a bid has not yet been selected
                  onPressed: isAddReviewButtonEnabled
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ratings(
                              clientId: userId,
                              freelancerId: freelancerId,
                              jobId: appointmentId,
                            ),
                          ));
                        }
                      : null,
                  child: const Text('Add a review'),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  //Disable Make Payment button if bid has not yet been selected
                  onPressed: isAddReviewButtonEnabled
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => makePayment()));
                        }
                      : null,
                  child: const Text('Make Payment'),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  //Disable 'View bids' button if bid has already been selected
                  onPressed: isViewBidsButtonEnabled
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => viewAllBids(
                              appointmentId: appointmentId,
                            ),
                          ));
                        }
                      : null,
                  child: const Text('View bids'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
