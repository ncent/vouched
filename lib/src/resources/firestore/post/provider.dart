import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vouched/src/models/post.dart';

class PostProvider {
  final CollectionReference postsCollection =
      Firestore.instance.collection('posts');

  Future<Post> create(Post post) async {
    var documentReference = await postsCollection.add(post.toJson());
    post.id = documentReference.documentID;
    return post;
  }

  Stream<QuerySnapshot> listPosts(
    String uid, {
    bool isArchived = false,
    bool isAnon = false,
  }) {
    if (isAnon) {
      return postsCollection
          .where('private', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .snapshots();
    }

    return postsCollection
        // TODO: Everything is public in this milestone 3.0
        // .where('visibility', arrayContains: uid)
        // .where('userVisibilityMetadata.$uid.state',
        //     isEqualTo: isArchived ? 'archived' : 'created')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateFavorite(
      String postId, String userId, bool isFavorite) async {
    return await postsCollection.document(postId).updateData({
      "userVisibilityMetadata.$userId.state": isFavorite
          ? VisibilityMetadataState.PINNED.value
          : VisibilityMetadataState.CREATED.value
    });
  }

  Future<void> updateArchived(
      String postId, String userId, bool isArchived) async {
    return await postsCollection.document(postId).updateData({
      "userVisibilityMetadata.$userId.state": isArchived
          ? VisibilityMetadataState.ARCHIVED.value
          : VisibilityMetadataState.CREATED.value
    });
  }
}
