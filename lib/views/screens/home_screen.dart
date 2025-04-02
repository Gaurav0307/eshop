import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/common/constants/asset_constants.dart';
import 'package:eshop/common/global/global.dart';
import 'package:eshop/common/utils/utility_methods.dart';
import 'package:eshop/controllers/business_service_controller.dart';
import 'package:eshop/controllers/category_controller.dart';
import 'package:eshop/views/screens/business_service_details_screen.dart';
import 'package:eshop/views/screens/businesses_screen.dart';
import 'package:eshop/views/screens/categories_screen.dart';
import 'package:eshop/views/screens/login_screen.dart';
import 'package:eshop/views/screens/map_screen.dart';
import 'package:eshop/views/screens/my_business_service/my_business_service.dart';
import 'package:eshop/views/screens/profile_screen.dart';
import 'package:eshop/views/screens/search_screen.dart';
import 'package:eshop/views/screens/select_location_screen.dart';
import 'package:eshop/views/screens/selected_category_business_service_screen.dart';
import 'package:eshop/views/screens/services_screen.dart';
import 'package:eshop/views/widgets/service_business_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import '../../common/services/internet_connectivity.dart';
import '../../controllers/user_profile_controller.dart';
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
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    InternetConnectivity.addConnectivityListener(() {
      UtilityMethods.loadInitialData().then((_) {
        if (selectedLocation.city.value.isNotEmpty) {
          businessServiceController.getNearByBusinessService(
            country: selectedLocation.country.value,
            state: selectedLocation.state.value,
            city: selectedLocation.city.value,
          );
        }
      });
    });

    super.initState();
  }

  var categoryController = Get.put(CategoryController());
  var businessServiceController = Get.put(BusinessServiceController());
  var userProfileController = Get.put(UserProfileController());

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              ///Location
              Obx(
                () {
                  if (selectedLocation.city.value.isNotEmpty) {
                    businessServiceController.getNearByBusinessService(
                      country: selectedLocation.country.value,
                      state: selectedLocation.state.value,
                      city: selectedLocation.city.value,
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 10.0,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        if (selectedLocation.city.value.isNotEmpty) ...{
                          Text(
                            "${selectedLocation.city} (${selectedLocation.state})",
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
                            onPressed: () {
                              Get.to(() => const SelectLocationScreen());
                            },
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
                  );
                },
              ),

              ///Search
              SearchTextField(
                hintText: StringConstants.search_,
                onTap: () {
                  if (businessServiceController
                          .businessServiceModel.value.businessesServices !=
                      null) {
                    showSearch(
                      context: context,
                      delegate: SearchScreen(
                        List.generate(10, (index) => "Text $index"),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 5.0),

              ///Category
              Obx(
                () {
                  if (categoryController.categoryModel.value.categories !=
                      null) {
                    return Padding(
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
                              childAspectRatio:
                                  1.0, // Adjust aspect ratio as needed
                              mainAxisExtent: 115,
                            ),
                            itemCount: categoryController.categoryModel.value
                                        .categories!.length >
                                    8
                                ? 8
                                : categoryController.categoryModel.value
                                    .categories!.length, // 4x2 grid = 8 items
                            itemBuilder: (context, index) {
                              return categoryItem(
                                imageUrl: UtilityMethods.getProperFileUrl(
                                    categoryController.categoryModel.value
                                        .categories![index].image!),
                                categoryName: categoryController.categoryModel
                                    .value.categories![index].title!,
                                onTap: () {
                                  Get.to(
                                    () => SelectedCategoryBusinessServiceScreen(
                                      categoryName: categoryController
                                          .categoryModel
                                          .value
                                          .categories![index]
                                          .title!,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 5.0),

              ///Services
              Obx(
                () {
                  if (businessServiceController.services.isNotEmpty) {
                    return Column(
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
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                businessServiceController.services.length,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 20.0),
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
                                            endLatitude:
                                                businessServiceController
                                                    .services[index]
                                                    .location!
                                                    .lat!
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
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 15.0),

              ///Businesses
              Obx(
                () {
                  if (businessServiceController.businesses.isNotEmpty) {
                    return Column(
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
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                businessServiceController.businesses.length,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 20.0),
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
                                            endLatitude:
                                                businessServiceController
                                                    .businesses[index]
                                                    .location!
                                                    .lat!
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
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 15.0),
            ],
          ),
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
            Obx(
              () => Container(
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
                    UserImageWidget(
                      imageUrl: UtilityMethods.getProperFileUrl(
                          userProfileController
                                  .userProfileModel.value.profile?.image ??
                              ''),
                      title: userProfileController
                              .userProfileModel.value.profile?.fullname ??
                          "Guest User",
                      size: 120,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      userProfileController
                              .userProfileModel.value.profile?.fullname ??
                          "Guest User",
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
            ),
            ListTile(
              leading: const Icon(Icons.add_business),
              title: const Text(
                StringConstants.myBusinessAndService,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16.0,
              ),
              onTap: () {
                Get.to(() => const MyBusinessService());
              },
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text(
                StringConstants.profile,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16.0,
              ),
              onTap: () {
                Get.to(() => const ProfileScreen());
              },
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
