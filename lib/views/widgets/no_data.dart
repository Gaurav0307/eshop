import 'package:eshop/common/constants/asset_constants.dart';
import 'package:flutter/material.dart';

import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            StringConstants.noDataAvailable,
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
              StringConstants.thereIsNoDataToBeShown,
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
    );
  }
}
