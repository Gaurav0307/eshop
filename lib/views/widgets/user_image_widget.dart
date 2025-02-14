import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../common/constants/color_constants.dart';
import '../../common/utils/utility_methods.dart';

class UserImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final double size;

  const UserImageWidget({
    super.key,
    this.imageUrl,
    this.title,
    this.size = 70.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? "",
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, __) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: UtilityMethods.getRandomColors(),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                UtilityMethods.getNameInitials(name: title ?? ""),
                style: TextStyle(
                  color: ColorConstants.white,
                  fontSize: size / 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
        errorWidget: (_, __, ___) {
          debugPrint("Image is not loading - $imageUrl");

          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: UtilityMethods.getRandomColors(),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                UtilityMethods.getNameInitials(name: title ?? ""),
                style: TextStyle(
                  color: ColorConstants.white,
                  fontSize: size / 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
