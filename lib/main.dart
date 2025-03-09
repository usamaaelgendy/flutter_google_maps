import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

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

  String mapStyle = "";
  Set<Marker> markers = {};
  StreamSubscription<Position>? _positionStream;
  bool _isPermissionGranted = false;
  LatLng? _currentLocation;

  @override
  void initState() {
    _loadMapStyle();
    _checkPermissionRequest();
    super.initState();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: _isPermissionGranted,
        style: mapStyle,
        initialCameraPosition: const CameraPosition(
          target: LatLng(31.232051829912297, 29.958269615227238),
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);

          setState(() async {
            markers.addAll(
              {
                Marker(
                  markerId: const MarkerId("Market 1"),
                  position: const LatLng(31.232051829912297, 29.958269615227238),
                  infoWindow: const InfoWindow(title: "Market 1", snippet: "Alex"),
                  icon: await _customIcon("assets/marker.png"),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hello")));
                  },
                ),
                Marker(
                  markerId: const MarkerId("Market 2 "),
                  position: const LatLng(31.218677826191115, 29.958483484309085),
                  infoWindow: const InfoWindow(title: "Market 1", snippet: "Alex"),
                  icon: await _customIcon("assets/car.png"),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hello")));
                  },
                ),
              },
            );
          });
        },
        markers: markers,
      ),
    );
  }

  Future _loadMapStyle() async {
    final String style = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    setState(() {
      mapStyle = style;
    });
  }

  Future<BitmapDescriptor> _customIcon(String assets) async {
    return await BitmapDescriptor.asset(const ImageConfiguration(size: Size(48, 48)), assets);
  }

  _checkPermissionRequest() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
      _getUserLocation();
    } else {
      // show Dialog
    }
  }

  void _getUserLocation() async {
    if (!_isPermissionGranted) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentLocation ?? const LatLng(30.032147643718574, 31.463156048547326),
          zoom: 14,
        ),
      ),
    );
    _startTracking();
  }

  void _startTracking() async {
    _positionStream =
        Geolocator.getPositionStream(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high))
            .listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      _controller.future.then((controller) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _currentLocation ?? const LatLng(30.032147643718574, 31.463156048547326),
              zoom: 14,
            ),
          ),
        );
      });
    });
  }
}
