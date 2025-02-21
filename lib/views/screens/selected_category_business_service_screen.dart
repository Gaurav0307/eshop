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

class SelectedCategoryBusinessServiceScreen extends StatefulWidget {
  final String categoryName;
  const SelectedCategoryBusinessServiceScreen(
      {super.key, required this.categoryName});

  @override
  State<SelectedCategoryBusinessServiceScreen> createState() =>
      _SelectedCategoryBusinessServiceScreenState();
}

class _SelectedCategoryBusinessServiceScreenState
    extends State<SelectedCategoryBusinessServiceScreen> {
  TextEditingController searchTEC = TextEditingController();

  final allData = [...demoBusinesses, ...demoServices];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          ///Search
          SearchTextField(
            hintText: StringConstants.search_
                .replaceAll("...", " ${widget.categoryName}"),
            textEditingController: searchTEC,
            onChange: (_) {
              setState(() {});
            },
          ),

          ///Services
          Expanded(
            child: allData
                    .where(
                      (item) =>
                          item['name']!
                              .toString()
                              .toLowerCase()
                              .contains(searchTEC.text.toLowerCase()) &&
                          item['category']!
                              .toString()
                              .toLowerCase()
                              .contains(widget.categoryName.toLowerCase()),
                    )
                    .isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    itemCount: allData.length,
                    itemBuilder: (context, index) {
                      return allData[index]['name']!
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchTEC.text.toLowerCase()) &&
                              allData[index]['category']!
                                  .toString()
                                  .toLowerCase()
                                  .contains(widget.categoryName.toLowerCase())
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: ServiceBusinessItem(
                                heroTag: index,
                                imageUrl: allData[index]['imageUrl'].toString(),
                                name: allData[index]['name'].toString(),
                                category: allData[index]['category'].toString(),
                                timing: allData[index]['timing'].toString(),
                                servicesAndProducts: allData[index]
                                        ['servicesAndProducts']
                                    .toString(),
                                address: allData[index]['address'].toString(),
                                city: allData[index]['city'].toString(),
                                state: allData[index]['state'].toString(),
                                rating: allData[index]['rating'].toString(),
                                maxRating: "5.0",
                                peopleRated: UtilityMethods.formatNumberToKMB(
                                    double.tryParse(allData[index]
                                                ['peopleRated']
                                            .toString()) ??
                                        0.0),
                                distance:
                                    "${(locationService.getDistanceBetween(
                                          startLatitude:
                                              locationService.latitude.value,
                                          startLongitude:
                                              locationService.longitude.value,
                                          endLatitude: allData[index]
                                              ['location']['lat'],
                                          endLongitude: allData[index]
                                              ['location']['lon'],
                                        ) / 1000.0).toPrecision(1)} KM",
                                onLocationPressed: () {
                                  Get.to(
                                    () => MapScreen(
                                      lat: allData[index]['location']['lat'],
                                      lon: allData[index]['location']['lon'],
                                      title: allData[index]['name'].toString(),
                                    ),
                                  );
                                },
                                onCallPressed: () {},
                                onMessagePressed: () {},
                                onTap: () {
                                  Get.to(
                                    () => BusinessServiceDetailsScreen(
                                      heroTag: index,
                                      data: allData[index],
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
