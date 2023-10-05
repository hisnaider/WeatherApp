import 'package:flutter/material.dart';

class MapScreenBackground extends StatelessWidget {
  const MapScreenBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment(0, 0.75),
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.40),
                Theme.of(context).colorScheme.primary,
              ],
            ),
          ),
        ),
        Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 5,
            ),
          ),
        ),
      ],
    );
  }
}
