import 'package:flutter/foundation.dart';
import '../services/profile_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  Future<void> uploadProfileImage(XFile image) async {
    String? url = await _profileService.uploadProfileImage(image);
    if (url != null) {
      print("Profile image uploaded: $url");
    }
  }
}
