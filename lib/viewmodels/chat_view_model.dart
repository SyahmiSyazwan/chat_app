import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../services/chat_service.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();

  // chat_view_model.dart
Stream<QuerySnapshot> get messages {
  return FirebaseFirestore.instance
      .collection('chats')
      .orderBy('timestamp', descending: false) // or true for newest first
      .snapshots();
}

  Future<void> sendMessage(String message) async {
    await _chatService.sendMessage(message);
  }
}
