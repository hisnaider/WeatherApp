import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/classes/app_state_manager.dart';
import 'package:weather_app/components/map_pin.dart';
import 'package:weather_app/screen/weather_screen.dart';

class MapScreenBackground extends StatelessWidget {
  /// Widget to render the background of the [WeatherScreen] widget.
  ///
  /// This widget displays a container with a gradient background color. When
  /// there is no weather data available in the [AppStateManager], a loading
  /// indicator is shown until the weather data is retrieved.
  ///
  /// It accepts the following parameters:
  /// - [loading]: A boolean that indicates if there is weather data available in
  /// the app's state
  /// - [child]: The widget that should be displayed over the background.
  ///
  /// A animated switcher is used to make a smooth transition between the loading
  /// indicator and child.
  ///
  /// This widget is primarily used as the background for the [WeatherScreen].
  const MapScreenBackground(
      {super.key, required this.loading, required this.child});
  final bool loading;
  final Widget child;

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
          duration: const Duration(milliseconds: 1250),
          child: SizedBox(
              key: ValueKey<bool>(loading),
              child: loading ? const _CustomLoadingIndicator() : child),
        ),
      ],
    );
  }
}

/// This widget represents the loading indicator used within [MapScreenBackground].
///
/// It displays an animated [MapPin], a loading message indicating that weather
/// data is being fetched, and the coordinates of the weather forecast.
class _CustomLoadingIndicator extends StatelessWidget {
  const _CustomLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    // Obtain the user's coordinates from the app's state
    List<double> coordinates =
        Provider.of<AppStateManager>(context, listen: false).coordinates;
    return Stack(
      children: [
        const MapPin(
          animate: true,
          iconColor: Colors.white,
        ),
        Center(
          child: Transform.translate(
              offset: const Offset(0, 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Carregando clima...",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                  Opacity(
                    opacity: 0.75,
                    child: Text(
                      "Lat: ${coordinates[0].toStringAsFixed(4)}, Lon: ${coordinates[1].toStringAsFixed(4)}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                    ),
                  )
                ],
              )),
        )
      ],
    );
  }
}
