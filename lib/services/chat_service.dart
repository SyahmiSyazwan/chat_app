import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // chat_service.dart
Future<void> sendMessage(String message) async {
  if (_auth.currentUser != null) {
    final user = _auth.currentUser!;
    await _firestore.collection('chats').add({
      'senderId': user.uid,
      'senderName': user.displayName ?? 'Anonymous',
      'senderEmail': user.email,
      'senderPhoto': user.photoURL ?? '', // Provide empty string if null
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

  Stream<QuerySnapshot> getMessages() {
    return _firestore.collection('chats').orderBy('timestamp').snapshots();
  }
}
