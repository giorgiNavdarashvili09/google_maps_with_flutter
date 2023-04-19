import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Location location = Location();
  final Set<Marker> markers = {
    Marker(
      markerId: MarkerId(LatLng(41.6938, 44.8015).toString()),
      position:LatLng(41.6938, 44.8015),
    ),
  };
  final Set<Circle> circles = {};

  Future<void> _goToCurrentLocation() async {
    try {
      var locationData = await location.getLocation();
      LatLng latLng = LatLng(locationData.latitude!, locationData.longitude!);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
    } catch (e) {
      print(e.toString());
    }
  }

  void createMarker(LatLng latLng) {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
        ),
      );
    });
  }

  void createCircle(LatLng latLng) {
    setState(() {
      circles.clear();
      circles.add(
        Circle(
          circleId: CircleId(latLng.toString()),
          center: latLng,
          radius: 1000,
          fillColor: Colors.blue.withOpacity(0.1),
          strokeColor: Colors.blueAccent,
          strokeWidth: 2,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Google Maps'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(41.6938, 44.8015),
              zoom: 16,
            ),
            markers: markers,
            circles: circles,
            onTap: createCircle,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}