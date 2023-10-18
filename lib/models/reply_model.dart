class Replymodel {
  final String profilePic;
  final String userName;
  final String useruid;
  final String text;
  final String commentId;
  final DateTime datePublished;
  Replymodel({
    required this.profilePic,
    required this.userName,
    required this.useruid,
    required this.text,
    required this.commentId,
    required this.datePublished,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'profilePic': profilePic});
    result.addAll({'userName': userName});
    result.addAll({'useruid': useruid});
    result.addAll({'text': text});
    result.addAll({'commentId': commentId});
    result.addAll({'datePublished': datePublished.millisecondsSinceEpoch});

    return result;
  }

  factory Replymodel.fromMap(Map<String, dynamic> map) {
    return Replymodel(
      profilePic: map['profilePic'] ?? '',
      userName: map['userName'] ?? '',
      useruid: map['useruid'] ?? '',
      text: map['text'] ?? '',
      commentId: map['commentId'] ?? '',
      datePublished: DateTime.fromMillisecondsSinceEpoch(map['datePublished']),
    );
  }
}
