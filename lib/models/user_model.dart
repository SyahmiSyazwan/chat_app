class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
  });

  // Factory constructor to create a UserModel from Firestore document data
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
    );
  }

  // Method to convert UserModel instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }
}
