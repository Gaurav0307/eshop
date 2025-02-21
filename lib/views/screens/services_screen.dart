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
            child: demoServices
                    .where((item) => item['name']!
                        .toString()
                        .toLowerCase()
                        .contains(searchTEC.text.toLowerCase()))
                    .isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return demoServices[index % 2]['name']!
                              .toString()
                              .toLowerCase()
                              .contains(searchTEC.text.toLowerCase())
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: ServiceBusinessItem(
                                heroTag: index,
                                imageUrl: demoServices[index % 2]['imageUrl']
                                    .toString(),
                                name:
                                    demoServices[index % 2]['name'].toString(),
                                category: demoServices[index % 2]['category']
                                    .toString(),
                                timing: demoServices[index % 2]['timing']
                                    .toString(),
                                servicesAndProducts: demoServices[index % 2]
                                        ['servicesAndProducts']
                                    .toString(),
                                address: demoServices[index % 2]['address']
                                    .toString(),
                                city:
                                    demoServices[index % 2]['city'].toString(),
                                state:
                                    demoServices[index % 2]['state'].toString(),
                                rating: demoServices[index % 2]['rating']
                                    .toString(),
                                maxRating: "5.0",
                                peopleRated: UtilityMethods.formatNumberToKMB(
                                    double.tryParse(demoServices[index % 2]
                                                ['peopleRated']
                                            .toString()) ??
                                        0.0),
                                distance:
                                    "${(locationService.getDistanceBetween(
                                          startLatitude:
                                              locationService.lat.value,
                                          startLongitude:
                                              locationService.lon.value,
                                          endLatitude: demoServices[index % 2]
                                              ['location']['lat'],
                                          endLongitude: demoServices[index % 2]
                                              ['location']['lon'],
                                        ) / 1000.0).toPrecision(1)} KM",
                                onLocationPressed: () {
                                  Get.to(
                                    () => MapScreen(
                                      lat: demoServices[index % 2]['location']
                                          ['lat'],
                                      lon: demoServices[index % 2]['location']
                                          ['lon'],
                                      title: demoServices[index % 2]['name']
                                          .toString(),
                                    ),
                                  );
                                },
                                onCallPressed: () {},
                                onMessagePressed: () {},
                                onTap: () {
                                  Get.to(
                                    () => BusinessServiceDetailsScreen(
                                      heroTag: index,
                                      data: demoServices[index % 2],
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
