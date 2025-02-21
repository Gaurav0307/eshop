import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationService extends GetxController {
  var locality = ''.obs;
  var city = ''.obs;
  var state = ''.obs;
  var country = ''.obs;
  var lat = 0.0.obs;
  var lon = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    setInitialData();
    setPositionListener();
  }

  Future<void> setInitialData() async {
    try {
      var position = await getCurrentLocation();

      debugPrint("Accuracy : ${position.accuracy}");

      await setData(lat: position.latitude, lon: position.longitude);
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
  }

  Future<void> setPositionListener() async {
    try {
      var locationStream = await currentLocationStream();

      locationStream.onData(
        (position) async {
          debugPrint("Accuracy : ${position.accuracy}");
          debugPrint('Lat: ${position.latitude}, Lon: ${position.longitude}');

          lat.value = position.latitude;
          lon.value = position.longitude;
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
      await setInitialData();
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

///Old Code
/*
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  var city = ''.obs;
  var state = ''.obs;
  var country = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    setInitialData();
  }

  Future<void> setInitialData() async {
    isLoading.value = true;
    var position = await getCurrentLocation();
    var locationData = await getLocationData(
      lat: position.latitude,
      lon: position.longitude,
    );
    debugPrint("Accuracy : ${position.accuracy}");
    city.value = locationData.city;
    state.value = locationData.state;
    country.value = locationData.country;
    isLoading.value = false;
  }

  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<void> _locationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  late LocationSettings _locationSettings;

  Future<void> _applyLocationSettings() async {
    await _locationPermission();

    if (defaultTargetPlatform == TargetPlatform.android) {
      _locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      _locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else if (kIsWeb) {
      _locationSettings = WebSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        maximumAge: const Duration(minutes: 5),
      );
    } else {
      _locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
  }

  Future<StreamSubscription<Position>> currentLocationStream() async {
    await _applyLocationSettings();

    // supply location settings to getPositionStream
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: _locationSettings)
            .listen((Position? position) {
      debugPrint(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
    return positionStream;
  }

  Future<Position> getCurrentLocation() async {
    await _applyLocationSettings();

    // supply location settings to getCurrentPosition
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: _locationSettings);

    return position;
  }

  Future<Position?> getLastLocation() async {
    await _applyLocationSettings();

    // supply location settings to getCurrentPosition
    Position? position = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true);

    return position;
  }

  Future<LocationData> getLocationData({
    required double lat,
    required double lon,
  }) async {
    String? address;
    String? addressName;
    String? street;
    String? subLocality;
    String? locality;
    String? subThoroughfare;
    String? thoroughfare;
    String? subAdministrativeArea;
    String? administrativeArea;
    String? postalCode;
    String? country;

    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lon);
      address = placeMarks[0].toString();
      addressName = placeMarks[0].name;
      street = placeMarks[0].street;
      subLocality = placeMarks[0].subLocality;
      locality = placeMarks[0].locality;
      subThoroughfare = placeMarks[0].subThoroughfare;
      thoroughfare = placeMarks[0].thoroughfare;
      subAdministrativeArea = placeMarks[0].subAdministrativeArea;
      administrativeArea = placeMarks[0].administrativeArea;
      postalCode = placeMarks[0].postalCode;
      country = placeMarks[0].country;

      // debugPrint("Address : $address");
    } catch (e) {
      debugPrint('getGeocoding() Exception : $e');
    }

    return LocationData(
      locality: subLocality ?? '',
      city: locality ?? '',
      state: administrativeArea ?? '',
      postalCode: postalCode ?? '',
      country: country ?? '',
    );
  }
}

class LocationData {
  final String locality;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  LocationData({
    required this.city,
    required this.state,
    required this.locality,
    required this.postalCode,
    required this.country,
  });

  @override
  String toString() {
    return 'LocationData{locality: $locality, city: $city, state: $state, postalCode: $postalCode, country: $country}';
  }
}
*/
