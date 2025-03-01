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
            child: demoBusinesses
                    .where((item) => item['name']!
                        .toString()
                        .toLowerCase()
                        .contains(searchTEC.text.toLowerCase()))
                    .isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return demoBusinesses[index % 2]['name']!
                              .toString()
                              .toLowerCase()
                              .contains(searchTEC.text.toLowerCase())
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: ServiceBusinessItem(
                                heroTag: index,
                                imageUrl: demoBusinesses[index % 2]['imageUrl']
                                    .toString(),
                                name: demoBusinesses[index % 2]['name']
                                    .toString(),
                                category: demoBusinesses[index % 2]['category']
                                    .toString(),
                                timing: demoBusinesses[index % 2]['timing']
                                    .toString(),
                                servicesAndProducts: demoBusinesses[index % 2]
                                        ['servicesAndProducts']
                                    .toString(),
                                address: demoBusinesses[index % 2]['address']
                                    .toString(),
                                city: demoBusinesses[index % 2]['city']
                                    .toString(),
                                state: demoBusinesses[index % 2]['state']
                                    .toString(),
                                rating: demoBusinesses[index % 2]['rating']
                                    .toString(),
                                maxRating: "5.0",
                                peopleRated: UtilityMethods.formatNumberToKMB(
                                    double.tryParse(demoBusinesses[index % 2]
                                                ['peopleRated']
                                            .toString()) ??
                                        0.0),
                                distance:
                                    "${(locationService.getDistanceBetween(
                                          startLatitude:
                                              locationService.latitude.value,
                                          startLongitude:
                                              locationService.longitude.value,
                                          endLatitude: demoBusinesses[index % 2]
                                              ['location']['lat'],
                                          endLongitude:
                                              demoBusinesses[index % 2]
                                                  ['location']['lon'],
                                        ) / 1000.0).toPrecision(1)} KM",
                                onLocationPressed: () {
                                  Get.to(
                                    () => MapScreen(
                                      lat: demoBusinesses[index % 2]['location']
                                          ['lat'],
                                      lon: demoBusinesses[index % 2]['location']
                                          ['lon'],
                                      title: demoBusinesses[index % 2]['name']
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
                                      data: demoBusinesses[index % 2],
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
