class Post {
  String image;
  String name;
  String location;
  String post;
  String caption;
  String date;
  bool liked;
  String previewImageURL;
  var githubURL;
  String lang;

  Post({
    required this.previewImageURL,
    this.githubURL = 'https://github.com/foss42/api-dash',
    required this.image,
    required this.name,
    this.location = "Tokyo, Japan",
    required this.post,
    required this.caption,
    required this.lang,
    required this.date,
    this.liked = false,
  });
}
