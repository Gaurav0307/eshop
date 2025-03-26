import 'dart:convert';
import 'dart:developer';

import 'package:eshop/controllers/base_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../common/constants/api_constants.dart';
import '../common/constants/storage_constants.dart';
import '../common/global/global.dart';
import '../common/helper/dialog_helper.dart';
import '../common/services/app_exceptions.dart';
import '../common/services/base_client.dart';
import '../common/utils/utility_methods.dart';

class AuthController extends GetxController with BaseController {
  var isLoading = false.obs;

  Future<bool> register(String fullName, String mobile) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.register;

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
      log("Register API Response :-> $responseJson");
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

  Future<bool> sendRegisterOTP(String mobile) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.sendRegisterOTP;

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
      log("Register OTP API Response :-> $responseJson");
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
    var endpoint = ApiConstants.verifyOTP;

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

  Future<bool> login(String mobile) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.login;

    var body = {
      "mobile": mobile,
      "deviceId": deviceId,
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
      log("Login API Response :-> $responseJson");
    }

    if (responseJson == null) {
      isLoading.value = false;

      return false;
    } else {
      var message = jsonDecode(responseJson)["message"];

      if (message != null) {
        showMessage(description: message);
      }

      token = jsonDecode(responseJson)["token"].toString();
      userId = jsonDecode(responseJson)["userId"].toString();
      userMobile = jsonDecode(responseJson)["mobile"].toString();

      if (token != 'null') {
        sharedPreferences?.setString(StorageConstants.token, token);
        sharedPreferences?.setString(StorageConstants.userId, userId);
        sharedPreferences?.setString(StorageConstants.userMobile, userMobile);

        await UtilityMethods.loadInitialData();

        isLoading.value = false;

        return true;
      } else {
        isLoading.value = false;

        return false;
      }
    }
  }

  Future<bool> sendLoginOTP(String mobile) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.sendLoginOTP;

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
      log("Login OTP API Response :-> $responseJson");
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
}
