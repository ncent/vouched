import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:vouched/src/models/post.dart';

class PostStage extends StatelessWidget {
  final Slide slideItem;
  final image = 'https://i.picsum.photos/id/649/750/1334.jpg';

  const PostStage(
    this.slideItem, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildSlideMessage(context);
  }

  _buildSlideMessage(context) {
    final controller = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          color: Color(
            int.parse(
              slideItem.bgColor,
            ),
          ),
          child: Markdown(
            shrinkWrap: true,
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              h1: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 28,
                    color: Color(
                      int.parse(
                        slideItem.fontColor,
                      ),
                    ),
                  ),
              h2: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 24,
                    color: Color(
                      int.parse(
                        slideItem.fontColor,
                      ),
                    ),
                  ),
              h3: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 22,
                    color: Color(
                      int.parse(
                        slideItem.fontColor,
                      ),
                    ),
                  ),
              h4: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 20,
                    color: Color(
                      int.parse(
                        slideItem.fontColor,
                      ),
                    ),
                  ),
              h5: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 19,
                    color: Color(
                      int.parse(
                        slideItem.fontColor,
                      ),
                    ),
                  ),
              h6: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 19,
                    color: Color(
                      int.parse(
                        slideItem.fontColor,
                      ),
                    ),
                  ),
              listBullet: Theme.of(context).textTheme.body1.copyWith(
                    color: Color(
                      int.parse(
                        slideItem.fontColor,
                      ),
                    ),
                  ),
              p: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 19,
                    color: Color(
                      int.parse(
                        slideItem.fontColor,
                      ),
                    ),
                  ),
            ),
            controller: controller,
            data: slideItem.message,
            selectable: false,
            imageDirectory: 'https://raw.githubusercontent.com',
          ),
        ),
      ],
    );
  }
}
