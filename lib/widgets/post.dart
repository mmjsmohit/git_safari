import 'dart:typed_data';
import 'dart:async';
import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/api/client.dart';
import 'package:instagram/consts/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/post_model.dart';

// ignore: must_be_immutable
class PostWidget extends StatefulWidget {
  Post post;
  int id;
  final memorizer = AsyncMemoizer();
  Function(BuildContext, int) likePost;
  PostWidget(
      {Key? key, required this.post, required this.id, required this.likePost})
      : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final PageController pageController = PageController();

  _fetchData() {
    return widget.memorizer.runOnce(() async {
      return ApiClient.storage
          .getFileDownload(bucketId: BUCKET_ID, fileId: widget.post.post);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xff111625),
        borderRadius: BorderRadius.circular(15),
      ),
      // color: Colors.amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  widget.post.image,
                  width: 32.0,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 1.0),
                    child: Text(
                      widget.post.name,
                      style: TextStyle(color: Color(0xFFF9F9F9), fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      widget.post.location,
                      style: TextStyle(color: Color(0xFFF9F9F9), fontSize: 11),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  fit: BoxFit.contain,
                  theme: SvgTheme(currentColor: Colors.transparent),
                  // colorFilter:>???
                  // ColorFilter.mode(Colors.white, BlendMode.softLight),
                  'assets/icons/dart/dart-plain.svg',
                  width: 50,
                  height: 50,
                ),
              )
            ],
          ),
          Builder(builder: (context) {
            return GestureDetector(
              onDoubleTap: () {
                widget.likePost(context, widget.id);
              },
              child: FutureBuilder(
                future: _fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.waiting) {
                    return ExpandablePageView(
                      controller: pageController,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                                child: CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  imageUrl: widget.post.previewImageURL,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
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
                    );
                  } else {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: RefreshProgressIndicator(),
                      ),
                    );
                  }
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
                      (widget.post.liked)
                          ? "assets/liked_button.png"
                          : "assets/nav_notif.png",
                      width: 24.0,
                    ),
                    onPressed: () {
                      widget.likePost(context, widget.id);
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
              widget.post.caption,
              style: TextStyle(
                color: Color(0xFFF9F9F9),
                fontSize: 13.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0, top: 13.0, bottom: 14.0),
            child: Text(
              widget.post.date,
              style: TextStyle(
                color: Color(0x99FFFFFF),
                fontSize: 11.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(widget.post.githubURL);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
