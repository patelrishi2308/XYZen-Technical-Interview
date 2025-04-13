import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tune_stack/config/custom_exception.dart';
import 'package:tune_stack/config/env/env/my_env.dart';

abstract interface class ICreatePostRepository {
  Future<String> uploadCoverImage(File file, String fileName);

  Future<String> uploadMusic(File file, String fileName);

  Future<String> createPost(
    String coverImageUrl,
    String postTitle,
    String category,
    String description,
    String audioUrl,
    String uId,
    String userName,
    String fileType,
  );
}

class CreatePostRepository implements ICreatePostRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> uploadCoverImage(File file, String fileName) async {
    try {
      final response = await supabase.storage
          .from('spotifyclonenew') // bucket name
          .upload(fileName, file);

      final imageUrl = '${MyEnv.supaBaseStoreUrl}$response';
      return imageUrl;
    } catch (e) {
      throw CustomException('Upload failed!, Please try again later');
    }
  }

  @override
  Future<String> uploadMusic(File file, String fileName) async {
    try {
      final response = await supabase.storage
          .from('spotifyclonenew') // bucket name
          .upload(fileName, file);

      final imageUrl = '${MyEnv.supaBaseStoreUrl}$response';
      return imageUrl;
    } catch (e) {
      throw CustomException('Upload failed!, Please try again later');
    }
  }

  @override
  Future<String> createPost(
    String coverImageUrl,
    String postTitle,
    String category,
    String description,
    String audioUrl,
    String uId,
    String userName,
    String fileType,
  ) async {
    try {
      final postRef = _firestore.collection('posts').doc();

      await postRef.set({
        'postId': postRef.id,
        'coverImageUrl': coverImageUrl,
        'postTitle': postTitle,
        'category': category,
        'description': description,
        'audioUrl': audioUrl,
        'userId': uId,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'userName': userName,
        'visibility': 'public',
        'fileType': fileType,
      });
      return 'success';
    } catch (e) {
      throw CustomException('Upload failed!, Please try again later');
    }
  }
}
