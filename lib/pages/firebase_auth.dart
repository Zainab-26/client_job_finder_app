// ignore_for_file: prefer_const_constructors

import 'package:client_cp_final/pages/chats.dart';
import 'package:client_cp_final/pages/client_info.dart';
import 'package:client_cp_final/pages/location.dart';
import 'package:client_cp_final/pages/login.dart';
import 'package:client_cp_final/pages/nav.dart';
import 'package:client_cp_final/pages/paymentInstance.dart';
import 'package:client_cp_final/pages/rating.dart';
import 'package:client_cp_final/pages/reg_or_login.dart';
import 'package:client_cp_final/pages/view_jobs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Checks if user is logged in or not

class auth extends StatelessWidget {
  const auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      //Listens to check if user is logged in or not
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        //User is logged in
        if (snapshot.hasData) {
          return regOrLogin();
        }

        //User is not logged in
        else {
          return regOrLogin();
        }
      },
    ));
  }
}
