import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eshop/views/screens/no_internet_screen.dart';
import 'package:get/get.dart';

class InternetConnectivity {
  static bool isInternet = true;
  static void addConnectivityListener(void Function() callback) {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result.any((e) => e == ConnectivityResult.none)) {
        isInternet = false;
        Get.to(() => const NoInternetScreen());
      } else {
        if (!isInternet) {
          Get.back();
          callback();
        }
        isInternet = true;
      }
    });
  }
}
