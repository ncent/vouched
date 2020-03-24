import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/auth/auth.dart';
import 'package:vouched/src/blocs/post.dart';
import 'package:vouched/src/models/post.dart';
import 'package:vouched/src/screens/archive/archive_data.dart';
import 'package:vouched/src/screens/dashboard/post/posts_viewer.dart';

class Archive extends StatefulWidget {
  @override
  ArchiveState createState() {
    return ArchiveState();
  }
}

class ArchiveState extends State<Archive> {
  AuthBloc _authBloc;
  PostBloc _postBloc;

  String title;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _postBloc = BlocProvider.of<PostBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Archive"),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(10.0),
        child: RefreshIndicator(
            onRefresh: refresh,
            child: StreamBuilder(
                stream: _postBloc.listPosts(_authBloc.getUid,
                    isArchived: true, isAnon: false),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    QuerySnapshot doc = snapshot.data;
                    List<Post> posts = _postBloc.mapToList(doc);
                    return PostsViewer(
                      posts: posts,
                    );
                  } else {
                    return Text('No Posts');
                  }
                })),
      ),
    );
  }
}
