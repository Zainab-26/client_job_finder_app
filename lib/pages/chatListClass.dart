import 'package:flutter/cupertino.dart';

//Class to view messages to and from users
class ChatMessage {
  String messageContent;
  String messageType;
  String messageTime;
  ChatMessage(
      {required this.messageContent,
      required this.messageType,
      required this.messageTime});
}
