import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget that represents a map pin with animation.
///
/// This widget displays a map pin icon with optional animation. When animated,
/// the pin moves up and down using a sine wave curve. It also triggers a circular
/// wave-like effect and a shadow beneath the pin.
///
/// It accepts the following parameters:
/// - [animate]: A boolean indicating whether to animate the pin (default is false).
/// - [iconColor]: The color of the map pin icon (default is white).
///
/// The animation is controlled by a sine wave curve, creating a realistic pin movement.
class MapPin extends StatefulWidget {
  final bool animate;
  final Color iconColor;
  const MapPin(
      {super.key, this.animate = false, this.iconColor = Colors.white});

  @override
  State<MapPin> createState() => _MapPinState();
}

class _MapPinState extends State<MapPin> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pinAnimation;
  late Animation<double> _circleScale;
  late Animation<double> _opacity;
  double pinY = -37.5;
  double h = 1;
  double opacity = 0;
  double circleScale = 0;

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
    if (widget.animate) {
      _controller = AnimationController(
          duration: const Duration(milliseconds: 500), vsync: this)
        ..repeat();
      _pinAnimation = Tween<double>(begin: 0, end: 0.25).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _circleScale = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.25, 1)),
      );
      _opacity = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.25, 1)),
      );
      _controller.addListener(() {
        setState(() {
          pinY = lerpDouble(-37.5, -29.5, sineCurve(4))!;
          h = lerpDouble(1, 2, sineCurve(4))!;
          opacity = _opacity.value;
          circleScale = _circleScale.value;
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.animate) {
      _controller.stop();
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: circleScale,
            child: Center(
              // The circular Svg that is animated like a wave
              child: SvgPicture.string(
                """
                    <svg height="22" width="62">
                  <ellipse cx="31" cy="11" rx="30" ry="10"
                  style="fill:transparent;stroke:rgb(${widget.iconColor.red},${widget.iconColor.green},${widget.iconColor.blue});stroke-width:2" />
                </svg>
                    """,
              ),
            ),
          ),
        ),
        Center(
          // The semi-transparent circular Svg that represents the shadow of the pin
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
              color: widget.iconColor,
              size: 70,
            ),
          ),
        ),
      ],
    );
  }
}
