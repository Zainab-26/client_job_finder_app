// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:client_cp_final/components/button.dart';
import 'package:client_cp_final/pages/edit_billing_info.dart';
import 'package:client_cp_final/pages/edit_client_info.dart';
import 'package:client_cp_final/pages/paymentInstance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  //Declaring variables
  String firstName = '';
  String lastName = '';
  String title1 = '';

  //Current user
  final user = FirebaseAuth.instance.currentUser!;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  //Call load functions during page initialisation
  @override
  void initState() {
    super.initState();
    loadProfileData();
    loadTitle();
  }

  //Load current users names
  Future<void> loadProfileData() async {
    String? currentUser = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser)
        .get();
    print('User snapshot: ${snapshot.data()}');

    if (snapshot.exists && snapshot.data() != null) {
      setState(() {
        firstName = snapshot.get('First_name');
        lastName = snapshot.get('Last_name');
      });
    } else {
      print('ERROR MATE!');
    }
  }

  //Load current users title
  Future<void> loadTitle() async {
    String? currentUser = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot snapshot1 = await FirebaseFirestore.instance
        .collection('Title')
        .doc(currentUser)
        .get();
    print('User snapshot1: ${snapshot1.data()}');

    if (snapshot1.exists && snapshot1.data() != null) {
      setState(() {
        title1 = snapshot1.get('Title');
      });
    } else {
      print('ERROR MATE!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.portrait_sharp),
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2022/12/01/04/35/sunset-7628294_960_720.jpg',
                    height: 24.0,
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Text('$firstName $lastName',
                style: GoogleFonts.bebasNeue(fontSize: 40)),
            SizedBox(
              height: 15,
            ),
            button(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => editClientInfo(),
                  ));
                },
                text: 'Edit Profile'),
            SizedBox(height: 15),
            Divider(),
            SizedBox(height: 15),
            ProfileListWidget(
                title: 'Billing Information',
                icon: Icons.co_present_sharp,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => editBillingInfo(),
                  ));
                }),
            Divider(),
          ],
        ),
      )),
    );
  }
}

//Design for each profile tile
class ProfileListWidget extends StatelessWidget {
  const ProfileListWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPress,
      this.endIcon = true,
      this.textColor});

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.grey,
        ),
      ),
      title: Text(title,
          style:
              Theme.of(context).textTheme.bodySmall?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 20,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
