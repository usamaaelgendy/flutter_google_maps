import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final Set<Polyline> _polyline = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: const CameraPosition(
          target: LatLng(30.05062677338497, 31.475054486541794),
          zoom: 14,
        ),
        polylines: _polyline,
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);

          setState(
            () async {
              _polyline.add(
                Polyline(
                  polylineId: PolylineId("Route"),
                  color: Colors.green,
                  width: 4,
                  points: [
                    LatLng(30.05062677338497, 31.475054486541794),
                    LatLng(30.038253414602, 31.475082903896638),
                    LatLng(30.04792100191178, 31.468916337895596),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
