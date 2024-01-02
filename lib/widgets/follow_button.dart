import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({
    super.key,
    this.onPressed,
    required this.text,
    this.textColor,
    this.buttonColor,
    this.borderColor,
    required this.width,
    required this.height,
  });
  final void Function()? onPressed;
  final String text;
  final Color? textColor;
  final Color? buttonColor;
  final Color? borderColor;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(Size(width, height)),
          side: MaterialStateProperty.all(
              BorderSide(color: borderColor ?? Colors.transparent)),
          backgroundColor: MaterialStateProperty.all(buttonColor)),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.w900, fontSize: 15),
      ),
    );
  }
}
