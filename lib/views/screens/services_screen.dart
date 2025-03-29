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

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  TextEditingController searchTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          StringConstants.services,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          ///Search
          SearchTextField(
            hintText: StringConstants.searchService,
            textEditingController: searchTEC,
            onChange: (_) {
              setState(() {});
            },
          ),

          ///Services
          Expanded(
            child: businessServiceController.services
                    .where((item) => item.name!
                        .toString()
                        .toLowerCase()
                        .contains(searchTEC.text.toLowerCase()))
                    .isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    itemCount: businessServiceController.services.length,
                    itemBuilder: (context, index) {
                      return businessServiceController.services[index].name!
                              .toString()
                              .toLowerCase()
                              .contains(searchTEC.text.toLowerCase())
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: ServiceBusinessItem(
                                heroTag: "Service-$index",
                                imageUrl: UtilityMethods.getProperFileUrl(
                                    businessServiceController
                                        .services[index].image!),
                                name: businessServiceController
                                    .services[index].name!,
                                category: businessServiceController
                                    .services[index].category!,
                                timing:
                                    "${businessServiceController.services[index].openTime!} - "
                                    "${businessServiceController.services[index].closeTime!}",
                                servicesAndProducts: businessServiceController
                                    .services[index].productsServices!
                                    .join(", "),
                                address: businessServiceController
                                    .services[index].address!,
                                city: businessServiceController
                                    .services[index].city!,
                                state: businessServiceController
                                    .services[index].state!,
                                rating: businessServiceController
                                    .services[index].rating!
                                    .toDouble()
                                    .toPrecision(1)
                                    .toString(),
                                maxRating: "5.0",
                                peopleRated: UtilityMethods.formatNumberToKMB(
                                  businessServiceController
                                      .services[index].ratedBy!
                                      .toDouble(),
                                ),
                                distance:
                                    "${(locationService.getDistanceBetween(
                                          startLatitude:
                                              locationService.latitude.value,
                                          startLongitude:
                                              locationService.longitude.value,
                                          endLatitude: businessServiceController
                                              .services[index].location!.lat!
                                              .toDouble(),
                                          endLongitude:
                                              businessServiceController
                                                  .services[index]
                                                  .location!
                                                  .lon!
                                                  .toDouble(),
                                        ) / 1000.0).toPrecision(1)} KM",
                                onLocationPressed: () {
                                  Get.to(
                                    () => MapScreen(
                                      lat: businessServiceController
                                          .services[index].location!.lat!
                                          .toDouble(),
                                      lon: businessServiceController
                                          .services[index].location!.lon!
                                          .toDouble(),
                                      title: businessServiceController
                                          .services[index].name!,
                                    ),
                                  );
                                },
                                onCallPressed: () {},
                                onMessagePressed: () {},
                                onTap: () {
                                  Get.to(
                                    () => BusinessServiceDetailsScreen(
                                      heroTag: "Service-$index",
                                      data: businessServiceController
                                          .services[index],
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
