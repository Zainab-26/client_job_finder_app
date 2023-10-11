import 'package:client_cp_final/pages/chats_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../components/button.dart';

class freelancerProfile extends StatefulWidget {
  String userId;
  freelancerProfile({super.key, required this.userId});

  @override
  State<freelancerProfile> createState() => _freelancerProfileState();
}

class _freelancerProfileState extends State<freelancerProfile> {
  //Declaring variables
  String title = '';
  String fName = '';
  String lName = '';
  String bio = '';
  String lang = '';
  List<String> selectedLanguages = [];
  List<String> selectedSkills = [];
  String fos = '';
  String school = '';
  String degree = '';
  String start_date = '';
  String formattedStartDate = '';
  String end_date = '';
  String desc = '';
  DateTime dateOnly = DateTime.now();
  DateTime endDateOnly = DateTime.now();
  String workTitle = '';
  String company = '';
  String location = '';
  String work_start_date = '';
  String work_end_date = '';
  String workDesc = '';
  DateTime workStartDateOnly = DateTime.now();
  DateTime workEndDateOnly = DateTime.now();

  //Load user data at initialisation
  @override
  void initState() {
    super.initState();
    displayTitle();
    displayName();
    displayBio();
    getLanguages();
    getSkills();
    displayEduBg();
    displayWorkExp();
    getUserId();
  }

  //Get current user ID
  late String userId;
  getUserId() {
    final currentUser = FirebaseAuth.instance.currentUser!;
    userId = currentUser.uid;
  }

  //Get freelancer's title
  Future<void> displayTitle() async {
    DocumentSnapshot snapshot1 = await FirebaseFirestore.instance
        .collection('Title')
        .doc(widget.userId)
        .get();
    print('User snapshot1: ${snapshot1.data()}');

    if (snapshot1.exists && snapshot1.data() != null) {
      setState(() {
        title = snapshot1.get('Title');
      });
    } else {
      print('ERROR MATE!');
    }
  }

  //Get freelancer's names
  Future<void> displayName() async {
    DocumentSnapshot snapshot2 = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userId)
        .get();
    print('User snapshot1: ${snapshot2.data()}');

