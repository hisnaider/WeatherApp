import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/class/app_state_manager.dart';

/// This widget represents the centered pin over the map.
///
/// It includes a icon in svg and a animation. The animation is triggered when
/// the variable `cityHasBeenSelected`, that is in the global state
/// manager `AppStateManager`, is true
class MapPin extends StatefulWidget {
  const MapPin({super.key});

  @override
  State<MapPin> createState() => _MapPinState();
}

class _MapPinState extends State<MapPin> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pinAnimation;
  late Animation<double> _circleAnimation;
  late Animation<double> _opacity;

  /// Calculates the value of a custom sine wave curve.
  ///
  /// This function takes a [time] parameter representing time.
  /// It calculates and returns the value of a custom sine wave curve
  /// used to control the animation of a widget.
  ///
  /// The returned value is in the range of 0 to 1 and is used to adjust
  /// the animation according to the desired curve.
  double sineCurve(double time) {
    double value = sin(pi * (_pinAnimation.value * time)).abs();
    return value;
  }

  /// Initialize function
  ///
  /// This function sets the animations
  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _pinAnimation = Tween<double>(begin: 0, end: 0.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _circleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.25, 1)),
    );
    _opacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.25, 1)),
    );
    _controller.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double pinY = lerpDouble(-37.5, -27.5, sineCurve(4))!;
    double h = lerpDouble(1, 2, sineCurve(4))!;
    return Selector<AppStateManager, bool>(
      selector: (context, myState) => myState.cityHasBeenSelected,
      shouldRebuild: (previous, next) => previous != next,
      builder: (context, value, child) {
        if (value) {
          _controller.forward();
        } else {
          _controller.reset();
        }
        return Stack(
          children: [
            Opacity(
              opacity: _opacity.value,
              child: Transform.scale(
                scale: _circleAnimation.value,
                child: Center(
                  child: SvgPicture.string(
                    """
                    <svg height="22" width="62">
                  <ellipse cx="31" cy="11" rx="30" ry="10"
                  style="fill:transparent;stroke:#0085FF;stroke-width:2" />
                </svg>
                    """,
                  ),
                ),
              ),
            ),
            Center(
              child: SvgPicture.string(
                """
                <svg height="${2 * (2 * (h))}" width="${2 * (6 * h)}">
                      <ellipse cx="${6 * h}" cy="${2 * (h)}" rx="${6 * h}" ry="${2 * (h)}" fill="black" fill-opacity="0.25"/>
                    </svg>
                """,
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(0, pinY),
                child: Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.primary,
                  size: 70,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
