import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadProfileImage(XFile image) async {
    try {
      final ref = _firebaseStorage.ref().child('profile_pictures').child('user.jpg');
      await ref.putFile(image as File);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error uploading profile image: $e");
      return null;
    }
  }
}
