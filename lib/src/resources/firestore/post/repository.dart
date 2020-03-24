import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/post.dart';
import 'package:vouched/src/resources/firestore/post/provider.dart';

class PostRepository {
  final _postProvider = PostProvider();

  Future<Post> create(Post post) => _postProvider.create(post);

  Stream<QuerySnapshot> listPosts(String uid,
          {bool isArchived = false, bool isAnon = false}) =>
      _postProvider.listPosts(uid, isArchived: isArchived, isAnon: isAnon);

  Future<void> updateFavorite(String postId, String userId, bool isFavorite) =>
      _postProvider.updateFavorite(postId, userId, isFavorite);

  Future<void> updateArchived(String postId, String userId, bool isArchived) =>
      _postProvider.updateArchived(postId, userId, isArchived);
}
