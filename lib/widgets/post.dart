import 'dart:async';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gitsafari/consts/constants.dart';
import 'package:gitsafari/screens/contribute_resources.dart';
import 'package:gitsafari/utils/appwrite/auth_api.dart';
import 'package:gitsafari/utils/appwrite/avatar_api.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/post_model.dart';

// ignore: must_be_immutable
class PostWidget extends StatefulWidget {
  Post post;
  int id;
  final memorizer = AsyncMemoizer();
  Function(BuildContext, String, String, List<dynamic>) upvotePost;

  PostWidget(
      {Key? key,
      required this.post,
      required this.id,
      required this.upvotePost})
      : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final AvatarAPI avatars = AvatarAPI();
    final auth = context.watch<AuthAPI>();
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
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      widget.post.name,
                      style: TextStyle(color: Color(0xFFF9F9F9), fontSize: 13),
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
                              '$APPWRITE_URL/storage/buckets/$BUCKET_ID/files/${widget.post.post}/view?project=$APPWRITE_PROJECT_ID',
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
                widget.upvotePost(context, widget.post.docId,
                    auth.currentUser.$id, widget.post.upvotes);
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
                child: Builder(
                  builder: (context) {
                    return IconButton(
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.zero,
                      // icon: Icon(
                      icon: (widget.post.upvotes.contains(auth.currentUser.$id))
                          ? Icon(
                              Icons.arrow_circle_up,
                              color: Colors.green,
                              size: 24,
                            )
                          : Icon(
                              Icons.arrow_circle_up_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                      //   size: 24,
                      //   color: Colors.white,
                      // ),
                      onPressed: () {
                        widget.upvotePost(context, widget.post.docId,
                            auth.currentUser.$id, widget.post.upvotes);
                      },
                    );
                  },
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
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Share.share(
                      "Check out this cool GitHub Repository I found on Git Safari: ${widget.post.githubURL}",
                    );
                  },
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
                  icon: Icon(
                    Icons.menu_book,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ContributeResources(lang: widget.post.lang),
                        ));
                  },
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  top: 13.5,
                  right: 14.0,
                  bottom: 16.0,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                    Text(
                      widget.post.upvotes.length.toString(),
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Text(
                  widget.post.upvotes.isNotEmpty
                      ? (widget.post.upvotes.length >= 2
                          ? "Upvoted by ${widget.post.upvotes.first} and ${widget.post.upvotes.length - 1} others."
                          : "Upvoted by ${widget.post.upvotes.first}")
                      : "No one has upvoted",

                  // "Upvoted by ${widget.post.upvotes.toString()}",
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
              overflow: TextOverflow.clip,
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
