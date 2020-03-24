import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vouched/src/models/post.dart';
import 'package:vouched/src/screens/dashboard/post/post_stage.dart';

class PostContent extends StatelessWidget {
  final Post content;
  final image = 'https://i.picsum.photos/id/649/750/1334.jpg';
  final audioPath = 'https://ccrma.stanford.edu/~jos/mp3/bachfugue.mp3';
  static AudioPlayer audioPlayer = AudioPlayer();

  const PostContent({
    Key key,
    @required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // audioPlayer.play(audioPath, isLocal: false);
    int slideIndex = 0;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Stack(
          children: <Widget>[
            CarouselSlider(
              // pauseAutoPlayOnTouch: Duration(milliseconds: 10000),
              onPageChanged: (pageIndex) {
                setState(() {
                  slideIndex = pageIndex;
                });
              },
              viewportFraction: 1.0,
              scrollPhysics: NeverScrollableScrollPhysics(),
              aspectRatio: MediaQuery.of(context).size.aspectRatio,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              items: content.slides.map(
                (Slide slideItem) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: PostStage(slideItem),
                      );
                    },
                  );
                },
              ).toList(),
            ),
            _buildDotIndicator(content.slides.length, slideIndex),
          ],
        );
      },
    );
  }

  _buildDotIndicator(slidesLength, slideIndex) {
    final dots = Iterable<int>.generate(slidesLength).map((index) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 3.0,
        ),
        decoration: BoxDecoration(
          color: slideIndex == index ? Colors.grey : Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        width: 8,
        height: 8,
      );
    }).toList();

    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: dots,
      ),
    );
  }
}
