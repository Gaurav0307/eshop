import 'package:eshop/views/screens/otp_verification_screen.dart';
import 'package:eshop/views/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import '../../common/utils/utility_methods.dart';
import '../widgets/border_button.dart';
import '../widgets/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(25.0),
            padding: const EdgeInsets.all(25.0),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: ColorConstants.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  spreadRadius: 2.0,
                  blurRadius: 8.0,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  StringConstants.login,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25.0),
                const LoginForm(),
                const SizedBox(height: 55.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringConstants.doNotHaveAnAccount,
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
                      onPressed: () async {
                        Get.to(() => const RegisterScreen());
                      },
                      child: Text(
                        StringConstants.register,
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

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String mobile = '';

  final _formKey = GlobalKey<FormState>();

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
          const SizedBox(height: 50.0),
          Visibility(
            visible: true,
            replacement: Center(
              child: CircularProgressIndicator(
                color: ColorConstants.white,
                strokeWidth: 3.0,
              ),
            ),
            child: GradientButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  FocusScope.of(context).unfocus();
                }
                Get.to(() => const OTPVerificationScreen());
              },
              child: Text(
                StringConstants.login,
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
