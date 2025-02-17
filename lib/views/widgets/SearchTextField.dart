import 'package:flutter/material.dart';

import '../../common/constants/color_constants.dart';

class SearchTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? textEditingController;
  final void Function(String)? onChange;
  final void Function()? onTap;
  const SearchTextField({
    super.key,
    required this.hintText,
    this.textEditingController,
    this.onChange,
    this.onTap,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
          controller: widget.textEditingController,
          readOnly: widget.onTap != null,
          decoration: InputDecoration(
            hintText: widget.hintText,
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
          onChanged: widget.onChange,
        ),
      ),
    );
  }
}
