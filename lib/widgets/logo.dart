import 'package:flutter/material.dart';

class GitSafariLogo extends StatelessWidget {
  const GitSafariLogo({
    super.key,
    required this.padding,
  });
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Image(
        image: AssetImage('assets/logo/gitsafari_logo.png'),
        // height: 50.0,
      ),
    );
  }
}
