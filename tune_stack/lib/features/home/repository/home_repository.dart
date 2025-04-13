// ignore_for_file: one_member_abstracts

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tune_stack/config/custom_exception.dart';

abstract interface class IHomeRepository {
  Future<List<Map<String, dynamic>>> getAllPost();
}

class HomeRepository implements IHomeRepository {
  final bool _hasMorePosts = true;

  @override
  Future<List<Map<String, dynamic>>> getAllPost() async {
    try {
      final Query query = FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt'); // Use a field to order, like 'createdAt'

      final snapshot = await query.get();

      // Return the data and add userId
      return snapshot.docs.map((doc) {
        final data = doc.data()! as Map<String, dynamic>;
        data['userId'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw CustomException('Failed to load posts: $e');
    }
  }

  bool hasMorePosts() => _hasMorePosts;
}
