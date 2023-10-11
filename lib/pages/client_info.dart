import 'package:client_cp_final/components/button.dart';
import 'package:client_cp_final/components/textfield.dart';
import 'package:client_cp_final/pages/billing_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class clientInfo extends StatefulWidget {
  const clientInfo({super.key});

  @override
  State<clientInfo> createState() => _clientInfoState();
}

class _clientInfoState extends State<clientInfo> {
  //Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  TextEditingController controller = TextEditingController();

  //Current user
  final user = FirebaseAuth.instance.currentUser;
  String? userId;
  //Save client information to the database
  saveClientInfo(String name, String phoneNumber, String address) {
    if (user != null) {
      userId = user!.uid;
      // Proceed with using userId
    } else {
      // Handle the case when user is null
      // userId will remain null in this case
    }
    FirebaseFirestore.instance.collection('CLient_user').doc(userId).set({
      'User_ID': userId,
      'Name': name,
      'Phone_number': phoneNumber,
      'Address': address,
    });
  }

  //Google maps autocomplete API used
  placesAutoCompleteTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GooglePlaceAutoCompleteTextField(
          textEditingController: controller,
          googleAPIKey: "KEY GOES HERE",
          inputDecoration: InputDecoration(
            labelText: 'Address',
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: '',
            hintStyle: TextStyle(color: Colors.grey[500]),
          ),
          debounceTime: 800,
          countries: ["zm"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            print("placeDetails" + prediction.lng.toString());
          },
          itmClick: (Prediction prediction) {
            controller.text = prediction.description!;

            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description!.length));
          }),
    );
  }

  //Direct user to billing information page
  goToBillingInfo() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const billingInfo()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.portrait_sharp),
        title: const Text('Client Information'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            textField(
              controller: nameController,
              hintText: 'Business Name',
              hideText: false,
              labelText: 'Business Name',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 15),
            textField(
              controller: phoneController,
              hintText: '',
              hideText: false,
              labelText: 'Phone number',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(
              height: 15,
            ),
            placesAutoCompleteTextField(),
            const SizedBox(
              height: 15,
            ),
            button(
                onTap: () async {
                  saveClientInfo(nameController.text.trim(),
                      phoneController.text.trim(), controller.text.trim());
                  goToBillingInfo();
                },
                text: 'Save')
          ],
        ),
      )),
    );
  }
}
