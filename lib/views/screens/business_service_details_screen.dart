import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/common/constants/asset_constants.dart';
import 'package:eshop/models/BusinessServiceModel.dart';
import 'package:eshop/views/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import '../../common/global/global.dart';
import '../../common/utils/utility_methods.dart';
import '../../controllers/business_service_controller.dart';
import '../widgets/border_button.dart';
import 'map_screen.dart';

class BusinessServiceDetailsScreen extends StatefulWidget {
  final Object heroTag;
  final BusinessesServices data;
  final bool isUserBusinessService;
  const BusinessServiceDetailsScreen({
    super.key,
    required this.heroTag,
    required this.data,
    this.isUserBusinessService = false,
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
  var data = BusinessesServices().obs;

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

    data.value = widget.data;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  var businessServiceController = Get.put(BusinessServiceController());

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
                        data.value.name!,
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
                        imageUrl:
                            UtilityMethods.getProperFileUrl(data.value.image!),
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
                              data.value.name!,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: ColorConstants.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "(${data.value.category})",
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
                            "${data.value.openTime} - ${data.value.closeTime}",
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
                            data.value.productsServices!.join(", "),
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
                            "${data.value.address}, ${data.value.city} (${data.value.state})",
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
                                      endLatitude:
                                          data.value.location!.lat!.toDouble(),
                                      endLongitude:
                                          data.value.location!.lon!.toDouble(),
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
                                    data.value.location!.lat!.toDouble(),
                                    data.value.location!.lon!.toDouble(),
                                  ),
                                  zoom: 14,
                                ),
                                markers: {
                                  Marker(
                                    markerId: MarkerId(
                                      "${data.value.location!.lat!.toDouble()}, ${data.value.location!.lon!.toDouble()}",
                                    ),
                                    position: LatLng(
                                      data.value.location!.lat!.toDouble(),
                                      data.value.location!.lon!.toDouble(),
                                    ),
                                    infoWindow:
                                        InfoWindow(title: data.value.name),
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
                        Obx(
                          () => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "${data.value.rating!.toDouble().toPrecision(1)}/5.0 (${UtilityMethods.formatNumberToKMB(data.value.ratedBy!.toDouble())})",
                              style: const TextStyle(
                                fontFamily: AssetConstants.robotoFont,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
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
                    lat: data.value.location!.lat!.toDouble(),
                    lon: data.value.location!.lon!.toDouble(),
                    title: data.value.name!,
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
            data.value.name!,
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
              Obx(
                () => Visibility(
                  visible: !businessServiceController.isLoading.value,
                  replacement: Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.indigo,
                      strokeWidth: 3.0,
                    ),
                  ),
                  child: Padding(
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
                      onPressed: () async {
                        await submitRating(data.value.id!, rating);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> submitRating(String businessServiceId, double rating) async {
    log("Submitted Rating: $rating");
    await businessServiceController.rateBusinessService(
        businessServiceId: businessServiceId, rating: rating);
    data.value = widget.isUserBusinessService
        ? businessServiceController
            .getUserBusinessServiceById(businessServiceId)!
        : businessServiceController.getBusinessServiceById(businessServiceId)!;
  }
}
