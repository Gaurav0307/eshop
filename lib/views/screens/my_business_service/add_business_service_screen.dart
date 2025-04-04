import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/views/screens/my_business_service/business_service_otp_verification_screen.dart';
import 'package:eshop/views/screens/my_business_service/location_picker_screen.dart';
import 'package:eshop/views/widgets/border_button.dart';
import 'package:eshop/views/widgets/gradient_button.dart';
import 'package:eshop/views/widgets/title_content_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../common/constants/asset_constants.dart';
import '../../../common/constants/color_constants.dart';
import '../../../common/constants/string_constants.dart';
import '../../../common/global/global.dart';
import '../../../common/utils/utility_methods.dart';
import '../../../controllers/business_service_controller.dart';
import '../../widgets/my_country_state_city_picker.dart';

class AddBusinessServiceScreen extends StatefulWidget {
  const AddBusinessServiceScreen({super.key});

  @override
  State<AddBusinessServiceScreen> createState() =>
      _AddBusinessServiceScreenState();
}

class _AddBusinessServiceScreenState extends State<AddBusinessServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          StringConstants.addBusinessService,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        children: const [
          SizedBox(height: 20.0),
          AddBusinessServiceForm(),
          SizedBox(height: 50.0),
        ],
      ),
    );
  }
}

class AddBusinessServiceForm extends StatefulWidget {
  const AddBusinessServiceForm({super.key});

  @override
  State<AddBusinessServiceForm> createState() => _AddBusinessServiceFormState();
}

class _AddBusinessServiceFormState extends State<AddBusinessServiceForm> {
  String name = '';
  TextEditingController nameTEC = TextEditingController();
  String type = '';
  List<String> types = ["Select", "Business", "Service"];
  String category = '';
  List<String> categories = [
    ...demoCategories.map((category) => category['category']!)
  ];

  // Open and Close Time
  final TextEditingController _openTimeController = TextEditingController();
  final TextEditingController _closeTimeController = TextEditingController();
  TimeOfDay? _selectedOpenTime;
  TimeOfDay? _selectedCloseTime;

