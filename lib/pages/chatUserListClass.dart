import 'package:flutter/cupertino.dart';

//Class to display the clients that the freeelancer has messaged before
class ChatUsers {
  String name;
  String messageText;
  //String image;
  String time;
  ChatUsers(
      {required this.name,
      required this.messageText,
      //required this.image,
      required this.time});
}
