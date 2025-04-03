import 'package:eshop/common/constants/color_constants.dart';
import 'package:eshop/common/constants/string_constants.dart';
import 'package:eshop/common/global/global.dart';
import 'package:eshop/views/screens/my_business_service/add_business_service_screen.dart';
import 'package:eshop/views/widgets/my_business_service_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/utils/utility_methods.dart';
import '../../../controllers/business_service_controller.dart';
import '../business_service_details_screen.dart';
import 'edit_business_service_screen.dart';

class MyBusinessService extends StatefulWidget {
  const MyBusinessService({super.key});

  @override
  State<MyBusinessService> createState() => _MyBusinessServiceState();
}

class _MyBusinessServiceState extends State<MyBusinessService> {
  var businessServiceController = Get.put(BusinessServiceController());

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
      body: Obx(
        () => businessServiceController
                    .userBusinessServiceModel.value.businessesServices !=
                null
            ? ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                itemCount: businessServiceController
                    .userBusinessServiceModel.value.businessesServices!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: MyBusinessServiceItem(
                      heroTag: index,
                      imageUrl: UtilityMethods.getProperFileUrl(
                          businessServiceController.userBusinessServiceModel
                              .value.businessesServices![index].image!),
                      name: businessServiceController.userBusinessServiceModel
                          .value.businessesServices![index].name!,
                      category: businessServiceController
                          .userBusinessServiceModel
                          .value
                          .businessesServices![index]
                          .category!,
                      timing:
                          "${businessServiceController.userBusinessServiceModel.value.businessesServices![index].openTime!} - "
                          "${businessServiceController.userBusinessServiceModel.value.businessesServices![index].closeTime!}",
                      servicesAndProducts: businessServiceController
                          .userBusinessServiceModel
                          .value
                          .businessesServices![index]
                          .productsServices!
                          .join(", "),
                      address: businessServiceController
                          .userBusinessServiceModel
                          .value
                          .businessesServices![index]
                          .address!,
                      city: businessServiceController.userBusinessServiceModel
                          .value.businessesServices![index].city!,
                      state: businessServiceController.userBusinessServiceModel
                          .value.businessesServices![index].state!,
                      rating: businessServiceController.userBusinessServiceModel
                          .value.businessesServices![index].rating!
                          .toDouble()
                          .toPrecision(1)
                          .toString(),
                      maxRating: "5.0",
                      peopleRated: UtilityMethods.formatNumberToKMB(
                          businessServiceController.userBusinessServiceModel
                              .value.businessesServices![index].rating!
                              .toDouble()),
                      distance: "${(locationService.getDistanceBetween(
                            startLatitude: locationService.latitude.value,
                            startLongitude: locationService.longitude.value,
                            endLatitude: businessServiceController
                                .userBusinessServiceModel
                                .value
                                .businessesServices![index]
                                .location!
                                .lat!
                                .toDouble(),
                            endLongitude: businessServiceController
                                .userBusinessServiceModel
                                .value
                                .businessesServices![index]
                                .location!
                                .lon!
                                .toDouble(),
                          ) / 1000.0).toPrecision(1)} KM",
                      onEditPressed: () {
                        Get.to(
                          () => EditBusinessServiceScreen(
                            businessService: businessServiceController
                                .userBusinessServiceModel
                                .value
                                .businessesServices![index],
                          ),
                        );
                      },
                      onDeletePressed: () {
                        confirmDeleteDialog(
                          businessServiceId: businessServiceController
                              .userBusinessServiceModel
                              .value
                              .businessesServices![index]
                              .id!,
                        );
                      },
                      onMessagePressed: () {},
                      onTap: () {
                        Get.to(
                          () => BusinessServiceDetailsScreen(
                            heroTag: index,
                            data: businessServiceController
                                .userBusinessServiceModel
                                .value
                                .businessesServices![index],
                            isUserBusinessService: true,
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            : const SizedBox.shrink(),
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

  Future<void> confirmDeleteDialog({required String businessServiceId}) async {
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
          content: const Text(StringConstants.doYouWantToDeleteBusinessService),
          actions: <Widget>[
            TextButton(
              child: const Text(
                StringConstants.no,
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                StringConstants.yes,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                businessServiceController.deleteUserBusinessService(
                  businessServiceId: businessServiceId,
                );
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
