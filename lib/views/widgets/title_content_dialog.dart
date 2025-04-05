import 'package:flutter/material.dart';

import '../../common/constants/asset_constants.dart';
import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import 'gradient_button.dart';

Future<void> showTitleContentDialog(
    BuildContext context, String title, String content) async {
  await showDialog(
    context: context,
    barrierDismissible: false, // Prevent accidental dismissal
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: ColorConstants.red,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              content,
              style: TextStyle(
                fontFamily: AssetConstants.robotoFont,
                fontSize: 16,
                color: ColorConstants.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 75.0),
              child: GradientButton(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  StringConstants.okay,
                  style: TextStyle(
                    fontFamily: AssetConstants.robotoFont,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: ColorConstants.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
