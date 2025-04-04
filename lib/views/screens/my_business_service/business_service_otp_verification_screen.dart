import 'dart:async';

import 'package:eshop/controllers/business_service_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constants/color_constants.dart';
import '../../../common/constants/string_constants.dart';
import '../../widgets/border_button.dart';
import '../../widgets/otp_field.dart';

class BusinessServiceOTPVerificationScreen extends StatefulWidget {
  final String fullName;
  final String mobile;
  final Future<void> Function() futureCallBack;
  const BusinessServiceOTPVerificationScreen({
    super.key,
    required this.fullName,
    required this.mobile,
    required this.futureCallBack,
  });
  @override
  State<BusinessServiceOTPVerificationScreen> createState() =>
      _BusinessServiceOTPVerificationScreenState();
}

class _BusinessServiceOTPVerificationScreenState
    extends State<BusinessServiceOTPVerificationScreen> {
  String verificationCode = '';

  bool _isResendingOTP = true;
  int _resendTimer = 60;
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _isResendingOTP = false;
          _timer.cancel();
        }
      });
    });
  }

  void _reStartTimer() {
    _isResendingOTP = true;
    _resendTimer = 60;
    _startTimer();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  var businessServiceController = Get.put(BusinessServiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.whiteBG,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 50),
          Center(
            child: Text(
              StringConstants.verifyYourMobileNo,
              style: TextStyle(
                fontSize: 22,
                color: ColorConstants.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              StringConstants.enterOTP,
              style: TextStyle(
                color: ColorConstants.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: OTPTextField(
              length: 4,
              width: MediaQuery.of(context).size.width - 50,
              fieldWidth: 50,
              style: TextStyle(
                fontSize: 18,
                color: ColorConstants.black,
              ),
              onCompleted: (pin) {
                verificationCode = pin;

                if (verificationCode.length == 4) {
                  verifyAndRegister();
                }
              },
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Center(
            child: Obx(
              () => Visibility(
                visible: !businessServiceController.isLoading.value,
                replacement: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: ColorConstants.black,
                    strokeWidth: 2,
                  ),
                ),
                child: BorderButton(
                  width: 100,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 0.0,
                  ),
                  onPressed: () {
                    if (verificationCode.length == 4) {
                      verifyAndRegister();
                    }
                  },
                  child: Text(
                    StringConstants.submit,
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstants.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Visibility(
            visible: _isResendingOTP,
            replacement: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringConstants.didNotGetOTP,
                  style: TextStyle(color: ColorConstants.black),
                ),
                Obx(
                  () => TextButton(
                    onPressed: () async {
                      if (businessServiceController.isLoading.value) return;

                      if (await businessServiceController
                          .sendOTP(widget.mobile)) {
                        _reStartTimer();
                      }
                    },
                    child: Visibility(
                      visible: !businessServiceController.isLoading.value,
                      replacement: SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: ColorConstants.black,
                          strokeWidth: 2,
                        ),
                      ),
                      child: Text(
                        StringConstants.resendNow,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorConstants.black,
                          decoration: TextDecoration.underline,
                          decorationColor: ColorConstants.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  'Resend OTP in $_resendTimer seconds',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorConstants.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> verifyAndRegister() async {
    if (await businessServiceController.verifyOTP(
        widget.mobile, verificationCode)) {
      if (await businessServiceController.userRegister(
          widget.fullName, widget.mobile)) {
        await widget.futureCallBack();
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }
}
