import 'package:client_cp_final/pages/chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chatListClass.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;

  ChatScreen({required this.currentUserId, required this.otherUserId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  String fName = '';
  String lName = '';

  @override
  void initState() {
    super.initState();
    displayName();
  }

  //Display name of client user chatting with on the top bar
  Future<void> displayName() async {
    DocumentSnapshot snapshot2 = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.otherUserId)
        .get();
    print('User snapshot for chat name: ${snapshot2.data()}');

    if (snapshot2.exists && snapshot2.data() != null) {
      setState(() {
        fName = snapshot2.get('First_name');
        lName = snapshot2.get('Last_name');
      });
    } else {
      print('ERROR MATE!');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      //Go to all chats screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatListScreen(
                                    currentUserId: widget.currentUserId,
                                  )));
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        "<https://randomuser.me/api/portraits/men/5.jpg>"),
                    maxRadius: 20,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          fName + ' ' + lName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 50.0),
              //View message to and from a particular client and order them based on time sent
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Messages')
                    .where('Sender_ID', isEqualTo: widget.currentUserId)
                    .where('Recipient_ID', isEqualTo: widget.otherUserId)
                    .orderBy('Time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final senderMessages = snapshot.data!.docs
                      .map((doc) => ChatMessage(
                            messageContent: doc['Message'],
                            messageType: 'sender',
                            messageTime: DateFormat('HH:mm')
                                .format((doc['Time'] as Timestamp).toDate()),
                          ))
                      .toList();

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Messages')
                        .where('Sender_ID', isEqualTo: widget.otherUserId)
                        .where('Recipient_ID', isEqualTo: widget.currentUserId)
                        .orderBy('Time')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final recipientMessages = snapshot.data!.docs
                          .map((doc) => ChatMessage(
                                messageContent: doc['Message'],
                                messageType: 'receiver',
                                messageTime: DateFormat('HH:mm').format(
                                    (doc['Time'] as Timestamp).toDate()),
                              ))
                          .toList();

                      final messages = [
                        ...senderMessages,
                        ...recipientMessages
                      ];
                      messages.sort(
                          (a, b) => (a.messageTime).compareTo(b.messageTime));

                      return ListView.builder(
                        itemCount: messages.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10),
                            child: Align(
                              alignment:
                                  //Align and colour message bubbles based on whether the message was sent or received
                                  messages[index].messageType == 'receiver'
                                      ? Alignment.topLeft
                                      : Alignment.topRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      messages[index].messageType == 'receiver'
                                          ? Colors.grey.shade200
                                          : Colors.blue[200],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  messages[index].messageContent,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      String messageContent = messageController.text.trim();

                      if (messageContent.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection('Messages')
                            .add({
                          'Message': messageContent,
                          'Sender_ID': widget.currentUserId,
                          'Recipient_ID': widget.otherUserId,
                          'Time': Timestamp.now(),
                        });

                        messageController.clear();
                      }
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
