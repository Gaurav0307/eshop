import 'dart:async';

import 'package:eshop/common/global/global.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationService extends GetxController {
  var locality = ''.obs;
  var city = ''.obs;
  var state = ''.obs;
  var country = ''.obs;
  var pinCode = ''.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    setInitialData();
  }

  Future<void> setInitialData() async {
    try {
      var position = await getCurrentLocation();

      debugPrint("Accuracy : ${position.accuracy}");

      await setData(lat: position.latitude, lon: position.longitude);

      await setPositionListener();
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }
  }

  Future<void> setData({required double lat, required double lon}) async {
    var locationData = await getLocationData(lat: lat, lon: lon);

    locality.value = locationData.locality;
    city.value = locationData.city;
    state.value = locationData.state;
    country.value = locationData.country;
    pinCode.value = locationData.postalCode;
    latitude.value = lat;
    longitude.value = lon;

    selectedLocation.country.value = country.value;
    selectedLocation.state.value = state.value;
    selectedLocation.city.value = city.value;
  }

  Future<void> setPositionListener() async {
    try {
      var locationStream = await currentLocationStream();

      locationStream.onData(
        (position) async {
          debugPrint("Accuracy : ${position.accuracy}");
          debugPrint('Lat: ${position.latitude}, Lon: ${position.longitude}');

          latitude.value = position.latitude;
          longitude.value = position.longitude;
        },
      );
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }
  }

  double getDistanceBetween({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

  Future<void> _checkLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      debugPrint('Location services are disabled.');
      await Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }
  }

  Future<LocationSettings> _getLocationSettings() async {
    await _checkLocationPermission();

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "Location tracking active",
          notificationTitle: "Running in Background",
          enableWakeLock: true,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
      );
    } else if (kIsWeb) {
      return WebSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        maximumAge: const Duration(minutes: 5),
      );
    } else {
      return const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
  }

  Future<StreamSubscription<Position>> currentLocationStream() async {
    LocationSettings settings = await _getLocationSettings();

    return Geolocator.getPositionStream(locationSettings: settings)
        .listen((Position? position) {
      debugPrint(position == null
          ? 'Unknown'
          : 'Lat: ${position.latitude}, Lon: ${position.longitude}');
    });
  }

  Future<Position> getCurrentLocation() async {
    LocationSettings settings = await _getLocationSettings();
    return await Geolocator.getCurrentPosition(locationSettings: settings);
  }

  Future<Position?> getLastLocation() async {
    await _checkLocationPermission();
    return await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true);
  }

  Future<LocationData> getLocationData({
    required double lat,
    required double lon,
  }) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lon);
      Placemark place = placeMarks.first;

      return LocationData(
        locality: place.subLocality ?? '',
        city: place.locality ?? '',
        state: place.administrativeArea ?? '',
        postalCode: place.postalCode ?? '',
        country: place.country ?? '',
      );
    } catch (e) {
      debugPrint('Error fetching geocoding data: $e');
      return const LocationData(
        locality: '',
        city: '',
        state: '',
        postalCode: '',
        country: '',
      );
    }
  }
}

class LocationData {
  final String locality;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  const LocationData({
    required this.locality,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  @override
  String toString() {
    return 'LocationData(locality: $locality, city: $city, state: $state, postalCode: $postalCode, country: $country)';
  }
}
