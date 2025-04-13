class GetAllPosts {
  GetAllPosts({
    this.createdAt,
    this.audioUrl,
    this.coverImageUrl,
    this.description,
    this.postTitle,
    this.postId,
    this.category,
    this.userId,
    this.userName,
    this.fileType,
    this.isLiked,
    this.likeCount,
    this.commentCount,
  });

  GetAllPosts.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'].toString();
    audioUrl = json['audioUrl'].toString();
    coverImageUrl = json['coverImageUrl'].toString();
    description = json['description'].toString();
    postTitle = json['postTitle'].toString();
    postId = json['postId'].toString();
    category = json['category'].toString();
    userId = json['userId'].toString();
    fileType = json['fileType'].toString();
    likeCount =
        (json['likeCount'] != null && json['likeCount'].toString() != 'null' && json['likeCount'].toString().isNotEmpty)
            ? int.parse(json['likeCount'].toString())
            : 0;
    commentCount = (json['commentCount'] != null &&
            json['commentCount'].toString() != 'null' &&
            json['commentCount'].toString().isNotEmpty)
        ? int.parse(json['commentCount'].toString())
        : 0;
    userName = json['userName'].toString();
  }

  String? createdAt;
  String? audioUrl;
  String? coverImageUrl;
  String? description;
  String? postTitle;
  String? postId;
  String? category;
  String? userId;
  String? fileType;
  bool? isLiked;
  int? likeCount;
  int? commentCount;
  String? userName;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['audioUrl'] = audioUrl;
    data['coverImageUrl'] = coverImageUrl;
    data['description'] = description;
    data['postTitle'] = postTitle;
    data['postId'] = postId;
    data['category'] = category;
    data['fileType'] = fileType;
    data['userId'] = userId;
    data['userName'] = userName;
    data['likeCount'] = likeCount;
    data['commentCount'] = commentCount;
    return data;
  }
}
