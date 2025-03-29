import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/constants/string_constants.dart';
import '../../common/global/global.dart';
import '../../common/utils/utility_methods.dart';
import '../widgets/SearchTextField.dart';
import '../widgets/no_data.dart';
import '../widgets/service_business_item.dart';
import 'business_service_details_screen.dart';
import 'map_screen.dart';

class BusinessesScreen extends StatefulWidget {
  const BusinessesScreen({super.key});

  @override
  State<BusinessesScreen> createState() => _BusinessesScreenState();
}

class _BusinessesScreenState extends State<BusinessesScreen> {
  TextEditingController searchTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          StringConstants.businesses,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          ///Search
          SearchTextField(
            hintText: StringConstants.searchBusiness,
            textEditingController: searchTEC,
            onChange: (_) {
              setState(() {});
            },
          ),

          ///Businesses
          Expanded(
            child: businessServiceController.businesses
                    .where((item) => item.name!
                        .toString()
                        .toLowerCase()
                        .contains(searchTEC.text.toLowerCase()))
                    .isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    itemCount: businessServiceController.businesses.length,
                    itemBuilder: (context, index) {
                      return businessServiceController.businesses[index].name!
                              .toString()
                              .toLowerCase()
                              .contains(searchTEC.text.toLowerCase())
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: ServiceBusinessItem(
                                heroTag: "Business-$index",
                                imageUrl: UtilityMethods.getProperFileUrl(
                                    businessServiceController
                                        .businesses[index].image!),
                                name: businessServiceController
                                    .businesses[index].name!,
                                category: businessServiceController
                                    .businesses[index].category!,
                                timing:
                                    "${businessServiceController.businesses[index].openTime!} - "
                                    "${businessServiceController.businesses[index].closeTime!}",
                                servicesAndProducts: businessServiceController
                                    .businesses[index].productsServices!
                                    .join(", "),
                                address: businessServiceController
                                    .businesses[index].address!,
                                city: businessServiceController
                                    .businesses[index].city!,
                                state: businessServiceController
                                    .businesses[index].state!,
                                rating: businessServiceController
                                    .businesses[index].rating!
                                    .toDouble()
                                    .toPrecision(1)
                                    .toString(),
                                maxRating: "5.0",
                                peopleRated: UtilityMethods.formatNumberToKMB(
                                  businessServiceController
                                      .businesses[index].ratedBy!
                                      .toDouble(),
                                ),
                                distance:
                                    "${(locationService.getDistanceBetween(
                                          startLatitude:
                                              locationService.latitude.value,
                                          startLongitude:
                                              locationService.longitude.value,
                                          endLatitude: businessServiceController
                                              .businesses[index].location!.lat!
                                              .toDouble(),
                                          endLongitude:
                                              businessServiceController
                                                  .businesses[index]
                                                  .location!
                                                  .lon!
                                                  .toDouble(),
                                        ) / 1000.0).toPrecision(1)} KM",
                                onLocationPressed: () {
                                  Get.to(
                                    () => MapScreen(
                                      lat: businessServiceController
                                          .businesses[index].location!.lat!
                                          .toDouble(),
                                      lon: businessServiceController
                                          .businesses[index].location!.lon!
                                          .toDouble(),
                                      title: businessServiceController
                                          .businesses[index].name!,
                                    ),
                                  );
                                },
                                onCallPressed: () {},
                                onMessagePressed: () {},
                                onTap: () {
                                  Get.to(
                                    () => BusinessServiceDetailsScreen(
                                      heroTag: "Business-$index",
                                      data: businessServiceController
                                          .businesses[index],
                                    ),
                                  );
                                },
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  )
                : const NoData(),
          ),
        ],
      ),
    );
  }
}
