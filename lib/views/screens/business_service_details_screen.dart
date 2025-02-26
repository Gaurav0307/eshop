import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/common/constants/asset_constants.dart';
import 'package:eshop/views/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import '../../common/global/global.dart';
import '../../common/utils/utility_methods.dart';
import '../widgets/border_button.dart';
import 'map_screen.dart';

class BusinessServiceDetailsScreen extends StatefulWidget {
  final Object heroTag;
  final Map<String, dynamic> data;
  const BusinessServiceDetailsScreen({
    super.key,
    required this.heroTag,
    required this.data,
  });

  @override
  State<BusinessServiceDetailsScreen> createState() =>
      _BusinessServiceDetailsScreenState();
}

class _BusinessServiceDetailsScreenState
    extends State<BusinessServiceDetailsScreen> {
  late ScrollController _scrollController;
  bool isCollapsed = false;
  late BitmapDescriptor customMarkerIcon;

  // Load Custom Marker from Assets
  Future<void> _loadCustomMarker() async {
    customMarkerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)), // Adjust size if needed
      AssetConstants.mapPointer1,
    );
    setState(() {}); // Refresh UI after loading
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 55 && !isCollapsed) {
        setState(() {
          isCollapsed = true;
        });
      } else if (_scrollController.offset <= 55 && isCollapsed) {
        setState(() {
          isCollapsed = false;
        });
      }
    });

    _loadCustomMarker();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height / 2.0,
              floating: false,
              snap: false,
              pinned: true,
              iconTheme: IconThemeData(
                shadows: [
                  Shadow(
                    color: ColorConstants.white,
                    blurRadius: 60.0,
                  ),
                ],
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: isCollapsed
                    ? Text(
                        widget.data['name'],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.white,
                          shadows: const [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 15.0,
                            )
                          ],
                        ),
                        textAlign: TextAlign.center,
                      )
                    : const SizedBox.shrink(),
                background: Stack(
                  children: [
                    Hero(
                      tag: widget.heroTag,
                      child: CachedNetworkImage(
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: widget.data['imageUrl'],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 8.0,
                        ),
                        color: Colors.black26,
                        child: Column(
                          children: [
                            Text(
                              widget.data['name'],
                              style: TextStyle(
                                fontSize: 18.0,
                                color: ColorConstants.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "(${widget.data['category']})",
                              style: TextStyle(
                                fontFamily: AssetConstants.robotoFont,
                                fontSize: 14.0,
                                color: ColorConstants.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 24.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            widget.data['timing'],
                            style: const TextStyle(
                              fontFamily: AssetConstants.robotoFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.add,
                          size: 24.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            widget.data['servicesAndProducts'],
                            style: const TextStyle(
                              fontFamily: AssetConstants.robotoFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 24.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "${widget.data['address']}, ${widget.data['city']} (${widget.data['state']})",
                            style: const TextStyle(
                              fontFamily: AssetConstants.robotoFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.directions_run,
                          size: 24.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Obx(
                            () {
                              return Text(
                                "${(locationService.getDistanceBetween(
                                      startLatitude:
                                          locationService.latitude.value,
                                      startLongitude:
                                          locationService.longitude.value,
                                      endLatitude: widget.data['location']
                                          ['lat'],
                                      endLongitude: widget.data['location']
                                          ['lon'],
                                    ) / 1000.0).toPrecision(1)} KM (${StringConstants.fromYourCurrentLocation})",
                                style: const TextStyle(
                                  fontFamily: AssetConstants.robotoFont,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.start,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 0.0),
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.30,
                          margin: const EdgeInsets.only(top: 34.0),
                          decoration: BoxDecoration(
                            // border: Border.all(color: ColorConstants.black54),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Card(
                            elevation: 5.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: GoogleMap(
                                mapToolbarEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    widget.data['location']['lat'],
                                    widget.data['location']['lon'],
                                  ),
                                  zoom: 16,
                                ),
                                markers: {
                                  Marker(
                                    markerId: MarkerId(
                                      "${widget.data['location']['lat']}, ${widget.data['location']['lon']}",
                                    ),
                                    position: LatLng(
                                      widget.data['location']['lat'],
                                      widget.data['location']['lon'],
                                    ),
                                    infoWindow:
                                        InfoWindow(title: widget.data['name']),
                                    icon: customMarkerIcon,
                                  ),
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 25,
                          child: Center(
                            child: Container(
                              width: 80,
                              height: 25,
                              decoration: BoxDecoration(
                                color: ColorConstants.white,
                                border:
                                    Border.all(color: ColorConstants.black54),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: const Center(
                                child: Text(
                                  StringConstants.location,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.star_border,
                          size: 24.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "${widget.data['rating']}/5.0 (${UtilityMethods.formatNumberToKMB(double.tryParse(widget.data['peopleRated'].toString()) ?? 0.0)})",
                            style: const TextStyle(
                              fontFamily: AssetConstants.robotoFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        BorderButton(
                          width: 62,
                          padding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 0.0,
                          ),
                          onPressed: () {
                            showRatingDialog(context);
                          },
                          child: Text(
                            StringConstants.rateIt,
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorConstants.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
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
              onPressed: () {
                Get.to(
                  () => MapScreen(
                    lat: widget.data['location']['lat'],
                    lon: widget.data['location']['lon'],
                    title: widget.data['name'].toString(),
                  ),
                );
              },
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
              onPressed: () {},
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
              onPressed: () {},
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
      ),
    );
  }

  void showRatingDialog(BuildContext context) {
    double rating = 0; // Default rating

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismissal
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          icon: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          iconPadding: const EdgeInsets.all(5.0),
          title: Text(
            widget.data['name'],
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: ColorConstants.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                StringConstants.howWasYourExperience,
                style: TextStyle(
                  fontFamily: AssetConstants.robotoFont,
                  fontSize: 14,
                  color: ColorConstants.black,
                ),
              ),
              const SizedBox(height: 10),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  rating = newRating; // Update rating
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: GradientButton(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    StringConstants.submit,
                    style: TextStyle(
                      fontFamily: AssetConstants.robotoFont,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  static void _submitRating(double rating) {
    // Handle rating submission (e.g., send to API)
    print("Submitted Rating: $rating");
  }
}
