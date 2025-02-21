import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/common/constants/asset_constants.dart';
import 'package:eshop/common/global/global.dart';
import 'package:eshop/common/utils/utility_methods.dart';
import 'package:eshop/views/screens/business_service_details_screen.dart';
import 'package:eshop/views/screens/businesses_screen.dart';
import 'package:eshop/views/screens/categories_screen.dart';
import 'package:eshop/views/screens/login_screen.dart';
import 'package:eshop/views/screens/map_screen.dart';
import 'package:eshop/views/screens/search_screen.dart';
import 'package:eshop/views/screens/selected_category_business_service_screen.dart';
import 'package:eshop/views/screens/services_screen.dart';
import 'package:eshop/views/widgets/service_business_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import '../widgets/SearchTextField.dart';
import '../widgets/border_button.dart';
import '../widgets/user_image_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, //It should be false to work
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        await _onBackPressed();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            StringConstants.appName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.to(() => const LoginScreen());
              },
              child: Text(
                StringConstants.login,
                style: TextStyle(
                  color: ColorConstants.black,
                  fontFamily: AssetConstants.poppinsFont,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
          ],
        ),
        drawer: customDrawer(),
        body: ListView(
          children: [
            ///Location
            Obx(
              () => Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 10.0,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    if (locationService.city.value.isNotEmpty) ...{
                      Text(
                        "${locationService.city} (${locationService.state})",
                        style: TextStyle(
                          color: ColorConstants.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 10),
                      BorderButton(
                        width: 70,
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 0.0,
                        ),
                        onPressed: () {},
                        child: Text(
                          StringConstants.change,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    } else ...{
                      Text(
                        "Loading...",
                        style: TextStyle(
                          color: ColorConstants.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    },
                  ],
                ),
              ),
            ),

            ///Search
            SearchTextField(
              hintText: StringConstants.search_,
              onTap: () {
                showSearch(
                  context: context,
                  delegate: SearchScreen(
                    List.generate(10, (index) => "Text $index"),
                  ),
                );
              },
            ),
            const SizedBox(height: 5.0),

            ///Category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        StringConstants.categories,
                        style: TextStyle(
                          color: ColorConstants.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const CategoriesScreen());
                        },
                        child: Text(
                          StringConstants.viewMore,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: AssetConstants.robotoFont,
                            color: ColorConstants.lightBlue,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable inner scrolling
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // 4 columns
                      crossAxisSpacing: 16, // Spacing between columns
                      mainAxisSpacing: 16, // Spacing between rows
                      childAspectRatio: 1.0, // Adjust aspect ratio as needed
                      mainAxisExtent: 115,
                    ),
                    itemCount: demoCategories.length > 8
                        ? 8
                        : demoCategories.length, // 4x2 grid = 8 items
                    itemBuilder: (context, index) {
                      return categoryItem(
                        imageUrl: demoCategories[index]['imageUrl']!,
                        categoryName: demoCategories[index]['category']!,
                        onTap: () {
                          Get.to(
                            () => SelectedCategoryBusinessServiceScreen(
                              categoryName: demoCategories[index]['category']!,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5.0),

            ///Services
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        StringConstants.services,
                        style: TextStyle(
                          color: ColorConstants.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const ServicesScreen());
                        },
                        child: Text(
                          StringConstants.viewMore,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: AssetConstants.robotoFont,
                            color: ColorConstants.lightBlue,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    itemBuilder: (_, index) {
                      return Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: ServiceBusinessItem(
                            heroTag: "Services-$index",
                            imageUrl:
                                demoServices[index % 2]['imageUrl'].toString(),
                            name: demoServices[index % 2]['name'].toString(),
                            category:
                                demoServices[index % 2]['category'].toString(),
                            timing:
                                demoServices[index % 2]['timing'].toString(),
                            servicesAndProducts: demoServices[index % 2]
                                    ['servicesAndProducts']
                                .toString(),
                            address:
                                demoServices[index % 2]['address'].toString(),
                            city: demoServices[index % 2]['city'].toString(),
                            state: demoServices[index % 2]['state'].toString(),
                            rating:
                                demoServices[index % 2]['rating'].toString(),
                            maxRating: "5.0",
                            peopleRated: UtilityMethods.formatNumberToKMB(
                                double.tryParse(demoServices[index % 2]
                                            ['peopleRated']
                                        .toString()) ??
                                    0.0),
                            distance: "${(locationService.getDistanceBetween(
                                  startLatitude: locationService.latitude.value,
                                  startLongitude:
                                      locationService.longitude.value,
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
                                  heroTag: "Services-$index",
                                  data: demoServices[index % 2],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),

            ///Businesses
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        StringConstants.businesses,
                        style: TextStyle(
                          color: ColorConstants.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const BusinessesScreen());
                        },
                        child: Text(
                          StringConstants.viewMore,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: AssetConstants.robotoFont,
                            color: ColorConstants.lightBlue,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    itemBuilder: (_, index) {
                      return Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: ServiceBusinessItem(
                            heroTag: "Business-$index",
                            imageUrl: demoBusinesses[index % 2]['imageUrl']
                                .toString(),
                            name: demoBusinesses[index % 2]['name'].toString(),
                            category: demoBusinesses[index % 2]['category']
                                .toString(),
                            timing:
                                demoBusinesses[index % 2]['timing'].toString(),
                            servicesAndProducts: demoBusinesses[index % 2]
                                    ['servicesAndProducts']
                                .toString(),
                            address:
                                demoBusinesses[index % 2]['address'].toString(),
                            city: demoBusinesses[index % 2]['city'].toString(),
                            state:
                                demoBusinesses[index % 2]['state'].toString(),
                            rating:
                                demoBusinesses[index % 2]['rating'].toString(),
                            maxRating: "5.0",
                            peopleRated: UtilityMethods.formatNumberToKMB(
                                double.tryParse(demoBusinesses[index % 2]
                                            ['peopleRated']
                                        .toString()) ??
                                    0.0),
                            distance: "${(locationService.getDistanceBetween(
                                  startLatitude: locationService.latitude.value,
                                  startLongitude:
                                      locationService.longitude.value,
                                  endLatitude: demoBusinesses[index % 2]
                                      ['location']['lat'],
                                  endLongitude: demoBusinesses[index % 2]
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
                                  heroTag: "Business-$index",
                                  data: demoBusinesses[index % 2],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }

  Future<void> _onBackPressed() async {
    await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            StringConstants.confirm,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: const Text(StringConstants.doYouWantToExitTheApp),
          actions: <Widget>[
            TextButton(
              child: const Text(
                StringConstants.no,
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop(); //Will not exit the App
              },
            ),
            TextButton(
              child: const Text(
                StringConstants.yes,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                SystemNavigator.pop();
                Navigator.of(context).pop(); //Will exit the App
              },
            )
          ],
        );
      },
    );
  }

  Widget categoryItem({
    required String imageUrl,
    required String categoryName,
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 70, // Adjust size
              height: 70, // Adjust size
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5.0),
          SizedBox(
            width: 75.0,
            child: Text(
              categoryName,
              maxLines: 2,
              style: TextStyle(
                color: ColorConstants.black,
                fontFamily: AssetConstants.robotoFont,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget customDrawer() {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 230.0,
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 10.0,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.purple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10.0),
                  const UserImageWidget(
                    imageUrl:
                        "https://images.unsplash.com/photo-1603415526960-f7e0328c63b1",
                    title: "User Name",
                    size: 120,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "User Name",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_business),
              title: const Text(
                StringConstants.addBusinessService,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16.0,
              ),
              onTap: () {},
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                StringConstants.logout,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
