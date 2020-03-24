import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/post.dart';
import 'package:vouched/src/models/post.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final Post post;
  final PostBloc postBloc;
  final String userId;
  final Function showPostAction;

  const PostCard(
      {Key key, this.post, this.postBloc, this.userId, this.showPostAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => post != null ? showPostAction(context, post) : null,
        child: Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
          child: post != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(post.avatar),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 9.2),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 5.0),
                                                child: Text(
                                                  post.name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24.0),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.0),
                                                child: Text('·'),
                                              ),
                                              Text(timeago.format(
                                                  post.createdAt.toDate(),
                                                  locale: 'en_short')),
                                            ],
                                          ),
                                          /* IconButton(
                                      icon: Icon(Icons.star_border,
                                          color: post
                                                      .userVisibilityMetadata
                                                      .userVisibilityMetadata[
                                                          userId]
                                                      .state ==
                                                  VisibilityMetadataState.PINNED
                                              ? Colors.yellow
                                              : Colors.grey),
                                      onPressed: () async {
                                        await postBloc.updateFavorite(
                                            post.id,
                                            userId,
                                            !(post
                                                    .userVisibilityMetadata
                                                    .userVisibilityMetadata[
                                                        userId]
                                                    .state ==
                                                VisibilityMetadataState
                                                    .PINNED));
                                      },
                                    ),*/
                                        ])),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              : "There are no posts...",
        ));
  }
}
