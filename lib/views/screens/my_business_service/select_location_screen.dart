import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../common/constants/asset_constants.dart';
import '../../../common/constants/color_constants.dart';
import '../../../common/constants/string_constants.dart';
import '../../../common/global/global.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
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
      selectedLat.value = latitude;
      selectedLon.value = longitude;
      locationTitle.value = StringConstants.selectedLocation;
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
                selectedLat.value,
                selectedLon.value,
              ),
              zoom: 16,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: _onMapTapped,
            markers: _selectedLocation == null
                ? {
                    Marker(
                      markerId: MarkerId(
                        "$selectedLat, $selectedLon",
                      ),
                      position: LatLng(
                        selectedLat.value,
                        selectedLon.value,
                      ),
                      infoWindow: InfoWindow(title: locationTitle.value),
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
