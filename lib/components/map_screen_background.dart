import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/class/app_state_manager.dart';
import 'package:weather_app/components/map_pin.dart';
import 'package:weather_app/components/weather_detail.dart';
import 'package:weather_app/screen/weather_screen.dart';

class MapScreenBackground extends StatelessWidget {
  /// This widget represents the background of the [WeatherScreen] widget.
  ///
  /// It takes the parameters [loading] and [child]. When there are no weather
  /// data available in the app's state (in [AppStateManager]), a loading indicator
  /// will be displayed until the weather data is fetched.
  ///
  /// Parameters:
  /// [loading]: A boolean that indicates if there is weather data available in
  /// the app's state
  /// [child]: The widget that should be displayed over the background.
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
          duration: const Duration(milliseconds: 1500),
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
  const _CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
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
