import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../global/global.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void connectSocket() {
  socket = IO.io(apiBaseUrl, <String, dynamic>{
    'autoConnect': false,
    'transports': ['websocket'],
  });
  socket.connect();
  socket.onConnect((_) {
    debugPrint("Socket connection established.");
  });
  socket.onDisconnect(
    (_) => debugPrint("Socket connection disconnected."),
  );
  socket
      .onConnectError((err) => debugPrint("Socket Connection Error :-> $err"));
  socket.onError((err) => debugPrint("Socket Error :-> $err"));

  socketListeners();
}

void socketListeners() {
  socket.on('user', (data) {
    debugPrint(data.toString());
    if (data["action"].toString() == "profileUpdate") {
      if (data["userId"].toString() == userId) {
        // Get.put(UserController()).getUserDetails();
        // Get.put(UserController()).getUsers();
      }
    }
  });

  socket.on('chat', (data) {
    debugPrint(data.toString());
    if (data["action"].toString() == "messageSent") {
      if (data["sender"].toString() == userId ||
          data["receiver"].toString() == userId) {
        // Get.put(UserController()).getUserDetails();
      }
    }
  });
}
