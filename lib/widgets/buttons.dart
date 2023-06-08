import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GradientSvgButton extends StatelessWidget {
  const GradientSvgButton(
      {super.key,
      required this.text,
      required this.imagePath,
      required this.onPressed,
      required this.color});

  final String text;
  final Color color;
  final String imagePath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF232526),
            Color(0xFF414345),
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(text),
            SvgPicture.asset(
              imagePath,
              height: 30,
              // ignore: deprecated_member_use
              color: color,
            )
          ],
        ),
      ),
    );
  }
}
