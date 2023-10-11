import 'package:client_cp_final/pages/chats.dart';
import 'package:client_cp_final/pages/profile.dart';
import 'package:client_cp_final/pages/view_jobs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class nav extends StatefulWidget {
  const nav({super.key});

  @override
  State<nav> createState() => _navState();
}

class _navState extends State<nav> {
  int selectedPage = 0;
  PageController pageController = PageController();
  late String currentUser;

  // Log user out
  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  void onTap(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      myJobs(),
      ChatListScreen(currentUserId: currentUser),
      profile(),
    ];

    return Scaffold(
      body: pages[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'My Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
        currentIndex: selectedPage,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.deepPurple,
        onTap: onTap,
      ),
    );
  }
}
