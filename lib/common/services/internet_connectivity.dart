import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eshop/common/utils/utility_methods.dart';
import 'package:eshop/views/screens/no_internet_screen.dart';
import 'package:get/get.dart';

import '../global/global.dart';

class InternetConnectivity {
  static void addConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result.any((e) => e == ConnectivityResult.none)) {
        Get.to(() => const NoInternetScreen());
      } else {
        Get.back();
        UtilityMethods.loadInitialData().then((_) {
          if (selectedLocation.city.value.isNotEmpty) {
            businessServiceController.getNearByBusinessService(
              country: selectedLocation.country.value,
              state: selectedLocation.state.value,
              city: selectedLocation.city.value,
            );
          }
        });
      }
    });
  }
}
