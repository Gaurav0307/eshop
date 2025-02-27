import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../common/constants/asset_constants.dart';
import '../../../common/constants/color_constants.dart';
import '../../../common/constants/string_constants.dart';
import '../../../common/global/global.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  void _pickLocation() {
    if (_selectedLocation != null) {
      double latitude = _selectedLocation!.latitude;
      double longitude = _selectedLocation!.longitude;
      debugPrint("Selected Location: Lat: $latitude, Lon: $longitude");

      ///
      selectedLocation.latitude.value = latitude;
      selectedLocation.longitude.value = longitude;
      selectedLocation.locationTitle.value = StringConstants.selectedLocation;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          StringConstants.selectLocation,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                selectedLocation.latitude.value,
                selectedLocation.longitude.value,
              ),
              zoom: 16,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: _onMapTapped,
            markers: _selectedLocation == null
                ? {
                    Marker(
                      markerId: MarkerId(
                        "${selectedLocation.latitude}, ${selectedLocation.longitude}",
                      ),
                      position: LatLng(
                        selectedLocation.latitude.value,
                        selectedLocation.longitude.value,
                      ),
                      infoWindow: InfoWindow(
                          title: selectedLocation.locationTitle.value),
                      // icon: customMarkerIcon,
                    ),
                  }
                : {
                    Marker(
                      markerId: const MarkerId(
                        StringConstants.selectedLocation,
                      ),
                      infoWindow: const InfoWindow(
                        title: StringConstants.selectedLocation,
                      ),
                      position: _selectedLocation!,
                    ),
                  },
          ),
          Positioned(
            bottom: 30,
            left: 60,
            right: 60,
            child: ElevatedButton(
              onPressed: _selectedLocation == null ? null : _pickLocation,
              child: Text(
                StringConstants.pickLocation,
                style: TextStyle(
                  fontFamily: AssetConstants.robotoFont,
                  fontSize: 14,
                  color: ColorConstants.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
