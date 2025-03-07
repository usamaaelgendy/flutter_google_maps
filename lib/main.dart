import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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

  @override
  void initState() {
    _loadMapStyle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
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
      floatingActionButton: FloatingActionButton(onPressed: () {
        _moveToCairo();
      }),
    );
  }

  void _moveToCairo() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(30.032147643718574, 31.463156048547326),
          zoom: 12,
        ),
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
}