    if (snapshot2.exists && snapshot2.data() != null) {
      setState(() {
        fName = snapshot2.get('First_name');
        lName = snapshot2.get('Last_name');
      });
    } else {
      print('ERROR MATE!');
    }
  }

  //Get freelancer's bio
  Future<void> displayBio() async {
    DocumentSnapshot snapshot3 = await FirebaseFirestore.instance
        .collection('Bio')
        .doc(widget.userId)
        .get();
    print('User snapshot1: ${snapshot3.data()}');

    if (snapshot3.exists && snapshot3.data() != null) {
      setState(() {
        bio = snapshot3.get('Bio');
      });
    } else {
      print('ERROR MATE!');
    }
  }

  //Get languages spoken by freelancer
  Future<void> getLanguages() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Languages')
        .doc(widget.userId)
        .get();

    if (snapshot.exists) {
      String langString = snapshot.get('Languages');

      langString = langString.substring(1, langString.length - 1);

      List<String> languages = langString.split(', ');
      setState(() {
        selectedLanguages = List<String>.from(languages);
        lang = selectedLanguages.toString();
      });
    }
  }

  //Get list of freelancer's skillset
  Future<void> getSkills() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Skills')
        .doc(widget.userId)
        .get();

    if (snapshot.exists) {
      String skillString = snapshot.get('Skills');

      skillString = skillString.substring(1, skillString.length - 1);

      List<String> skills = skillString.split(', ');
      setState(() {
        selectedSkills = List<String>.from(skills);
      });
    }
  }

  //Get freelancer's education background
  Future<void> displayEduBg() async {
    DocumentSnapshot snapshot3 = await FirebaseFirestore.instance
        .collection('Education_background')
        .doc(widget.userId)
        .get();
    print('User snapshot1: ${snapshot3.data()}');

    if (snapshot3.exists && snapshot3.data() != null) {
      setState(() {
        fos = snapshot3.get('Field_of_study');
        school = snapshot3.get('School');
        degree = snapshot3.get('Degree');
        start_date = snapshot3.get('Start_Date');
        DateTime startDate = DateTime.parse(start_date);
        dateOnly = DateTime(startDate.year, startDate.month, startDate.day);
        end_date = snapshot3.get('End_Date');
        DateTime endDate = DateTime.parse(end_date);
        endDateOnly = DateTime(endDate.year, endDate.month, endDate.day);
        desc = snapshot3.get('Description');
      });
    } else {
      print('ERROR MATE!');
    }
  }

  //Get freelancer's work experience
  Future<void> displayWorkExp() async {
    DocumentSnapshot snapshot3 = await FirebaseFirestore.instance
        .collection('Work_experience')
        .doc(widget.userId)
        .get();
    print('User snapshot1: ${snapshot3.data()}');

    if (snapshot3.exists && snapshot3.data() != null) {
      setState(() {
        workTitle = snapshot3.get('Title');
        company = snapshot3.get('Company');
        location = snapshot3.get('Location');
        work_start_date = snapshot3.get('Start_Date');
        DateTime workStartDate = DateTime.parse(work_start_date);
        workStartDateOnly = DateTime(
            workStartDate.year, workStartDate.month, workStartDate.day);
        work_end_date = snapshot3.get('End_Date');
        DateTime workEndDate = DateTime.parse(work_end_date);
        workEndDateOnly =
            DateTime(workEndDate.year, workEndDate.month, workEndDate.day);
        desc = snapshot3.get('Description');
      });
    } else {
      print('ERROR MATE!');
    }
  }

  //Get bid posted by user
  readID() {
    final bidRef = FirebaseFirestore.instance.collection('Bids');
    return bidRef.where('User_ID', isEqualTo: widget.userId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final languagesText = selectedLanguages.join(', ');
    final skillsText = selectedSkills.join(', ');

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
            Text(title, style: GoogleFonts.bebasNeue(fontSize: 40)),
            SizedBox(height: 15),
            Text(
              fName + ' ' + lName,
              style: GoogleFonts.robotoCondensed(fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
            Text(bio),
            Divider(),
            Text('Languages Spoken',
                style: GoogleFonts.bebasNeue(fontSize: 40)),
            SizedBox(height: 15),
            Text(languagesText),
            Divider(),
            SizedBox(height: 15),
            Text('Skills', style: GoogleFonts.bebasNeue(fontSize: 40)),
            SizedBox(height: 15),
            Text(skillsText),
            Divider(),
            SizedBox(height: 15),
            Text('Education Background',
                style: GoogleFonts.bebasNeue(fontSize: 40)),
            SizedBox(height: 15),
            Text(fos),
            SizedBox(height: 15),
            Text(school),
            SizedBox(height: 15),
            Text(degree),
            SizedBox(height: 15),
            Text(DateFormat('yyyy-MM-dd').format(dateOnly)),
            SizedBox(height: 15),
            Text(DateFormat('yyyy-MM-dd').format(endDateOnly)),
            SizedBox(height: 15),
            Text(desc),
            Divider(),
            SizedBox(height: 15),
            Text('Work Experience', style: GoogleFonts.bebasNeue(fontSize: 40)),
            SizedBox(height: 15),
            Text(workTitle),
            SizedBox(height: 15),
            Text(company),
            SizedBox(height: 15),
            Text(location),
            SizedBox(height: 15),
            Text(DateFormat('yyyy-MM-dd').format(workStartDateOnly)),
            SizedBox(height: 15),
            Text(DateFormat('yyyy-MM-dd').format(workEndDateOnly)),
            SizedBox(height: 15),
            Text(desc),
            Divider(),
            SizedBox(height: 15),
            button(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                              currentUserId: userId,
                              otherUserId: widget.userId)));
                },
                text: 'Message')
          ],
        ),
      )),
    );
  }
}
