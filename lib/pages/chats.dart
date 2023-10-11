// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/conversationList.dart';
import 'chatUserListClass.dart';
import 'package:intl/intl.dart';

import 'chats_screen.dart';

//Page displays all clients the freelancer has messaged before

class ChatListScreen extends StatefulWidget {
  final String currentUserId;

  ChatListScreen({
    required this.currentUserId,
  });

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatUsers> chatUsers = [];
  String firstName = '';
  String lastName = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  //Get messages received from Messages collection
  Future<void> fetchData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser!.uid;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Messages')
        .where('Recipient_ID', isEqualTo: currentUserId)
        .orderBy('Time', descending: true)
        .get();

    final messagesByUser = Map<String, QueryDocumentSnapshot>();
    for (final doc in querySnapshot.docs) {
      final key = '${doc['Sender_ID']}-${doc['Recipient_ID']}';
      if (!messagesByUser.containsKey(key)) {
        messagesByUser[key] = doc;
      }
    }

    for (final doc in messagesByUser.values) {
      final senderId = doc['Sender_ID'] as String;
      final userData = await fetchUserData(senderId);

      firstName = userData['First_name'] as String;
      lastName = userData['Last_name'] as String;

      setState(() {
        chatUsers.add(ChatUsers(
          messageText: 'Text',
          time: DateFormat('HH:mm').format((doc['Time'] as Timestamp).toDate()),
          name: firstName + ' ' + lastName,
        ));
      });
    }
  }

  //Get user data from Users collection
  Future<Map<String, dynamic>> fetchUserData(String senderId) async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(senderId)
        .get();

    return userSnapshot.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Conversations",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Messages')
                  .where('Recipient_ID', isEqualTo: widget.currentUserId)
                  .orderBy('Time', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print('AAA $snapshot.error');
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final messagesByUser = Map<String, QueryDocumentSnapshot>();
                for (final doc in snapshot.data!.docs) {
                  final key = '${doc['Sender_ID']}-${doc['Recipient_ID']}';

                  if (!messagesByUser.containsKey(key)) {
                    messagesByUser[key] = doc;
                  }
                }

                return ListView.builder(
                  itemCount: messagesByUser.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 16),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final doc = messagesByUser.values.elementAt(index);
                    final senderId = doc['Sender_ID'] as String;

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(senderId)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (userSnapshot.hasError) {
                          print('BBB ${userSnapshot.error}');
                          // Handle error state
                          return const Text('Something went wrong');
                        }

                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Handle loading state
                          return const CircularProgressIndicator();
                        }

                        final userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        final firstName = userData['First_name'] as String;
                        final lastName = userData['Last_name'] as String;

                        return ConversationList(
                          name: '$firstName $lastName',
                          messageText: doc['Message'],
                          time: DateFormat('HH:mm')
                              .format((doc['Time'] as Timestamp).toDate()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  currentUserId: widget.currentUserId,
                                  otherUserId: senderId,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
