import 'dart:convert';
import 'dart:developer';

import 'package:eshop/controllers/base_controller.dart';
import 'package:eshop/models/CategoryModel.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../common/constants/api_constants.dart';
import '../common/helper/dialog_helper.dart';
import '../common/services/app_exceptions.dart';
import '../common/services/base_client.dart';

class CategoryController extends GetxController with BaseController {
  var isLoading = false.obs;
  var categoryModel = CategoryModel().obs;

  Future<void> getCategory() async {
    isLoading.value = true;

    var baseUrl = ApiConstants.baseUrl;
    var endpoint = ApiConstants.allCategories;

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
      log("Category API Response :-> $responseJson");
    }

    if (responseJson != null) {
      var message = jsonDecode(responseJson)["message"];

      if (message != null) {
        // showMessage(description: message);
      }

      categoryModel.value = categoryModelFromJson(responseJson);
    }
    isLoading.value = false;
  }
}
