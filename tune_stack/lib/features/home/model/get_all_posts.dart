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
  }

  String? createdAt;
  String? audioUrl;
  String? coverImageUrl;
  String? description;
  String? postTitle;
  String? postId;
  String? category;
  String? userId;

  Map<String, String?> toJson() {
    final data = <String, String?>{};
    data['createdAt'] = createdAt;
    data['audioUrl'] = audioUrl;
    data['coverImageUrl'] = coverImageUrl;
    data['description'] = description;
    data['postTitle'] = postTitle;
    data['postId'] = postId;
    data['category'] = category;
    data['userId'] = userId;
    return data;
  }
}
