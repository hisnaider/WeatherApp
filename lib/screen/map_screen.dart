import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController _mapController = MapController();
  @override
  Widget build(BuildContext context) {
    print("teste");
    return Scaffold(
      body: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
              zoom: 13,
              maxZoom: 13,
              minZoom: 8,
              center: LatLng(-32.0353776, -52.10758020000003),
              interactiveFlags:
                  InteractiveFlag.drag | InteractiveFlag.pinchZoom),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.weatherapp.app',
            )
          ]),
    );
  }
}
