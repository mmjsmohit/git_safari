import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gitsafari/consts/constants.dart';
import 'package:link_preview_generator/link_preview_generator.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class ContributeResources extends StatelessWidget {
  final String lang;

  ContributeResources({super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    final List<String> resources = kResourcesList[lang]!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          "assets/logo/gs_logo.png",
          width: 80,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Resources for ${lang.toCapitalized()}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Spacer(),
                SvgPicture.asset(
                  fit: BoxFit.contain,
                  theme: SvgTheme(currentColor: Colors.transparent),
                  'assets/icons/$lang/.svg',
                  width: 50,
                  height: 50,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: resources.length,
              itemBuilder: (context, index) => Container(
                key: ValueKey(resources[index]),
                margin: const EdgeInsets.all(15),
                // Generate a preview for each link.
                // Alternate between a large and small type preview widget.
                child: LinkPreviewGenerator(
                  boxShadow: List.empty(),
                  backgroundColor: Color(0xff111625),
                  bodyStyle: TextStyle(color: Colors.white, fontSize: 8),
                  titleStyle: TextStyle(color: Colors.white, fontSize: 24),
                  link: resources[index],
                  linkPreviewStyle: LinkPreviewStyle.large,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
