import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/common/constants/asset_constants.dart';
import 'package:flutter/material.dart';

import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';

class ServiceBusinessItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String category;
  final String timing;
  final String servicesAndProducts;
  final String address;
  final String city;
  final String state;
  final String rating;
  final String peopleRated;
  final void Function() onLocationPressed;
  final void Function() onCallPressed;
  final void Function() onMessagePressed;
  final void Function() onTap;

  const ServiceBusinessItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.category,
    required this.timing,
    required this.servicesAndProducts,
    required this.address,
    required this.city,
    required this.state,
    required this.rating,
    required this.peopleRated,
    required this.onLocationPressed,
    required this.onCallPressed,
    required this.onMessagePressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        height: 260,
        margin: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 2.0,
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 200.0,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        child: CachedNetworkImage(
                          width: 160.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                          imageUrl: imageUrl,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstants.black,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Center(
                                child: Text(
                                  "($category)",
                                  style: const TextStyle(
                                    fontFamily: AssetConstants.robotoFont,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Divider(),
                              Expanded(
                                child: ListView(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.access_time_rounded,
                                          size: 14.0,
                                        ),
                                        Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  20) *
                                              0.39,
                                          margin:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            timing,
                                            style: const TextStyle(
                                              fontFamily:
                                                  AssetConstants.robotoFont,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          size: 14.0,
                                        ),
                                        Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  20) *
                                              0.39,
                                          margin:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            servicesAndProducts,
                                            style: const TextStyle(
                                              fontFamily:
                                                  AssetConstants.robotoFont,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 14.0,
                                        ),
                                        Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  20) *
                                              0.39,
                                          margin:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            "$address\n$city ($state)",
                                            style: const TextStyle(
                                              fontFamily:
                                                  AssetConstants.robotoFont,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.star_border,
                                          size: 14.0,
                                        ),
                                        Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  20) *
                                              0.39,
                                          margin:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            "$rating ($peopleRated)",
                                            style: const TextStyle(
                                              fontFamily:
                                                  AssetConstants.robotoFont,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: ColorConstants.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 2.0,
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: onLocationPressed,
                        icon: SizedBox(
                          width: 80.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(height: 5.0),
                              Text(
                                StringConstants.location,
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.black,
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onCallPressed,
                        icon: SizedBox(
                          width: 80.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.phone),
                              const SizedBox(height: 5.0),
                              Text(
                                StringConstants.call,
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.black,
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onMessagePressed,
                        icon: SizedBox(
                          width: 80.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.chat),
                              const SizedBox(height: 5.0),
                              Text(
                                StringConstants.message,
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.black,
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6.0),
                  bottomRight: Radius.circular(20.0),
                ),
                child: CachedNetworkImage(
                  width: (MediaQuery.of(context).size.width - 20) * 0.4,
                  height: 200.0,
                  fit: BoxFit.cover,
                  imageUrl: imageUrl,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
