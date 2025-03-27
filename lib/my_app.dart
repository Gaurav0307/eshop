import 'package:device_preview/device_preview.dart';
import 'package:eshop/common/constants/asset_constants.dart';
import 'package:eshop/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common/constants/color_constants.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide keyboard when tapping outside of text fields.
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: GetMaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        title: 'eShop',
        theme: ThemeData(
          fontFamily: AssetConstants.poppinsFont,
          appBarTheme: AppBarTheme(
            backgroundColor: ColorConstants.pastelBlueBG,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: ColorConstants.indigo,
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
