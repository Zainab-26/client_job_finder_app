// ignore_for_file: use_build_context_synchronously

import 'package:client_cp_final/components/button.dart';
import 'package:client_cp_final/components/textfield.dart';
import 'package:client_cp_final/pages/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ratings extends StatefulWidget {
  final String freelancerId;
  final String clientId;
  final String jobId;

  const ratings(
      {super.key,
      required this.freelancerId,
      required this.clientId,
      required this.jobId});

  @override
  State<ratings> createState() => _ratingsState();
}

class _ratingsState extends State<ratings> {
  //Declare variables
  late double _rating;

  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  //Save review to database
  Future<void> addReview() async {
    //Declare variable to store user review
    String reviewText = reviewController.text;

    //Add to Reviews collection in database
    await FirebaseFirestore.instance.collection('Reviews').add({
      'Rating': _rating,
      'Review': reviewText,
      'Freelancer_ID': widget.freelancerId,
      'Client_ID': widget.clientId,
      'Appointment_ID': widget.jobId,
      'timestamp': DateTime.now(),
    });

    reviewController.clear();

    //Message to confirm submission of review and rating
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Review Submitted'),
        content: const Text('Thank you for your feedback!'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              goToNav();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  //Direct user to nav screen
  goToNav() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => nav()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.portrait_sharp),
          title: const Text('Add Review'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              //Flutter package to add rating for user
              Center(
                child: RatingBar.builder(
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _rating = rating.toDouble();
                    print(_rating);
                    Text(
                      'Rating: $_rating',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              textField(
                  controller: reviewController,
                  hintText: '',
                  hideText: false,
                  labelText: 'Add a review',
                  keyboardType: TextInputType.text),
              const SizedBox(
                height: 30,
              ),
              button(
                  onTap: () async {
                    addReview();
                  },
                  text: 'Add Review')
            ],
          ),
        )));
  }
}
