class CommentModel {
  CommentModel({
    required this.userId,
    required this.username,
    required this.text,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> map) {
    return CommentModel(
      userId: map['userId'].toString(),
      username: map['username'].toString(),
      text: map['text'].toString(),
      createdAt: (map['createdAt'] != null) ? int.parse(map['createdAt'].toString()) : 0,
    );
  }
  final String userId;
  final String username;
  final String text;
  final int createdAt;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'text': text,
      'createdAt': createdAt,
    };
  }
}
