import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/post.dart';
import 'package:vouched/src/resources/firestore/post/repository.dart';

class PostBloc implements Bloc {
  final _postRepository = PostRepository();

  Future<Post> create(Post post) => _postRepository.create(post);

  Stream<QuerySnapshot> listPosts(String uid,
          {bool isArchived = false, bool isAnon}) =>
      _postRepository.listPosts(uid, isArchived: isArchived, isAnon: isAnon);

  Future<void> updateFavorite(String postId, String userId, bool isFavorite) =>
      _postRepository.updateFavorite(postId, userId, isFavorite);

  Future<void> updateArchived(String postId, String userId, bool isArchived) =>
      _postRepository.updateArchived(postId, userId, isArchived);

  List<Post> mapToList(QuerySnapshot querySnapshot) {
    if (querySnapshot == null || querySnapshot.documents == null) return [];
    var posts = querySnapshot.documents
        ?.map((doc) => Post.fromJson(doc.data, id: doc.documentID))
        ?.toList();

    return posts != null ? posts : [];
  }

  dispose() async {}
}
