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
      final Query query =
          FirebaseFirestore.instance.collection('posts').orderBy('createdAt'); // Use a field to order, like 'createdAt'

      // Apply pagination if a last document exists
      // if (_lastDocument != null) {
      //   query = query.startAfterDocument(_lastDocument!);
      // }

      final snapshot = await query.get();

      // if (snapshot.docs.isEmpty) {
      //   _hasMorePosts = false; // No more posts available
      //   return [];
      // }

      // Save the last document for pagination
      // _lastDocument = snapshot.docs.last;

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
