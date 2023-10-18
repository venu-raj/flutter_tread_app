class UserModel {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String fullname;
  final String bio;
  final List followers;
  UserModel({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.fullname,
    required this.bio,
    required this.followers,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'uid': uid});
    result.addAll({'photoUrl': photoUrl});
    result.addAll({'username': username});
    result.addAll({'fullname': fullname});
    result.addAll({'bio': bio});
    result.addAll({'followers': followers});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      username: map['username'] ?? '',
      fullname: map['fullname'] ?? '',
      bio: map['bio'] ?? '',
      followers: List.from(map['followers']),
    );
  }
}
