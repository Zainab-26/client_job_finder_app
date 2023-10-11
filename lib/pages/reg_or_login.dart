import 'package:client_cp_final/pages/register.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class regOrLogin extends StatefulWidget {
  const regOrLogin({super.key});

  @override
  State<regOrLogin> createState() => _regOrLoginState();
}

class _regOrLoginState extends State<regOrLogin> {
  //Show Login page
  bool showLoginPage = true;

  //Switch between login and register pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(onTap: togglePages);
    } else {
      return Register(onTap: togglePages);
    }
  }
}
