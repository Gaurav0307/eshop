import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPTextField extends StatefulWidget {
  /// Number of the OTP Fields
  final int length;

  /// Total Width of the OTP Text Field
  final double width;

  /// Width of the single OTP Field
  final double fieldWidth;

  /// The style to use for the text being edited.
  final TextStyle style;

  /// Obscure Text if data is sensitive
  final bool obscureText;

  /// Callback function, called when a change is detected to the pin.
  final ValueChanged<String>? onChanged;

  /// Callback function, called when pin is completed.
  final ValueChanged<String>? onCompleted;

  const OTPTextField({
    super.key,
    this.length = 4,
    this.width = 10,
    this.fieldWidth = 30,
    this.style = const TextStyle(),
    this.obscureText = false,
    this.onChanged,
    this.onCompleted,
  }) : assert(length > 1);

  @override
  State<OTPTextField> createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<OTPTextField> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: widget.fieldWidth,
      height: 50,
      textStyle: widget.style,
      decoration: const BoxDecoration(),
    );

    final cursor = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: widget.fieldWidth,
          height: 1,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );

    final preFilledWidget = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: widget.fieldWidth,
          height: 1,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );

    return SizedBox(
      width: widget.width,
      child: Directionality(
        // Specify direction if desired
        textDirection: TextDirection.ltr,
        child: Pinput(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          focusNode: focusNode,
          length: widget.length,
          pinAnimationType: PinAnimationType.none,
          defaultPinTheme: defaultPinTheme,
          showCursor: true,
          autofocus: true,
          cursor: cursor,
          preFilledWidget: preFilledWidget,
          onClipboardFound: widget.onChanged,
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          onCompleted: widget.onCompleted,
          onChanged: widget.onChanged,
          obscureText: widget.obscureText,
        ),
      ),
    );
  }
}
