class UserModel {
  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    required this.createdAt,
  });

  // Factory constructor to create a UserModel from Firestore data
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'].toString(),
      userName: map['userName'].toString(),
      email: map['email'].toString(),
      createdAt: map['createdAt'].toString(),
    );
  }
  final String uid;
  final String userName;
  final String email;
  final String createdAt;

  // Convert UserModel to Map (for uploading to Firestore)
  Map<String, String> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'email': email,
      'createdAt': createdAt,
    };
  }
}
