import 'package:client_cp_final/components/button.dart';
import 'package:client_cp_final/components/textfield.dart';
import 'package:client_cp_final/pages/billing_info.dart';
import 'package:client_cp_final/pages/nav.dart';
import 'package:client_cp_final/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class editClientInfo extends StatefulWidget {
  const editClientInfo({super.key});

  @override
  State<editClientInfo> createState() => _editClientInfoState();
}

class _editClientInfoState extends State<editClientInfo> {
  //Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController controller = TextEditingController();

  //Get client information fro CLient_user collection and display in textfields
  Future<void> loadClientInfo() async {
    String? currentUser = FirebaseAuth.instance.currentUser!.uid;
    print(currentUser);

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('CLient_user')
        .doc(currentUser)
        .get();
    print('User snapshot: ${snapshot.data()}');

    if (snapshot.exists && snapshot.data() != null) {
      String name = snapshot.get('Name');
      String phone = snapshot.get('Phone_number');
      String address = snapshot.get('Address');

      nameController.text = name;
      phoneController.text = phone;
      addressController.text = address;
      print(name);
    } else {
      print('ERROR MATE!');
    }
  }

  //Load data on page initialisation
  @override
  void initState() {
    super.initState();
    loadClientInfo();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  //Current user
  final user = FirebaseAuth.instance.currentUser!;

  //Add client information to database collection
  saveClientInfo(String name, String phoneNumber, String address) {
    String userId = user.uid;

    FirebaseFirestore.instance.collection('CLient_user').doc(userId).set({
      'User_ID': userId,
      'Name': name,
      'Phone_number': phoneNumber,
      'Address': address,
    });
  }

  //Google maps autocomplete text API used
  placesAutoCompleteTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GooglePlaceAutoCompleteTextField(
          textEditingController: addressController,
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
            addressController.text = prediction.description!;

            addressController.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description!.length));
          }),
    );
  }

  //Direct user to nav page
  goToProfile() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const nav()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.portrait_sharp),
        title: const Text('Edit Client Information'),
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
              hintText: 'Name',
              hideText: false,
              labelText: 'Name',
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
                  goToProfile();
                },
                text: 'Save')
          ],
        ),
      )),
    );
  }
}
