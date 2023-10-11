import 'package:client_cp_final/pages/job_details.dart';
import 'package:client_cp_final/pages/location.dart';
import 'package:client_cp_final/pages/view_bids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class myJobs extends StatefulWidget {
  const myJobs({super.key});

  @override
  State<myJobs> createState() => _myJobsState();
}

class _myJobsState extends State<myJobs> {
  //Current user
  final user = FirebaseAuth.instance.currentUser!;

  //Get appointments based on client ID
  Stream<QuerySnapshot<Map<String, dynamic>>> readAppointments() {
    String userId = user.uid;
    final apppRef = FirebaseFirestore.instance.collection('Appointments');
    return apppRef.where('User_ID', isEqualTo: userId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.portrait_sharp),
        title: Text('My Appointments'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Location(),
                ));
              },
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: readAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            print('SOMETHINGG + $snapshot.data');
            final appointments = snapshot.data!.docs;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(appointment['Job_title']),
                      subtitle: Text(
                          "${appointment['Appointment_time']} on ${appointment['Appointment_date']}"),
                      trailing: Text(appointment['Job_type']),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => JobDetailsPage(
                            jobSnapshot: appointments[index],
                          ),
                        ));
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Text('SOMETHING WENT WRONG');
          }
        },
      ),
    );
  }
}
