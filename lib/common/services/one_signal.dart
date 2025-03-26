import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../global/global.dart';

class MyOneSignal {
  static void init() {
    //Remove this method to stop OneSignal Debugging
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(oneSignalAppId);

    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt.
    // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
  }

  static void initPlatform() {
    OneSignal.User.getOnesignalId().then(
      (oneSignalId) {
        if (deviceId.isEmpty) {
          deviceId = oneSignalId ?? "";
          if (kDebugMode) {
            log("One Signal ID :-> $oneSignalId");
          }
        }
      },
    );

    OneSignal.User.addObserver((state) {
      var userState = state.jsonRepresentation();
      if (deviceId.isEmpty) {
        deviceId = state.current.onesignalId ?? "";
        if (kDebugMode) {
          log("One Signal ID :-> ${state.current.onesignalId}");
        }
      }
      log('OneSignal user changed: $userState');
    });

    OneSignal.Notifications.addPermissionObserver((state) {
      log("Has permission $state");
    });

    OneSignal.Notifications.addClickListener((event) {
      if (kDebugMode) {
        print('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
      }
      log("Clicked notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}");

      log("additionalData :-> \n${event.notification.additionalData}");

      if (event.notification.additionalData!['type'].toString() == "chat") {
        sharedPreferences?.setString("notificationType",
            event.notification.additionalData!['type'].toString());
        sharedPreferences?.setString(
            "id", event.notification.additionalData!['data']['id'].toString());
        sharedPreferences?.setString("name",
            event.notification.additionalData!['data']['name'].toString());
        sharedPreferences?.setString("email",
            event.notification.additionalData!['data']['email'].toString());
        sharedPreferences?.setString("imageUrl",
            event.notification.additionalData!['data']['imageUrl'].toString());
      }
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      if (kDebugMode) {
        print(
            'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');
      }

      /// Display Notification, preventDefault to not display
      event.preventDefault();

      /// Do async work

      /// notification.display() to display after preventing default
      event.notification.display();

      log("Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
    });
  }

  static Future<void> navigateTo() async {
    await Future.delayed(const Duration(seconds: 2));
    if (sharedPreferences!.getString("notificationType") != null) {
      if (sharedPreferences!.getString("notificationType") == "chat") {
        if (sharedPreferences!.getString("id") != null) {
          // Get.to(
          //   () => ChatScreen(
          //     name: sharedPreferences!.getString("name")!,
          //     email: sharedPreferences!.getString("email")!,
          //     imageUrl: sharedPreferences!.getString("imageUrl")!,
          //     receiverId: sharedPreferences!.getString("id")!,
          //   ),
          // )?.then((_) {
          //   sharedPreferences!.remove("name");
          //   sharedPreferences!.remove("email");
          //   sharedPreferences!.remove("imageUrl");
          //   sharedPreferences!.remove("id");
          //   sharedPreferences!.remove("notificationType");
          // });
        }
      }
    }
  }
}