  Future<void> _selectTime(BuildContext context, bool isOpenTime) async {
    TimeOfDay initialTime = isOpenTime
        ? (_selectedOpenTime ?? TimeOfDay.now())
        : (_selectedCloseTime ?? TimeOfDay.now());

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      setState(() {
        if (isOpenTime) {
          _selectedOpenTime = pickedTime;
          _openTimeController.text = _formatTime(pickedTime);
        } else {
          _selectedCloseTime = pickedTime;
          _closeTimeController.text = _formatTime(pickedTime);
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final DateTime now = DateTime.now();
    final DateTime formattedTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(formattedTime);
  }

  String? _validateOpenTime(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.openTimeIsRequired;
    }
    return null;
  }

  String? _validateCloseTime(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.closeTimeIsRequired;
    }
    return null;
  }
  //

  String address = '';
  TextEditingController addressTEC = TextEditingController();
  TextEditingController countryTEC = TextEditingController();
  TextEditingController stateTEC = TextEditingController();
  TextEditingController cityTEC = TextEditingController();
  String mobile = '';

  bool callEnabled = true;
  bool messageEnabled = true;
  bool isActive = true;

  // Product and Services
  final TextEditingController productsServicesTEC = TextEditingController();
  final List<String> productsServicesList = [];

  void _addItem() {
    String newItem = productsServicesTEC.text.trim();
    if (newItem.isNotEmpty && !productsServicesList.contains(newItem)) {
      setState(() {
        productsServicesList.add(newItem);
      });
      productsServicesTEC.clear();
    }
  }

  void _confirmRemoveItem(String item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          StringConstants.removeItem,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: ColorConstants.black,
          ),
        ),
        content:
            Text(StringConstants.doYouReallyWantToRemove.replaceAll('#', item)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              StringConstants.cancel,
              style: TextStyle(
                fontFamily: AssetConstants.robotoFont,
                color: ColorConstants.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                productsServicesList.remove(item);
              });
              Navigator.pop(context);
            },
            child: Text(
              StringConstants.remove,
              style: TextStyle(
                fontFamily: AssetConstants.robotoFont,
                color: ColorConstants.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateProductsServices(String? value) {
    if (productsServicesList.isEmpty) {
      return StringConstants.pleaseAddAtLeastOneProductService;
    }
    return null;
  }
  //

  String? _validateName(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.nameIsRequired;
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.addressIsRequired;
    }
    return null;
  }

  String toTitleCase(String text) {
    if (text.isEmpty) return '';

    final words = text.split(' ');
    final titleCaseWords = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
      return '';
    });

    return titleCaseWords.join(' ');
  }

  String? _validateType(String? value) {
    if (value == types.first) {
      return StringConstants.typeIsRequired;
    }

    return null;
  }

  String? _validateCategory(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.categoryIsRequired;
    }

    return null;
  }

  String? _validateCountry(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.countryIsRequired;
    }
    return null;
  }

  String? _validateState(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.stateIsRequired;
    }
    return null;
  }

  String? _validateCity(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.cityIsRequired;
    }
    return null;
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.mobileNumberIsRequired;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return StringConstants.enterAValid10DigitMobileNumber;
    }

    return null;
  }

  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  String imageUrl = '';
  File? _imageFile;

  Future<void> _getImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );

    setState(() {
      _imageFile = File(pickedImage!.path);
    });
  }

  Future<void> _getImageFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 20,
    );

    _imageFile = File(pickedImage!.path);

    setState(() {});
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            StringConstants.selectImageSource,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text(
                  StringConstants.gallery,
                ),
                onTap: () {
                  _getImageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text(
                  StringConstants.camera,
                ),
                onTap: () {
                  _getImageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String imageError = '';
  bool validateImage() {
    if (imageUrl.isEmpty && _imageFile == null) {
      setState(() {
        imageError = StringConstants.imageIsRequired;
      });
      return false;
    } else {
      setState(() {
        imageError = '';
      });
      return true;
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    type = types.first;
    countryTEC.text = locationService.country.value;
    stateTEC.text = locationService.state.value;
    cityTEC.text = locationService.city.value;
    loadCurrentLocation();
    super.initState();
  }

  void loadCurrentLocation() {
    selectedLocation.latitude.value = locationService.latitude.value;
    selectedLocation.longitude.value = locationService.longitude.value;
    selectedLocation.locationTitle.value = StringConstants.currentLocation;
  }

  GoogleMapController? googleMapController;

  @override
  void dispose() {
    nameTEC.dispose();
    super.dispose();
  }

  var businessServiceController = Get.put(BusinessServiceController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              if (imageUrl.isEmpty)
                Container(
                  height: (MediaQuery.of(context).size.width - 35) * 1.1,
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorConstants.grey300,
                      width: 1.0,
                    ),
                    image: _imageFile != null
                        ? DecorationImage(
                            image: FileImage(
                              File(_imageFile!.path),
                            ),
                            fit: BoxFit.cover,
                          )
                        : const DecorationImage(
                            image: AssetImage(
                              AssetConstants.store,
                            ),
                            fit: BoxFit.fitWidth,
                            opacity: 0.1,
                          ),
                  ),
                )
              else
                Container(
                  height: (MediaQuery.of(context).size.width - 35) * 1.1,
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorConstants.grey300,
                      width: 1.0,
                    ),
                    image: _imageFile != null
                        ? DecorationImage(
                            image: FileImage(
                              File(_imageFile!.path),
                            ),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: CachedNetworkImageProvider(
                              imageUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              Positioned(
                right: 15,
                bottom: 15,
                child: GestureDetector(
                  onTap: () {
                    _showImageSourceDialog();
                  },
                  child: CircleAvatar(
                    backgroundColor: ColorConstants.black54,
                    radius: 25,
                    child: Icon(
                      _imageFile != null || imageUrl.isNotEmpty
                          ? Icons.edit
                          : Icons.add_photo_alternate_outlined,
                      size: 25.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          if (imageError.isNotEmpty)
            Text(
              imageError,
              style: TextStyle(
                color: ColorConstants.red,
                fontSize: 12.0,
              ),
            ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: nameTEC,
            validator: _validateName,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z ]') // Allow alphabets and space
                  ),
              TextInputFormatter.withFunction(
                (oldValue, newValue) {
                  // Convert the new input to title case
                  if (newValue.text.isNotEmpty) {
                    final convertedValue = toTitleCase(newValue.text);
                    return TextEditingValue(
                      text: convertedValue,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: convertedValue.length),
                      ),
                    );
                  }
                  return newValue;
                },
              ),
            ],
            style: TextStyle(color: ColorConstants.black),
            maxLength: 50,
            maxLengthEnforcement: name.isNotEmpty
                ? MaxLengthEnforcement.enforced
                : MaxLengthEnforcement.none,
            decoration: InputDecoration(
              counterText: name.isNotEmpty ? null : "",
              hintText: StringConstants.name,
              hintStyle: TextStyle(color: ColorConstants.black54),
              labelText: StringConstants.name,
              labelStyle: TextStyle(color: ColorConstants.black54),
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
            ),
            keyboardType: TextInputType.name,
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            validator: _validateType,
            menuMaxHeight: 200,
            value: type.isNotEmpty ? type : types.first,
            hint: Text(types.first),
            onChanged: (String? newValue) {
              setState(() {
                type = newValue!;
              });
            },
            items: types.map((String type_) {
              return DropdownMenuItem<String>(
                value: type_,
                child: Text(type_),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: StringConstants.type,
              labelStyle: TextStyle(color: ColorConstants.black54),
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                // return const Iterable<String>.empty(); // Show no categories when input is empty
                return categories; // Show all categories when input is empty
              }

              return categories.where((String category_) {
                return category_
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String newValue) {
              setState(() {
                category = newValue;
              });
            },
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) {
              textEditingController.text = category; // Set initial value

              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                validator: _validateCategory,
                decoration: InputDecoration(
                  labelText: StringConstants.category,
                  labelStyle: TextStyle(color: ColorConstants.black54),
                  contentPadding: const EdgeInsets.all(15.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorConstants.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorConstants.black),
                  ),
                ),
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  category = '';
                  for (var element in categories) {
                    if (element.toLowerCase() == value.toLowerCase()) {
                      setState(() {
                        category = element;
                      });
                    }
                  }
                },
              );
            },
          ),
          const SizedBox(height: 16.0),
          //OpenTime
          TextFormField(
            controller: _openTimeController,
            validator: _validateOpenTime,
            readOnly: true,
            decoration: InputDecoration(
              hintText: StringConstants.openTime,
              hintStyle: TextStyle(color: ColorConstants.black54),
              labelText: StringConstants.openTime,
              labelStyle: TextStyle(color: ColorConstants.black54),
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              suffixIcon: Icon(
                Icons.access_time,
                color: ColorConstants.black54,
              ),
            ),
            onTap: () => _selectTime(context, true),
          ),
          const SizedBox(height: 16),
          //CloseTime
          TextFormField(
            controller: _closeTimeController,
            validator: _validateCloseTime,
            readOnly: true,
            decoration: InputDecoration(
              hintText: StringConstants.closeTime,
              hintStyle: TextStyle(color: ColorConstants.black54),
              labelText: StringConstants.closeTime,
              labelStyle: TextStyle(color: ColorConstants.black54),
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              suffixIcon: Icon(
                Icons.access_time,
                color: ColorConstants.black54,
              ),
            ),
            onTap: () => _selectTime(context, false),
          ),
          const SizedBox(height: 16),
          // Products and Services
          TextFormField(
            controller: productsServicesTEC,
            validator: _validateProductsServices,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9 ]') // Allow alphabets, number and space
                  ),
              TextInputFormatter.withFunction(
                (oldValue, newValue) {
                  // Convert the new input to title case
                  if (newValue.text.isNotEmpty) {
                    final convertedValue = toTitleCase(newValue.text);
                    return TextEditingValue(
                      text: convertedValue,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: convertedValue.length),
                      ),
                    );
                  }
                  return newValue;
                },
              ),
            ],
            decoration: InputDecoration(
              hintText: StringConstants.productsAndOrServices,
              hintStyle: TextStyle(color: ColorConstants.black54),
              labelText: StringConstants.productsAndOrServices,
              labelStyle: TextStyle(color: ColorConstants.black54),
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.add,
                  color: ColorConstants.black,
                ),
                onPressed: _addItem,
              ),
            ),
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: productsServicesList.map((item) {
              return Chip(
                label: Text(
                  item,
                  style: const TextStyle(
                    fontFamily: AssetConstants.robotoFont,
                  ),
                ),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 18,
                ),
                deleteIconColor: ColorConstants.red,
                onDeleted: () => _confirmRemoveItem(item),
                backgroundColor: ColorConstants.whiteBG,
              );
            }).toList(),
          ),
          //
          const SizedBox(height: 16.0),
          TextFormField(
            controller: addressTEC,
            validator: _validateAddress,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z ]') // Allow alphabets and space
                  ),
              TextInputFormatter.withFunction(
                (oldValue, newValue) {
                  // Convert the new input to title case
                  if (newValue.text.isNotEmpty) {
                    final convertedValue = toTitleCase(newValue.text);
                    return TextEditingValue(
                      text: convertedValue,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: convertedValue.length),
                      ),
                    );
                  }
                  return newValue;
                },
              ),
            ],
            style: TextStyle(color: ColorConstants.black),
            maxLength: 50,
            maxLengthEnforcement: address.isNotEmpty
                ? MaxLengthEnforcement.enforced
                : MaxLengthEnforcement.none,
            decoration: InputDecoration(
              counterText: address.isNotEmpty ? null : "",
              hintText: StringConstants.address,
              hintStyle: TextStyle(color: ColorConstants.black54),
              labelText: StringConstants.address,
              labelStyle: TextStyle(color: ColorConstants.black54),
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
            ),
            keyboardType: TextInputType.name,
            onChanged: (val) {
              setState(() {
                address = val;
              });
            },
          ),
          const SizedBox(height: 16.0),
          CountryStateCityPicker(
            country: countryTEC,
            countryValidator: _validateCountry,
            countryInputDecoration: InputDecoration(
              hintText: StringConstants.country,
              hintStyle: TextStyle(color: ColorConstants.black54),
              labelText: StringConstants.country,
              labelStyle: TextStyle(color: ColorConstants.black54),
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
            ),
            state: stateTEC,
            stateValidator: _validateState,
            stateInputDecoration: InputDecoration(
              hintText: StringConstants.state,
              hintStyle: TextStyle(color: ColorConstants.black54),
              labelText: StringConstants.state,
              labelStyle: TextStyle(color: ColorConstants.black54),
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
            ),
            city: cityTEC,
            cityValidator: _validateCity,
            cityInputDecoration: InputDecoration(
              hintText: StringConstants.city,
              hintStyle: TextStyle(color: ColorConstants.black54),
              labelText: StringConstants.city,
              labelStyle: TextStyle(color: ColorConstants.black54),
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
            ),
            inputTextStyle: TextStyle(color: ColorConstants.black54),
            dialogBGColor: ColorConstants.white,
          ),
          const SizedBox(height: 24.0),
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              mobile = number.phoneNumber!;
            },
            validator: _validateMobileNumber,
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.disabled,
            selectorTextStyle: const TextStyle(color: Colors.black),
            initialValue: number,
            // textFieldController: mobileTEC,
            formatInput: false,
            keyboardType: const TextInputType.numberWithOptions(
              signed: true,
              decimal: true,
            ),
            inputDecoration: InputDecoration(
              hintText: StringConstants.mobileNumber,
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.30,
                margin: const EdgeInsets.only(top: 34.0),
                decoration: BoxDecoration(
                  // border: Border.all(color: ColorConstants.black54),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Card(
                  elevation: 5.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Obx(
                      () {
                        if (googleMapController != null) {
                          googleMapController!.moveCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  selectedLocation.latitude.value,
                                  selectedLocation.longitude.value,
                                ),
                                zoom: 16.0,
                              ),
                            ),
                          );
                        }
                        return GoogleMap(
                          mapToolbarEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              selectedLocation.latitude.value,
                              selectedLocation.longitude.value,
                            ),
                            zoom: 16,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId(
                                "${selectedLocation.latitude}, ${selectedLocation.longitude}",
                              ),
                              position: LatLng(
                                selectedLocation.latitude.value,
                                selectedLocation.longitude.value,
                              ),
                              infoWindow: InfoWindow(
                                  title: selectedLocation.locationTitle.value),
                              // icon: customMarkerIcon,
                            ),
                          },
                          onMapCreated: (mapController) {
                            googleMapController = mapController;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 25,
                child: Center(
                  child: Container(
                    width: 80,
                    height: 25,
                    decoration: BoxDecoration(
                      color: ColorConstants.white,
                      border: Border.all(color: ColorConstants.black54),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Center(
                      child: Text(
                        StringConstants.location,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 16.0),
          const Text(StringConstants.or),
          const SizedBox(height: 16.0),
          BorderButton(
            width: 130,
            padding: const EdgeInsets.symmetric(
              vertical: 2.0,
              horizontal: 0.0,
            ),
            onPressed: () {
              Get.to(() => const LocationPickerScreen());
            },
            child: Text(
              StringConstants.selectFromMap,
              style: TextStyle(
                fontFamily: AssetConstants.robotoFont,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorConstants.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30.0),
          ListTile(
            leading: Icon(
              Icons.phone,
              color: ColorConstants.black,
            ),
            title: const Text(
              StringConstants.call,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Switch(
              activeColor: Colors.green,
              value: callEnabled,
              onChanged: (isEnabled) {
                setState(() {
                  callEnabled = isEnabled;
                });
              },
            ),
          ),
          const SizedBox(height: 16.0),
          ListTile(
            leading: Icon(
              Icons.message,
              color: ColorConstants.black,
            ),
            title: const Text(
              StringConstants.message,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Switch(
              activeColor: Colors.green,
              value: messageEnabled,
              onChanged: (isEnabled) {
                setState(() {
                  messageEnabled = isEnabled;
                });
              },
            ),
          ),
          const SizedBox(height: 16.0),
          ListTile(
            leading: Icon(
              Icons.check_circle_outline,
              color: ColorConstants.black,
            ),
            title: const Text(
              StringConstants.active,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: CupertinoSwitch(
              activeColor: Colors.green,
              value: isActive,
              onChanged: (isEnabled) {
                setState(() {
                  isActive = isEnabled;
                });
              },
            ),
          ),
          const SizedBox(height: 60.0),
          Obx(
            () => Visibility(
              visible: !businessServiceController.isLoading.value,
              replacement: Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.indigo,
                  strokeWidth: 3.0,
                ),
              ),
              child: GradientButton(
                onPressed: () async {
                  if (token.value.isEmpty) {
                    await showTitleContentDialog(
                        context,
                        StringConstants.loginRequired,
                        StringConstants.pleaseLoginToUseThisFeature);
                    return;
                  }
                  if (!validateImage()) {
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    FocusScope.of(context).unfocus();
                    if (mobile == userMobile) {
                      await businessServiceController.addUserBusinessService(
                        name: name,
                        type: type,
                        category: category,
                        openTime: _openTimeController.text,
                        closeTime: _closeTimeController.text,
                        productsServices: productsServicesList,
                        address: address,
                        city: cityTEC.text,
                        state: stateTEC.text,
                        country: countryTEC.text,
                        mobile: mobile,
                        lat: selectedLocation.latitude.value,
                        lon: selectedLocation.longitude.value,
                        businessImage: _imageFile!,
                        callEnabled: callEnabled,
                        messageEnabled: messageEnabled,
                        isActive: isActive,
                      );
                      Navigator.pop(context);
                    } else {
                      if (await businessServiceController.sendOTP(mobile)) {
                        Get.to(
                          () => BusinessServiceOTPVerificationScreen(
                            fullName: name,
                            mobile: mobile,
                            futureCallBack: () async {
                              await businessServiceController
                                  .addUserBusinessService(
                                name: name,
                                type: type,
                                category: category,
                                openTime: _openTimeController.text,
                                closeTime: _closeTimeController.text,
                                productsServices: productsServicesList,
                                address: address,
                                city: cityTEC.text,
                                state: stateTEC.text,
                                country: countryTEC.text,
                                mobile: mobile,
                                lat: selectedLocation.latitude.value,
                                lon: selectedLocation.longitude.value,
                                businessImage: _imageFile!,
                                callEnabled: callEnabled,
                                messageEnabled: messageEnabled,
                                isActive: isActive,
                              );
                            },
                          ),
                        );
                      }
                    }
                  }
                },
                child: Text(
                  StringConstants.save,
                  style: TextStyle(
                    fontSize: 18,
                    color: ColorConstants.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
