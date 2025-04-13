import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_stack/config/custom_exception.dart';
import 'package:tune_stack/constants/app_strings.dart';
import 'package:tune_stack/features/common/user_model.dart';
import 'package:tune_stack/features/home/controllers/home_state.dart';
import 'package:tune_stack/features/home/model/get_all_comments.dart';
import 'package:tune_stack/features/home/model/get_all_posts.dart';
import 'package:tune_stack/features/home/repository/home_repository.dart';
import 'package:tune_stack/helpers/preference_helper.dart';

final homeStateNotifierProvider = StateNotifierProvider<HomeStateNotifier, HomeState>(
  (ref) => HomeStateNotifier(
    homeRepository: ref.read(_homeRepository),
  ),
);

final _homeRepository = Provider((ref) => HomeRepository());

class HomeStateNotifier extends StateNotifier<HomeState> {
  HomeStateNotifier({
    required this.homeRepository,
  }) : super(HomeState.initial());

  final IHomeRepository homeRepository;

  Future<void> getAllPosts() async {
    state = state.copyWith(isLoading: true);
    final getAllPosts = await homeRepository.getAllPost();
    state = state.copyWith(isLoading: false);
    if (getAllPosts.isNotEmpty) {
      final getAllPostsList = getAllPosts.map(GetAllPosts.fromJson).toList().reversed.toList();
      for (final post in getAllPostsList) {
        final isLiked = await isPostLikedByCurrentUser(post.postId);
        post.isLiked = isLiked;
      }

      state = state.copyWith(getAllPostsList: getAllPostsList);
    } else {
      state = state.copyWith(getAllPostsList: []);
    }
  }

  Future<void> getUserByUserId() async {
    final userId = SharedPreferenceHelper.getString(AppStrings.userID);
    if (userId != null) {
      try {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

        if (userDoc.exists) {
          final userDataMap = userDoc.data()! as Map<String, dynamic>;
          final userModel = UserModel.fromMap(userDataMap);
          state = state.copyWith(userModel: userModel);
        } else {
          debugPrint('User not found');
        }
      } catch (e) {
        debugPrint('Error getting user: $e');
      }
    }
  }

  Future<bool> toggleLike(String? postId, int index) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
      final likeRef = postRef.collection('likes').doc(currentUserId);
      final getAllPosts = state.getAllPostsList[index];
      if (getAllPosts.isLiked ?? false) {
        getAllPosts.isLiked = false;
        if ((getAllPosts.likeCount ?? 0) > 0) {
          getAllPosts.likeCount = (getAllPosts.likeCount ?? 1) - 1;
        }
        state = state.copyWith(getAllPostsList: state.getAllPostsList);
      } else {
        getAllPosts
          ..isLiked = true
          ..likeCount = (getAllPosts.likeCount ?? 1) + 1;
        state = state.copyWith(getAllPostsList: state.getAllPostsList);
      }

      final doc = await likeRef.get();

      if (doc.exists) {
        final postSnap = await postRef.get();
        final currentLikeCount = (postSnap.data()?['likeCount'] ?? 0) as int;

        await likeRef.delete();

        if (currentLikeCount > 0) {
          await postRef.update({
            'likeCount': FieldValue.increment(-1),
          });
          return false;
        }
      } else {
        await likeRef.set({
          'likedAt': FieldValue.serverTimestamp(),
        });
        await postRef.update({
          'likeCount': FieldValue.increment(1),
        });
        return true;
      }
    } catch (e) {
      debugPrint('Ex -> $e');
    }

    return false;
  }

  Future<bool> isPostLikedByCurrentUser(String? postId) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) return false;

      final likeDoc = FirebaseFirestore.instance.collection('posts').doc(postId).collection('likes').doc(currentUserId);

      final likeDocSnapshot = await likeDoc.get();

      return likeDocSnapshot.exists;
    } catch (e) {
      throw CustomException('Something went wrong');
    }
  }

  Future<void> addComments(String commentText, int? index) async {
    if (state.getAllPostsList.isNotEmpty) {
      final getAllPosts = state.getAllPostsList[index ?? 0];

      final postRef = FirebaseFirestore.instance.collection('posts').doc(getAllPosts.postId);
      await postRef.update({
        'commentCount': FieldValue.increment(1),
      });
      getAllPosts.commentCount = (getAllPosts.commentCount ?? 0) + 1;
      state = state.copyWith(getAllPostsList: state.getAllPostsList);

      final comment = {
        'userId': state.userModel?.uid,
        'username': state.userModel?.userName,
        'text': commentText,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      };

      await FirebaseFirestore.instance.collection('posts').doc(getAllPosts.postId).collection('comments').add(comment);
    }
  }

  Future<void> getAllComments(String? postId) async {
    state = state.copyWith(isLoading: true);
    final Query query = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false);

    final snapshot = await query.get();

    final allCommentsMap = snapshot.docs.map((doc) {
      final data = doc.data()! as Map<String, dynamic>;
      data['userId'] = doc.id;
      return data;
    }).toList();

    final getAllCommentsList = allCommentsMap.map(CommentModel.fromJson).toList().reversed.toList();
    state = state.copyWith(isLoading: false);
    debugPrint('GetAllComments:: -> ${getAllCommentsList.length}');
    state = state.copyWith(commentsList: getAllCommentsList);
  }
}
