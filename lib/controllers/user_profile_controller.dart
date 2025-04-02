import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eshop/models/UserProfileModel.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../common/constants/api_constants.dart';
import '../common/constants/storage_constants.dart';
import '../common/global/global.dart';
import '../common/helper/dialog_helper.dart';
import '../common/services/app_exceptions.dart';
import '../common/services/base_client.dart';
import 'base_controller.dart';

class UserProfileController extends GetxController with BaseController {
  var isLoading = false.obs;
  var userProfileModel = UserProfileModel().obs;

  Future<void> getUserProfile() async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.userProfile;

    var header = {
      "Authorization": "Bearer $token",
    };

    var responseJson =
        await BaseClient().get(baseUrl, endpoint, header).catchError(
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
      log("User Profile API Response :-> $responseJson");
    }

    isLoading.value = false;

    if (responseJson == null || responseJson.toString().contains("jwt")) {
      if (sharedPreferences!.containsKey(StorageConstants.token)) {
        await sharedPreferences!.clear();

        token = "";
        userId = "";
        userMobile = "";
      }
    } else {
      var message = jsonDecode(responseJson)["message"];

      if (message != null) {
        // showMessage(description: message);
      }

      userProfileModel.value = userProfileModelFromJson(responseJson);
    }
  }

  Future<void> updateProfile(
    String fullName,
    File? profileImage,
  ) async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;

    var endpoint = ApiConstants.updateUserProfile;

    var body = {
      "fullname": fullName,
    };

    var headers = {
      "Authorization": "Bearer $token",
    };

    var files = profileImage != null
        ? {
            "profile_picture": profileImage,
          }
        : null;

    var responseJson = await BaseClient()
        .putMultipart(baseUrl, endpoint, headers, body, files)
        .catchError(
      (error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          if (apiError["errors"]["email"] != null) {
            DialogHelper.showErrorSnackBar(
                title: apiError["message"],
                description: apiError["errors"]["email"][0]);
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
      log("Update User Profile API Response :-> $responseJson");
    }

    isLoading.value = false;

    if (responseJson == null || responseJson.toString().contains("jwt")) {
      if (sharedPreferences!.containsKey(StorageConstants.token)) {
        await sharedPreferences!.clear();
        token = "";
        userId = "";
        userMobile = "";
      }
    } else {
      var message = jsonDecode(responseJson)["message"];

      if (message != null) {
        showMessage(description: message);
      }

      await getUserProfile();
    }
  }
}
