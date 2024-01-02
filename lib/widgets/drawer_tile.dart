// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter/constants/app_colors.dart';

class DrawerTile extends StatelessWidget {
  final String icon;
  final String title;
  final void Function()? onTap;
  const DrawerTile({super.key, required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        icon,
        color: AppColors.whiteColor,
      ),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.whiteColor),
      ),
      onTap: onTap,
    );
  }
}
