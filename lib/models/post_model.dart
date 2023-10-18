class PostModel {
  final String text;
  final List<String> hashtags;
  final String? link;
  final String? imageLinks;
  final String uid;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> commentIds;
  final String postId;
  final int sharedCount;
  final String username;
  final String profilePic;
  PostModel({
    required this.text,
    required this.hashtags,
    this.link,
    this.imageLinks,
    required this.uid,
    required this.createdAt,
    required this.likes,
    required this.commentIds,
    required this.postId,
    required this.sharedCount,
    required this.username,
    required this.profilePic,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'text': text});
    result.addAll({'hashtags': hashtags});
    if (link != null) {
      result.addAll({'link': link});
    }
    if (imageLinks != null) {
      result.addAll({'imageLinks': imageLinks});
    }
    result.addAll({'uid': uid});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'likes': likes});
    result.addAll({'commentIds': commentIds});
    result.addAll({'postId': postId});
    result.addAll({'sharedCount': sharedCount});
    result.addAll({'username': username});
    result.addAll({'profilePic': profilePic});

    return result;
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      text: map['text'] ?? '',
      hashtags: List<String>.from(map['hashtags']),
      link: map['link'],
      imageLinks: map['imageLinks'],
      uid: map['uid'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      likes: List<String>.from(map['likes']),
      commentIds: List<String>.from(map['commentIds']),
      postId: map['postId'] ?? '',
      sharedCount: map['sharedCount']?.toInt() ?? 0,
      username: map['username'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }
}
