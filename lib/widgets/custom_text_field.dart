import 'package:flutter/material.dart';
import 'package:twitter/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.maxLength,
    required this.controller, this.onFieldSubmitted,
  });
  final String label;
  final String hint;
  final int? maxLength;
  final TextEditingController controller;
  final void Function(String)? onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        cursorColor: Colors.blue,
        onFieldSubmitted:onFieldSubmitted ,
        controller: controller,
        style: const TextStyle(color: AppColors.whiteColor),
        decoration: InputDecoration(
            hintText: hint,
            label: Text(
              label,
              style: const TextStyle(color: AppColors.greyColor),
            ),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.greyColor))),
        maxLength: maxLength,
      ),
    );
  }
}
