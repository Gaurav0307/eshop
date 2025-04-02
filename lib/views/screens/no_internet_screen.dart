import 'package:flutter/material.dart';

import '../../common/constants/asset_constants.dart';
import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, //It should be false to work
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        await _onBackPressed();
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                height: 180,
                width: 180,
                decoration: const BoxDecoration(),
                child: Image.asset(AssetConstants.noInternet),
              ),
              const Text(
                StringConstants.noInternet,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5.0),
              SizedBox(
                width: 250.0,
                child: Text(
                  StringConstants.thereIsNoInternetConnectivity,
                  style: TextStyle(
                    color: ColorConstants.black,
                    fontFamily: AssetConstants.robotoFont,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onBackPressed() {}
}
