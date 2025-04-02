import 'package:eshop/common/global/global.dart';
import 'package:eshop/models/BusinessServiceModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/constants/asset_constants.dart';
import '../../common/constants/string_constants.dart';
import '../../common/utils/utility_methods.dart';
import '../../controllers/business_service_controller.dart';
import '../widgets/service_business_item.dart';
import 'business_service_details_screen.dart';
import 'map_screen.dart';

class SearchScreen extends SearchDelegate {
  final List<String> listExample;

  List<BusinessesServices> allData = Get.put(BusinessServiceController())
      .businessServiceModel
      .value
      .businessesServices!;

  SearchScreen(this.listExample);

  List<BusinessesServices> searchResults(String query) {
    List<BusinessesServices> results = [];

    allData.sort((a, b) {
      return locationService
          .getDistanceBetween(
            startLatitude: locationService.latitude.value,
            startLongitude: locationService.longitude.value,
            endLatitude: a.location!.lat!.toDouble(),
            endLongitude: a.location!.lon!.toDouble(),
          )
          .compareTo(locationService.getDistanceBetween(
            startLatitude: locationService.latitude.value,
            startLongitude: locationService.longitude.value,
            endLatitude: b.location!.lat!.toDouble(),
            endLongitude: b.location!.lon!.toDouble(),
          ));
    });

    for (var data in allData) {
      if (data.name.toString().toLowerCase().contains(query.toLowerCase()) ||
          data.category
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          data.productsServices!
              .join(", ")
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())) {
        results.add(data);
      }
    }

    return results;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(
          Icons.close,
          color: Color(0xFF3F4654),
        ),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Color(0xFF3F4654),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget whenSearchResultEmpty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: 180,
            width: 180,
            decoration: const BoxDecoration(),
            child: Image.asset(AssetConstants.search),
          ),
        ),
        Container(
          height: 95,
          margin: const EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                StringConstants.noSearchResultTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 250,
                child: Text(
                  StringConstants.noSearchResultSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AssetConstants.robotoFont,
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<BusinessesServices> searchResult = searchResults(query);

    return searchResult.isEmpty
        ? whenSearchResultEmpty()
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            itemCount: searchResult.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ServiceBusinessItem(
                  heroTag: index,
                  imageUrl: UtilityMethods.getProperFileUrl(
                      searchResult[index].image.toString()),
                  name: searchResult[index].name.toString(),
                  category: searchResult[index].category.toString(),
                  timing:
                      "${searchResult[index].openTime} - ${searchResult[index].closeTime}",
                  servicesAndProducts: searchResult[index]
                      .productsServices!
                      .join(", ")
                      .toString(),
                  address: searchResult[index].address.toString(),
                  city: searchResult[index].city.toString(),
                  state: searchResult[index].state.toString(),
                  rating: searchResult[index]
                      .rating!
                      .toDouble()
                      .toPrecision(1)
                      .toString(),
                  maxRating: "5.0",
                  peopleRated: UtilityMethods.formatNumberToKMB(
                      searchResult[index].ratedBy!.toDouble()),
                  distance: "${(locationService.getDistanceBetween(
                        startLatitude: locationService.latitude.value,
                        startLongitude: locationService.longitude.value,
                        endLatitude:
                            searchResult[index].location!.lat!.toDouble(),
                        endLongitude:
                            searchResult[index].location!.lon!.toDouble(),
                      ) / 1000.0).toPrecision(1)} KM",
                  onLocationPressed: () {
                    Get.to(
                      () => MapScreen(
                        lat: searchResult[index].location!.lat!.toDouble(),
                        lon: searchResult[index].location!.lon!.toDouble(),
                        title: searchResult[index].name.toString(),
                      ),
                    );
                  },
                  onCallPressed: () {},
                  onMessagePressed: () {},
                  onTap: () {
                    Get.to(
                      () => BusinessServiceDetailsScreen(
                        heroTag: index,
                        data: searchResult[index],
                      ),
                    );
                  },
                ),
              );
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<BusinessesServices> searchResult = searchResults(query);

    return searchResult.isEmpty
        ? whenSearchResultEmpty()
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            itemCount: searchResult.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ServiceBusinessItem(
                  heroTag: index,
                  imageUrl: UtilityMethods.getProperFileUrl(
                      searchResult[index].image.toString()),
                  name: searchResult[index].name.toString(),
                  category: searchResult[index].category.toString(),
                  timing:
                      "${searchResult[index].openTime} - ${searchResult[index].closeTime}",
                  servicesAndProducts: searchResult[index]
                      .productsServices!
                      .join(", ")
                      .toString(),
                  address: searchResult[index].address.toString(),
                  city: searchResult[index].city.toString(),
                  state: searchResult[index].state.toString(),
                  rating: searchResult[index]
                      .rating!
                      .toDouble()
                      .toPrecision(1)
                      .toString(),
                  maxRating: "5.0",
                  peopleRated: UtilityMethods.formatNumberToKMB(
                      searchResult[index].ratedBy!.toDouble()),
                  distance: "${(locationService.getDistanceBetween(
                        startLatitude: locationService.latitude.value,
                        startLongitude: locationService.longitude.value,
                        endLatitude:
                            searchResult[index].location!.lat!.toDouble(),
                        endLongitude:
                            searchResult[index].location!.lon!.toDouble(),
                      ) / 1000.0).toPrecision(1)} KM",
                  onLocationPressed: () {
                    Get.to(
                      () => MapScreen(
                        lat: searchResult[index].location!.lat!.toDouble(),
                        lon: searchResult[index].location!.lon!.toDouble(),
                        title: searchResult[index].name.toString(),
                      ),
                    );
                  },
                  onCallPressed: () {},
                  onMessagePressed: () {},
                  onTap: () {
                    Get.to(
                      () => BusinessServiceDetailsScreen(
                        heroTag: index,
                        data: searchResult[index],
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
