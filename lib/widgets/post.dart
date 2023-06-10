import 'dart:async';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gitsafari/consts/constants.dart';
import 'package:gitsafari/utils/appwrite/avatar_api.dart';
import 'package:intl/intl.dart';
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

  @override
  Widget build(BuildContext context) {
    final AvatarAPI avatars = AvatarAPI();
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
                  child: FutureBuilder(
                    future: avatars.getInitialsAvatar(widget.post.name),
                    //works for both public file and private file, for private files you need to be logged in
                    builder: (context, snapshot) {
                      Widget child = snapshot.hasData && snapshot.data != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                height: 32,
                                snapshot.data!,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 8,
                                child: CircularProgressIndicator(),
                              ),
                            );
                      return AnimatedSwitcher(
                        duration: Duration(seconds: 1),
                        child: child,
                      );
                    },
                    // child: Image.asset(
                    //   "assets/profile.png",
                    //   width: 86.0,
                    //   fit: BoxFit.fill,
                    // ),
                  )
                  // child: Image.asset(
                  //   widget.post.image,
                  //   width: 32.0,
                  // ),
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
                  'assets/icons/${widget.post.lang}/.svg',
                  width: 50,
                  height: 50,
                ),
              )
            ],
          ),
          Builder(builder: (context) {
            return GestureDetector(
              child: ExpandablePageView(
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
                            imageUrl: widget.post.previewImageURL,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.only(bottom: 16, right: 16),
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
                        CachedNetworkImage(
                          imageUrl:
                              '${APPWRITE_URL}/storage/buckets/$BUCKET_ID/files/${widget.post.post}/view?project=$APPWRITE_PROJECT_ID',
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.only(bottom: 16, right: 16),
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
              ),
              onDoubleTap: () {
                widget.likePost(context, widget.id);
              },
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
              // "Date",
              DateFormat.yMMMEd().format(DateTime.parse(widget.post.date)),
              // DateFormat().add_yMMMMd().format(widget.post.date),
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
