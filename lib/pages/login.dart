// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:client_cp_final/components/button.dart';
import 'package:client_cp_final/components/textfield.dart';
import 'package:client_cp_final/pages/client_info.dart';
import 'package:client_cp_final/pages/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  final Function()? onTap;
  const Login({super.key, required this.onTap});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  //Controllers for username and password
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  // Function to get the user's user document from Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc() async {
    // Get the current user's UID from Firebase Auth
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Use the UID to fetch the user document from Firestore
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();

    return userDoc;
  }

  //Sign in method
  void signIn() async {
    //Show loader
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      //Get rid of loader
      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const nav()),
      );
    } on FirebaseAuthException catch (e) {
      //Get rid of loader
      Navigator.pop(context);

      //Check if user exists
      if (e.code == 'user-not-found') {
        incorrectDetails();

        print('ERRORS' + e.code);
      } else if (e.code == 'invalid-email') {
        incorrectEmail();
        print('Incorrect stuff');
      }

      //Checks if password matches
      else if (e.code == 'wrong-password') {
        incorrectPassword();
        print('Incorrect stuff');
      }
    }
  }

  void incorrectDetails() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text(
              'The user does not exist. Please check the email address entered and try again.'),
        );
      },
    );
  }

  void incorrectPassword() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect password, please try again.'),
        );
      },
    );
  }

  void incorrectEmail() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect email entered, please try again.'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Hey there!', style: GoogleFonts.bebasNeue(fontSize: 52)),
            SizedBox(height: 15),
            Text(
              'Welcome back! We\'ve missed you :)',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 45),

            //Email textfield
            textField(
                controller: emailController,
                hintText: 'Username',
                hideText: false,
                labelText: 'Email Address',
                keyboardType: TextInputType.text),

            SizedBox(height: 20),

            //Password textfield
            textField(
                controller: passwordController,
                hintText: 'Password',
                hideText: true,
                labelText: 'Password',
                keyboardType: TextInputType.text),

            SizedBox(height: 20),

            //Forgot password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Forgot Password?',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),

            SizedBox(height: 20),

            //Sign in button
            button(
              text: 'Sign In',
              onTap: signIn,
            ),

            SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    ' Register',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      )),
    );
  }
}
