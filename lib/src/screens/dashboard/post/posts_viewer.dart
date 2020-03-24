import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:vouched/src/blocs/auth/auth.dart';
import 'package:vouched/src/blocs/tracking.dart';
import 'package:vouched/src/models/post.dart';
import 'package:vouched/src/models/tracking.dart';
import 'package:vouched/src/screens/dashboard/post/dashboard_stack.dart';
import 'package:vouched/src/screens/dashboard/post/empty_stack.dart';

typedef OnPostSwipedCompleted(Post post);
typedef OnPostTapped(Post post);
typedef OnShowProfile();

class PostsViewer extends StatelessWidget {
  final List<Post> posts;
  final OnPostSwipedCompleted onPostSwipedCompleted;
  final OnPostTapped onPostTapped;
  final OnShowProfile onShowProfile;
  final TrackingBloc trackingBloc;
  final AuthBloc authBloc;

  const PostsViewer({
    Key key,
    this.posts,
    this.onPostSwipedCompleted,
    this.onPostTapped,
    this.onShowProfile,
    this.trackingBloc,
    this.authBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (posts.length == 0) {
      return EmptyDashboardStack();
    }

    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return DashboardStack(
          post: posts[index],
          index: index,
          onShowProfile: onShowProfile,
        );
      },
      scrollDirection: Axis.vertical,
      itemCount: posts.length,
      loop: false,
      onIndexChanged: (index) async {
        onPostSwipedCompleted(posts[index]);

        trackingBloc.track(Tracking(
            userID: authBloc.getUid,
            txAction: TrackingAction.PostSwiped,
            metadata: {
              "postID": posts[index].id,
              "isAnon": authBloc.getIsAnonymous,
            }));
      },
      onTap: (index) {
        onPostTapped(posts[index]);
      },
    );
  }
}
