import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget to displays pages in the [IntroductionScreen].
///
/// This widget is designed to present a page with an image, a title, and a
/// description related to the app. It can also display a blue mesh background
/// if specified.
///
/// Parameters:
/// - [title]: The title of the page;
/// - [text]: A descriptive text about the app;
/// - [image]: The image source, which can be either an SVG or a regular image,
///   determined by the first letter of the string ("i" for image or "s" for SVG).
/// - [showBackground]: Determines if the blue mesh background should be visible.
class IntroductionPageWidget extends StatelessWidget {
  const IntroductionPageWidget(
      {super.key,
      required this.title,
      required this.text,
      required this.image,
      required this.showBackground});
  final String title;
  final String text;
  final String image;
  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: showBackground,
                  child: SvgPicture.asset(
                    "svg/introduction_background.svg",
                  ),
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: -25,
                  child: image[0] == "i"
                      ? Image.asset(
                          image,
                          height: 348,
                        )
                      : SvgPicture.asset(image)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
