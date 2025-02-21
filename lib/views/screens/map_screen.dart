import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/constants/string_constants.dart';

class MapScreen extends StatefulWidget {
  final double lat;
  final double lon;
  final String title;

  const MapScreen({
    super.key,
    required this.lat,
    required this.lon,
    required this.title,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  late BitmapDescriptor customMarkerIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  // Load Custom Marker from Assets
  Future<void> _loadCustomMarker() async {
    customMarkerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(30, 30)), // Adjust size if needed
      'assets/icons/store.png',
    );
    setState(() {}); // Refresh UI after loading
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          StringConstants.location,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.lon),
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: MarkerId(widget.title),
            position: LatLng(widget.lat, widget.lon),
            infoWindow:
                InfoWindow(title: widget.title), // Shop Name above Marker
            icon: customMarkerIcon, // Custom Icon
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
