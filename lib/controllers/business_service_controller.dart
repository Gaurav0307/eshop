import 'dart:convert';
import 'dart:developer';

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

  Future<void> getNearByBusinessService(
      {required String country,
      required String state,
      required String city}) async {
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

  Future<void> rateBusinessService(
      {required String businessServiceId, required double rating}) async {
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

      await getNearByBusinessService(
        country: selectedLocation.country.value,
        state: selectedLocation.state.value,
        city: selectedLocation.city.value,
      );
    }

    isLoading.value = false;
  }
}
