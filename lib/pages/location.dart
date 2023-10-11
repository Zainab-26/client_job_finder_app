// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings
import 'package:client_cp_final/components/button.dart';
import 'package:client_cp_final/components/textfield.dart';
import 'package:client_cp_final/pages/nav.dart';
import 'package:client_cp_final/pages/view_jobs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  //Declaring variables and lists
  TimeOfDay timeOfDay = TimeOfDay(hour: 5, minute: 30);
  DateTime _selectedDate = DateTime.now();
  TextEditingController controller = TextEditingController();
  final descController = TextEditingController();
  final jobTitleController = TextEditingController();
  final List<String> skills = [
    'Babyproofing',
    'Car Washing',
    'Carpentry & Construction',
    'Cleaning',
    'Decoration',
    'Deep Clean',
    'Delivery',
    'Electrician',
    'Errands',
    'Event Staffing',
    'Executive Assistant',
    'Full-Service Help Moving',
    'Furniture Assembly',
    'Furniture Removal',
    'Interior Design',
    'Laundry and Ironing',
    'Lift & Shift Furniture',
    'Minor Home Repairs',
    'Mounting',
    'Moving Help',
    'Office Administration',
    'Organization',
    'Packing & Unpacking',
    'Painting',
    'Pet Sitting',
    'Plumbing',
    'Power Washing',
    'Project Coordination',
    'Rental Unit Management',
    'Room Measurement',
    'Sewing',
    'Shopping',
    'Smart Home Installation',
    'Waiting in Line',
    'Window Cleaning',
    'Yard Work'
  ];
  String selectedType = 'Car Washing';

  //Function to select date that is within 2 weeks of booking
  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now;
    final DateTime lastDate = now.add(Duration(days: 14));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void TimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        timeOfDay = value!;
      });
    });
  }

  //Current user
  final user = FirebaseAuth.instance.currentUser!;

  //Save job data to Appointments collection
  saveJobData(
      String jobTitle,
      String jobType,
      String address,
      String appointmentDate,
      String appointmentTime,
      String appointmentDetails) {
    String userId = user.uid;
    String appointId = Uuid().v4();
    FirebaseFirestore.instance.collection('Appointments').add({
      'User_ID': userId,
      'Appointment_ID': appointId,
      'Job_title': jobTitle,
      'Job_type': jobType,
      'Appointment_address': address,
      'Appointment_date': appointmentDate,
      'Appointment_time': appointmentTime,
      'Details': appointmentDetails
    });
  }

  //Redirect user to My appointments page
  void goToAppointments() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => nav()));
  }

  //Display entered details to user in dialog box before confirming save to database
  void confirmSave() {
    final DateFormat format = DateFormat('yyyy-MM-dd');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Save'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Job Title: ${jobTitleController.text}'),
              Text('Job Type: $selectedType'),
              Text('Appointment Address: ${controller.text}'),
              Text('Appointment Date: ${format.format(_selectedDate)}'),
              Text('Appointment Time: ${timeOfDay.format(context)}'),
              Text('Details: ${descController.text}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                await saveJobData(
                    jobTitleController.text.trim(),
                    selectedType,
                    controller.text.trim(),
                    format.format(_selectedDate),
                    timeOfDay.format(context),
                    descController.text.trim());
                Navigator.of(context).pop();
                goToAppointments();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.portrait_sharp),
        title: Text('Book a task'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
            ),
            textField(
                controller: jobTitleController,
                hintText: '',
                hideText: false,
                labelText: 'Job title',
                keyboardType: TextInputType.text),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
                value: selectedType,
                onChanged: (String? changedValue) {
                  if (changedValue != null) {
                    setState(() {
                      selectedType = changedValue;
                    });
                  }
                },
                items: skills
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(color: Colors.black),
                          ),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 25),
            placesAutoCompleteTextField(),
            SizedBox(
              height: 25,
            ),
            button(onTap: () => _selectDate(context), text: 'Select date'),
            SizedBox(height: 25),
            if (_selectedDate != null)
              Text('Selected date: ${format.format(_selectedDate)}'),
            SizedBox(height: 25),
            button(onTap: TimePicker, text: 'Select time'),
            SizedBox(height: 25),
            Text('Selected time: ' + timeOfDay.format(context).toString()),
            SizedBox(height: 25),
            textField(
                controller: descController,
                hintText: '',
                hideText: false,
                labelText: 'Any further details',
                keyboardType: TextInputType.multiline),
            SizedBox(height: 25),
            button(
                onTap: () async {
                  confirmSave();
                },
                text: 'Book Appointment')
          ],
        ),
      )),
    );
  }

  //Google maps autocomplete API to allow valid, accurate addresses to be stored
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
          }
          // default 600 ms ,
          ),
    );
  }
}
