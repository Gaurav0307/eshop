import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/common/constants/asset_constants.dart';
import 'package:eshop/common/global/global.dart';
import 'package:eshop/views/screens/login_screen.dart';
import 'package:eshop/views/widgets/service_business_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
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
          backgroundColor: Colors.blue.shade100,
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
            ///Search
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                decoration: BoxDecoration(
                  color: ColorConstants.white,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: ColorConstants.grey300,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorConstants.grey.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: StringConstants.search_,
                    hintStyle: TextStyle(
                      color: ColorConstants.black54,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: ColorConstants.black54,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                    ),
                  ),
                ),
              ),
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
                        onPressed: () {},
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
                    itemCount: demoCategories.length, // 4x2 grid = 8 items
                    itemBuilder: (context, index) {
                      return categoryItem(
                        imageUrl: demoCategories[index]['imageUrl']!,
                        categoryName: demoCategories[index]['category']!,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5.0),

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
                        StringConstants.services,
                        style: TextStyle(
                          color: ColorConstants.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
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
                      return ServiceBusinessItem(
                        imageUrl: demoServices[0]['imageUrl'].toString(),
                        name: demoServices[0]['name'].toString(),
                        category: demoServices[0]['category'].toString(),
                        timing: demoServices[0]['timing'].toString(),
                        servicesAndProducts:
                            demoServices[0]['servicesAndProducts'].toString(),
                        address: demoServices[0]['address'].toString(),
                        city: demoServices[0]['city'].toString(),
                        state: demoServices[0]['state'].toString(),
                        rating: demoServices[0]['rating'].toString(),
                        peopleRated: demoServices[0]['peopleRated'].toString(),
                        onLocationPressed: () {},
                        onCallPressed: () {},
                        onMessagePressed: () {},
                        onTap: () {},
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),

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
                        StringConstants.businesses,
                        style: TextStyle(
                          color: ColorConstants.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
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
                      return ServiceBusinessItem(
                        imageUrl: demoBusinesses[0]['imageUrl'].toString(),
                        name: demoBusinesses[0]['name'].toString(),
                        category: demoBusinesses[0]['category'].toString(),
                        timing: demoBusinesses[0]['timing'].toString(),
                        servicesAndProducts:
                            demoBusinesses[0]['servicesAndProducts'].toString(),
                        address: demoBusinesses[0]['address'].toString(),
                        city: demoBusinesses[0]['city'].toString(),
                        state: demoBusinesses[0]['state'].toString(),
                        rating: demoBusinesses[0]['rating'].toString(),
                        peopleRated:
                            demoBusinesses[0]['peopleRated'].toString(),
                        onLocationPressed: () {},
                        onCallPressed: () {},
                        onMessagePressed: () {},
                        onTap: () {},
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
  }) {
    return Column(
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
