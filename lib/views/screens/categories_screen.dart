import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/controllers/category_controller.dart';
import 'package:eshop/views/screens/selected_category_business_service_screen.dart';
import 'package:eshop/views/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/constants/asset_constants.dart';
import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import '../../common/utils/utility_methods.dart';
import '../widgets/SearchTextField.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  TextEditingController searchTEC = TextEditingController();

  var categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          StringConstants.categories,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          ///Search
          SearchTextField(
            hintText: StringConstants.searchCategory,
            textEditingController: searchTEC,
            onChange: (_) {
              setState(() {});
            },
          ),

          ///Categories
          Obx(
            () => Expanded(
              child: categoryController.categoryModel.value.categories!
                      .where((item) => item.title!
                          .toLowerCase()
                          .contains(searchTEC.text.toLowerCase()))
                      .isNotEmpty
                  ? ListView.builder(
                      itemCount: categoryController
                          .categoryModel.value.categories!.length,
                      itemBuilder: (context, index) {
                        return categoryController
                                .categoryModel.value.categories![index].title!
                                .toLowerCase()
                                .contains(searchTEC.text.toLowerCase())
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: ListTile(
                                  onTap: () {
                                    Get.to(
                                      () =>
                                          SelectedCategoryBusinessServiceScreen(
                                        categoryName: categoryController
                                            .categoryModel
                                            .value
                                            .categories![index]
                                            .title!,
                                      ),
                                    );
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 5.0,
                                  ),
                                  leading: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: UtilityMethods.getProperFileUrl(
                                          categoryController.categoryModel.value
                                              .categories![index].image!),
                                      width: 58, // Adjust size
                                      height: 58, // Adjust size
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    categoryController.categoryModel.value
                                        .categories![index].title!,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: ColorConstants.black,
                                      fontFamily: AssetConstants.robotoFont,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    )
                  : const NoData(),
            ),
          ),
        ],
      ),
    );
  }
}
