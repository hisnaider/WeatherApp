import 'package:flutter/material.dart';
import 'package:weather_app/components/weather_detail.dart';
import 'package:weather_app/screen/weather_screen.dart';

class MapScreenBackground extends StatelessWidget {
  final bool loading;
  final Widget child;
  const MapScreenBackground(
      {super.key, required this.loading, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: const Alignment(0, 0.75),
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.40),
                Theme.of(context).colorScheme.primary,
              ],
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          child: SizedBox(
              key: ValueKey<bool>(loading),
              child: loading
                  ? const Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 5,
                        ),
                      ),
                    )
                  : child),
        ),
      ],
    );
  }
}
