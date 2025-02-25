import 'package:eshop/common/constants/color_constants.dart';
import 'package:eshop/common/constants/string_constants.dart';
import 'package:eshop/common/global/global.dart';
import 'package:eshop/views/screens/my_business_service/add_business_service_screen.dart';
import 'package:eshop/views/widgets/my_business_service_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/utils/utility_methods.dart';
import '../business_service_details_screen.dart';

class MyBusinessService extends StatefulWidget {
  const MyBusinessService({super.key});

  @override
  State<MyBusinessService> createState() => _MyBusinessServiceState();
}

class _MyBusinessServiceState extends State<MyBusinessService> {
  List<Map<String, dynamic>> allData = [...demoBusinesses, ...demoServices];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          StringConstants.myBusinessAndService,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        itemCount: allData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: MyBusinessServiceItem(
              heroTag: index,
              imageUrl: allData[index]['imageUrl'].toString(),
              name: allData[index]['name'].toString(),
              category: allData[index]['category'].toString(),
              timing: allData[index]['timing'].toString(),
              servicesAndProducts:
                  allData[index]['servicesAndProducts'].toString(),
              address: allData[index]['address'].toString(),
              city: allData[index]['city'].toString(),
              state: allData[index]['state'].toString(),
              rating: allData[index]['rating'].toString(),
              maxRating: "5.0",
              peopleRated: UtilityMethods.formatNumberToKMB(
                  double.tryParse(allData[index]['peopleRated'].toString()) ??
                      0.0),
              distance: "${(locationService.getDistanceBetween(
                    startLatitude: locationService.latitude.value,
                    startLongitude: locationService.longitude.value,
                    endLatitude: allData[index]['location']['lat'],
                    endLongitude: allData[index]['location']['lon'],
                  ) / 1000.0).toPrecision(1)} KM",
              onEditPressed: () {},
              onDeletePressed: () {},
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorConstants.mintGreenBG,
        foregroundColor: ColorConstants.black,
        onPressed: () {
          Get.to(() => const AddBusinessServiceScreen());
        },
        icon: const Icon(Icons.add_business),
        label: const Text(StringConstants.add),
      ),
    );
  }
}
