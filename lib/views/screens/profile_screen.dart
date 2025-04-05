import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../common/constants/asset_constants.dart';
import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import '../../common/global/global.dart';
import '../../common/utils/utility_methods.dart';
import '../../controllers/user_profile_controller.dart';
import '../widgets/gradient_button.dart';
import '../widgets/title_content_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          StringConstants.profile,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        children: const [
          SizedBox(height: 25.0),
          ProfileForm(),
          SizedBox(height: 60.0),
        ],
      ),
    );
  }
}

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  String fullName = '';
  String mobile = '';

  TextEditingController fullNameTEC = TextEditingController();
  TextEditingController mobileTEC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.fullNameIsRequired;
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

  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.mobileNumberIsRequired;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return StringConstants.enterAValid10DigitMobileNumber;
    }

    return null;
  }

  late PhoneNumber number = PhoneNumber(isoCode: 'IN');

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

  var userProfileController = Get.put(UserProfileController());

  @override
  void initState() {
    super.initState();
    fullName =
        userProfileController.userProfileModel.value.profile?.fullname ?? '';
    mobile = userProfileController.userProfileModel.value.profile?.mobile ?? '';

    fullNameTEC.text = fullName;
    mobile =
        mobile.isNotEmpty ? UtilityMethods.separateIsoCode(mobile).last : '';
    mobileTEC.text = mobile;
    imageUrl =
        userProfileController.userProfileModel.value.profile?.image != null
            ? UtilityMethods.getProperFileUrl(
                userProfileController.userProfileModel.value.profile!.image!)
            : '';
  }

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
                  padding: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.purple,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: _imageFile != null
                          ? DecorationImage(
                              image: FileImage(
                                File(_imageFile!.path),
                              ),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: AssetImage(
                                AssetConstants.user,
                              ),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.purple,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
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
                ),
              Positioned(
                right: 18,
                bottom: 18,
                child: GestureDetector(
                  onTap: () {
                    _showImageSourceDialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.purple,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      _imageFile == null
                          ? Icons.add_photo_alternate_outlined
                          : Icons.edit,
                      size: 25.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60.0),
          TextFormField(
            controller: fullNameTEC,
            style: TextStyle(color: ColorConstants.black),
            validator: _validateFullName,
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
            maxLength: 30,
            maxLengthEnforcement: fullName.isNotEmpty
                ? MaxLengthEnforcement.enforced
                : MaxLengthEnforcement.none,
            decoration: InputDecoration(
              counterText: fullName.isNotEmpty ? null : "",
              hintText: StringConstants.fullName,
              hintStyle: TextStyle(color: ColorConstants.black),
              prefixIcon: Icon(
                Icons.person_outline,
                color: ColorConstants.black,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.black),
              ),
              contentPadding: const EdgeInsets.all(15.0),
            ),
            keyboardType: TextInputType.name,
            onChanged: (val) {
              setState(() {
                fullName = val;
              });
            },
          ),
          const SizedBox(height: 16),
          InternationalPhoneNumberInput(
            isEnabled: false,
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
            textFieldController: mobileTEC,
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
          const SizedBox(height: 40.0),
          Obx(
            () => Visibility(
              visible: !userProfileController.isLoading.value,
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
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    FocusScope.of(context).unfocus();
                    await userProfileController.updateProfile(
                        fullName, _imageFile);
                  }
                },
                child: Text(
                  StringConstants.save,
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorConstants.white,
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
