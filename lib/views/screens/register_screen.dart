import 'package:eshop/views/screens/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import '../../common/utils/utility_methods.dart';
import '../widgets/border_button.dart';
import '../widgets/gradient_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.white,
      ),
      backgroundColor: ColorConstants.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringConstants.register,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25.0),
                const RegisterForm(),
                const SizedBox(height: 60.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringConstants.alreadyHaveAnAccount,
                      style: TextStyle(
                        color: ColorConstants.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 10),
                    BorderButton(
                      width: 80,
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 0.0,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        StringConstants.login,
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorConstants.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String fullName = '';
  String mobile = '';

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

  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
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
          const SizedBox(height: 40.0),
          Visibility(
            visible: true,
            replacement: Center(
              child: CircularProgressIndicator(
                color: ColorConstants.indigo,
                strokeWidth: 3.0,
              ),
            ),
            child: GradientButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  FocusScope.of(context).unfocus();
                }
                Get.to(() => const OTPVerificationScreen(isVerification: true));
              },
              child: Text(
                StringConstants.register,
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConstants.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
