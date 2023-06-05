import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/api/client.dart';
import 'package:instagram/utils/api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/post_model.dart';

// ignore: must_be_immutable
class PostWidget extends StatelessWidget {
  Post post;
  int id;
  final PageController pageController = PageController();
  Function(BuildContext, int) likePost;
  PostWidget(
      {Key? key, required this.post, required this.id, required this.likePost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                post.image,
                width: 32.0,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 1.0),
                  child: Text(
                    post.name,
                    style: TextStyle(color: Color(0xFFF9F9F9), fontSize: 13),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    post.location,
                    style: TextStyle(color: Color(0xFFF9F9F9), fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
        ),
        Builder(builder: (context) {
          return GestureDetector(
            onDoubleTap: () {
              likePost(context, id);
            },
            child: FutureBuilder(
              future: ApiClient.storage.getFileDownload(
                  bucketId: ApiInfo.bucketId, fileId: post.post),
              builder: (context, snapshot) {
                return snapshot.hasData && snapshot.data != null
                    ? ExpandablePageView(
                      controller: pageController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Image.network(
                                post.previewImageURL,
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16, right: 16),
                                  child: CircleAvatar(
                                    radius:
                                        20, // Adjust the radius to your preference
                                    backgroundColor: Colors.grey,
                                    child: IconButton(
                                      color: Colors.white,
                                      icon: Icon(Icons.launch),
                                      onPressed: _launchUrl,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Image.memory(
                                snapshot.data! as Uint8List,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16, right: 16),
                                  child: CircleAvatar(
                                    radius:
                                        20, // Adjust the radius to your preference
                                    backgroundColor: Colors.grey,
                                    child: IconButton(
                                      color: Colors.white,
                                      icon: Icon(Icons.launch),
                                      onPressed: _launchUrl,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    )
                    : CircularProgressIndicator();
              },
            ),
          );
        }),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 13.5,
                left: 14.0,
                bottom: 16.0,
              ),
              child: Builder(builder: (context) {
                return IconButton(
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: Image.asset(
                    (post.liked)
                        ? "assets/liked_button.png"
                        : "assets/nav_notif.png",
                    width: 24.0,
                  ),
                  onPressed: () {
                    likePost(context, id);
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 13.5,
                left: 14.0,
                bottom: 16.0,
              ),
              child: IconButton(
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: Image.asset(
                  "assets/comment.png",
                  width: 24.0,
                ),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 13.5,
                left: 14.0,
                bottom: 16.0,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Image.asset(
                  "assets/messanger.png",
                  width: 24.0,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Image.asset(
                "assets/profile_1.png",
                width: 17.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Liked by craig_love and 44,686 others",
                style: TextStyle(
                  color: Color(0xFFF9F9F9),
                  fontSize: 13.0,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14.0, top: 6.0),
          child: Text(
            post.caption,
            style: TextStyle(
              color: Color(0xFFF9F9F9),
              fontSize: 13.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14.0, top: 13.0, bottom: 14.0),
          child: Text(
            post.date,
            style: TextStyle(
              color: Color(0x99FFFFFF),
              fontSize: 11.0,
            ),
          ),
        ),
        Container(
          height: 0.5,
          color: Color(0x55FFFFFF),
        ),
      ],
    );
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(post.githubURL);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
