import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eshop/controllers/base_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../common/constants/api_constants.dart';
import '../common/global/global.dart';
import '../common/helper/dialog_helper.dart';
import '../common/services/app_exceptions.dart';
import '../common/services/base_client.dart';
import '../models/BusinessServiceModel.dart';

class BusinessServiceController extends GetxController with BaseController {
  var isLoading = false.obs;
  var businessServiceModel = BusinessServiceModel().obs;
  var services = <BusinessesServices>[].obs;
  var businesses = <BusinessesServices>[].obs;
  var userBusinessServiceModel = BusinessServiceModel().obs;

  Future<void> getAllBusinessService() async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.allBusinessServices;

    var responseJson =
        await BaseClient().get(baseUrl, endpoint, null).catchError(
      (error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          if (apiError["message"] != null) {
            DialogHelper.showErrorSnackBar(
              title: "Error",
              description: apiError["message"],
            );
          }
        } else {
          handleError(error);
        }
      },
    );

    if (kDebugMode) {
      log("Business/Services API Response :-> $responseJson");
    }

    if (responseJson != null) {
      var message = jsonDecode(responseJson)["message"];

      if (message != null) {
        // showMessage(description: message);
      }

      businessServiceModel.value = businessServiceModelFromJson(responseJson);
      businessServiceModel.value = businessServiceModelFromJson(responseJson);
      services.value = businessServiceModel.value.businessesServices!
          .where((e) => e.type == "Service")
          .toList();
      businesses.value = businessServiceModel.value.businessesServices!
          .where((e) => e.type == "Business")
          .toList();
    }

    isLoading.value = false;
  }

  Future<void> getNearByBusinessService({
    required String country,
    required String state,
    required String city,
  }) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.nearByBusinessService;

    var body = {
      "country": country,
      "state": state,
      "city": city,
    };

    var responseJson =
        await BaseClient().post(baseUrl, endpoint, null, body).catchError(
      (error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          if (apiError["message"] != null) {
            DialogHelper.showErrorSnackBar(
              title: "Error",
              description: apiError["message"],
            );
          }
        } else {
          handleError(error);
        }
      },
    );

    if (kDebugMode) {
      log("Near By Business/Services API Response :-> $responseJson");
    }

    if (responseJson != null) {
      var message = jsonDecode(responseJson)["message"];

      if (message != null) {
        // showMessage(description: message);
      }

      businessServiceModel.value = businessServiceModelFromJson(responseJson);
      services.value = businessServiceModel.value.businessesServices!
          .where((e) => e.type == "Service")
          .toList();
      businesses.value = businessServiceModel.value.businessesServices!
          .where((e) => e.type == "Business")
          .toList();
    }

    isLoading.value = false;
  }

  BusinessesServices? getBusinessServiceById(String id) {
    return businessServiceModel.value.businessesServices!
        .firstWhere((element) => element.id == id);
  }

  BusinessesServices? getUserBusinessServiceById(String id) {
    return userBusinessServiceModel.value.businessesServices!
        .firstWhere((element) => element.id == id);
  }

  Future<void> rateBusinessService({
    required String businessServiceId,
    required double rating,
  }) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.rateBusinessService;

    var body = {
      "businessServiceId": businessServiceId,
      "rating": rating.toString(),
    };

    var headers = {
      "Authorization": "Bearer $token",
    };

    var responseJson =
        await BaseClient().post(baseUrl, endpoint, headers, body).catchError(
      (error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          if (apiError["message"] != null) {
            DialogHelper.showErrorSnackBar(
              title: "Error",
              description: apiError["message"],
            );
          }
        } else if (error is UnAuthorizedException) {
          var apiError = json.decode(error.message!);
          if (apiError["message"] != null) {
            DialogHelper.showErrorSnackBar(
              title: "Error",
              description: apiError["message"],
            );
          }
        } else {
          handleError(error);
        }
      },
    );

    if (kDebugMode) {
      log("Rating API Response :-> $responseJson");
    }

    if (responseJson != null) {
      var message = jsonDecode(responseJson)["message"];

      if (message != null) {
        showMessage(description: message);
      }

      await Future.wait([
        getNearByBusinessService(
          country: selectedLocation.country.value,
          state: selectedLocation.state.value,
          city: selectedLocation.city.value,
        ),
        if (token.isNotEmpty && userId.isNotEmpty && userMobile.isNotEmpty) ...{
          getUserBusinessService(mobile: userMobile),
        },
      ]);
    }

    isLoading.value = false;
  }

  Future<void> getUserBusinessService({required String mobile}) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.userBusinessService;

    var body = {
      "mobile": mobile,
    };

    var headers = {
      "Authorization": "Bearer $token",
    };

    var responseJson =
        await BaseClient().post(baseUrl, endpoint, headers, body).catchError(
      (error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          if (apiError["message"] != null) {
            DialogHelper.showErrorSnackBar(
              title: "Error",
              description: apiError["message"],
            );
          }
        } else if (error is UnAuthorizedException) {
          var apiError = json.decode(error.message!);
          if (apiError["message"] != null) {
            DialogHelper.showErrorSnackBar(
              title: "Error",
              description: apiError["message"],
            );
          }
        } else {
          handleError(error);
        }
      },
    );

    if (kDebugMode) {
      log("User Business/Services API Response :-> $responseJson");
    }

    if (responseJson != null) {
      var message = jsonDecode(responseJson)["message"];

      if (message != null) {
        // showMessage(description: message);
      }

      userBusinessServiceModel.value =
          businessServiceModelFromJson(responseJson);
    }

    isLoading.value = false;
  }

  Future<void> addUserBusinessService({
    required String name,
    required String type,
    required String category,
    required String openTime,
    required String closeTime,
    required List<String> productsServices,
    required String address,
    required String city,
    required String state,
    required String country,
    required String mobile,
    required double lat,
    required double lon,
    required File businessImage,
    required bool callEnabled,
    required bool messageEnabled,
    required bool isActive,
  }) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.createBusinessService;

    var body = {
      "name": name,
      "type": type,
      "category": category,
      "openTime": openTime,
      "closeTime": closeTime,
      "productsServices[]": jsonEncode(productsServices),
      "address": address,
      "city": city,
      "state": state,
      "country": country,
      "mobile": mobile,
      "lat": lat.toString(),
      "lon": lon.toString(),
      "callEnabled": callEnabled.toString(),
      "messageEnabled": messageEnabled.toString(),
      "isActive": isActive.toString(),
      "deviceId": deviceId,
    };

    var files = {
      "business_image": businessImage,
    };

    var headers = {
      "Authorization": "Bearer $token",
    };

    var responseJson = await BaseClient()
        .postMultipart(baseUrl, endpoint, headers, body, files)
        .catchError((error) {
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        if (apiError["message"] != null) {
          DialogHelper.showErrorSnackBar(
            title: "Error",
            description: apiError["message"],
          );
        }
      } else if (error is UnAuthorizedException) {
        var apiError = json.decode(error.message!);
        if (apiError["message"] != null) {
          DialogHelper.showErrorSnackBar(
            title: "Error",
            description: apiError["message"],
          );
        }
      } else {
        handleError(error);
      }
    });

    if (kDebugMode) {
      log("Create User Business/Services API Response :-> $responseJson");
    }

    if (responseJson != null) {
      var message = jsonDecode(responseJson)["message"];

      if (message != null) {
        showMessage(description: message);
      }

      await getUserBusinessService(mobile: userMobile);
    }

    isLoading.value = false;
  }

  Future<void> updateUserBusinessService({
    required String businessServiceId,
    required String name,
    required String type,
    required String category,
    required String openTime,
    required String closeTime,
    required List<String> productsServices,
    required String address,
    required String city,
    required String state,
    required String country,
    required String mobile,
    required double lat,
    required double lon,
    required File? businessImage,
    required bool callEnabled,
    required bool messageEnabled,
    required bool isActive,
  }) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.updateBusinessService;

    var body = {
      "businessServiceId": businessServiceId,
      "name": name,
      "type": type,
      "category": category,
      "openTime": openTime,
      "closeTime": closeTime,
      "productsServices[]": jsonEncode(productsServices),
      "address": address,
      "city": city,
      "state": state,
      "country": country,
      "mobile": mobile,
      "lat": lat.toString(),
      "lon": lon.toString(),
      "callEnabled": callEnabled.toString(),
      "messageEnabled": messageEnabled.toString(),
      "isActive": isActive.toString(),
      "deviceId": deviceId,
    };

    var files = businessImage != null
        ? {
            "business_image": businessImage,
          }
        : null;

    var headers = {
      "Authorization": "Bearer $token",
    };

    var responseJson = await BaseClient()
        .putMultipart(baseUrl, endpoint, headers, body, files)
        .catchError((error) {
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        if (apiError["message"] != null) {
          DialogHelper.showErrorSnackBar(
            title: "Error",
            description: apiError["message"],
          );
        }
      } else if (error is UnAuthorizedException) {
        var apiError = json.decode(error.message!);
        if (apiError["message"] != null) {
          DialogHelper.showErrorSnackBar(
            title: "Error",
            description: apiError["message"],
          );
        }
      } else {
        handleError(error);
      }
    });

    if (kDebugMode) {
      log("Update User Business/Services API Response :-> $responseJson");
    }

    if (responseJson != null) {
      var message = jsonDecode(responseJson)["message"];

      if (message != null) {
        showMessage(description: message);
      }

      await getUserBusinessService(mobile: userMobile);
    }

    isLoading.value = false;
  }

  Future<void> deleteUserBusinessService({
    required String businessServiceId,
  }) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.deleteBusinessService + businessServiceId;

    var headers = {
      "Authorization": "Bearer $token",
    };

    var responseJson = await BaseClient()
        .delete(baseUrl, endpoint, headers, null)
        .catchError((error) {
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        if (apiError["message"] != null) {
          DialogHelper.showErrorSnackBar(
            title: "Error",
            description: apiError["message"],
          );
        }
      } else if (error is UnAuthorizedException) {
        var apiError = json.decode(error.message!);
        if (apiError["message"] != null) {
          DialogHelper.showErrorSnackBar(
            title: "Error",
            description: apiError["message"],
          );
        }
      } else {
        handleError(error);
      }
    });

    if (kDebugMode) {
      log("Delete User Business/Services API Response :-> $responseJson");
    }

    if (responseJson != null) {
      var message = jsonDecode(responseJson)["message"];

      if (message != null) {
        showMessage(description: message);
      }

      await getUserBusinessService(mobile: userMobile);
    }

    isLoading.value = false;
  }

  Future<bool> userRegister(String fullName, String mobile) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.userRegister;

    var body = {
      "fullname": fullName,
      "mobile": mobile,
    };

    var responseJson =
        await BaseClient().post(baseUrl, endpoint, null, body).catchError(
      (error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          if (apiError["message"] != null) {
            DialogHelper.showErrorSnackBar(
              title: "Error",
              description: apiError["message"],
            );
          }
        } else {
          handleError(error);
        }
      },
    );

    if (kDebugMode) {
      log("User Register API Response :-> $responseJson");
    }

    if (responseJson.toString() == 'null') {
      isLoading.value = false;

      return false;
    } else {
      isLoading.value = false;

      var message = jsonDecode(responseJson)["message"];

      if (message.toString() != 'null') {
        showMessage(description: message.toString());
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> sendOTP(String mobile) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.sendOTP;

    var body = {
      "mobile": mobile,
    };

    var responseJson =
        await BaseClient().post(baseUrl, endpoint, null, body).catchError(
      (error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);

          if (apiError["message"] != null) {
            DialogHelper.showErrorSnackBar(
              title: "Error",
              description: apiError["message"],
            );
          }
        } else {
          handleError(error);
        }
      },
    );

    if (kDebugMode) {
      log("Send OTP API Response :-> $responseJson");
    }

    if (responseJson == null) {
      isLoading.value = false;

      return false;
    } else {
      var message = jsonDecode(responseJson)["message"];
      var otp = jsonDecode(responseJson)["otp"].toString();

      if (message != null) {
        if (otp != 'null') {
          showMessage(description: message + "\nOTP : $otp");
        } else {
          showMessage(description: message);
        }
      }

      isLoading.value = false;

      if (otp != 'null') {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> verifyOTP(String mobile, String otp) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.verifyTheOTP;

    var body = {
      "mobile": mobile,
      "otp": otp,
    };

    var responseJson =
        await BaseClient().post(baseUrl, endpoint, null, body).catchError(
      (error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);

          if (apiError["message"] != null) {
            DialogHelper.showErrorSnackBar(
              title: "Error",
              description: apiError["message"],
            );
          }
        } else {
          handleError(error);
        }
      },
    );

    if (kDebugMode) {
      log("Verify OTP API Response :-> $responseJson");
    }

    if (responseJson == null) {
      isLoading.value = false;

      return false;
    } else {
      var message = jsonDecode(responseJson)["message"];
      var isVerified = jsonDecode(responseJson)["isVerified"].toString();

      if (message != null) {
        showMessage(description: message);
      }

      isLoading.value = false;

      if (isVerified != 'null' && isVerified == 'true') {
        return true;
      } else {
        return false;
      }
    }
  }
}
