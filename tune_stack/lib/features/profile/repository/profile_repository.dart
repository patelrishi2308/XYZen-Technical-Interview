// ignore_for_file: one_member_abstracts

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tune_stack/config/custom_exception.dart';

abstract interface class IProfileRepository {
  Future<List<Map<String, dynamic>>> getAllPostByUser(String userId);
}

class ProfileRepository implements IProfileRepository {
  @override
  Future<List<Map<String, dynamic>>> getAllPostByUser(String userId) async {
    try {
      final Query query = FirebaseFirestore.instance.collection('posts').where('userId', isEqualTo: userId);

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        final data = doc.data()! as Map<String, dynamic>;
        data['userId'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw CustomException('User post not found');
    }
  }
}
