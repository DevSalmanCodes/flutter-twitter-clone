import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/constants/home_consts.dart';

import '../constants/app_colors.dart';
import '../providers/home_provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      body: homeItems[homeProvider.currentIndex],
      backgroundColor: Colors.black,
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.transparent,
        backgroundColor: AppColors.blackColor,
        selectedIndex: homeProvider.currentIndex,
        onDestinationSelected: homeProvider.onTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              size: 30,
              color: Colors.white,
            ),
            selectedIcon: Icon(
              Icons.home,
              size: 30,
              color: AppColors.whiteColor,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.search_outlined,
              size: 30,
              color: AppColors.whiteColor,
            ),
            selectedIcon: Icon(
              Icons.search,
              size: 30,
              color: AppColors.whiteColor,
            ),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.notifications_outlined,
              size: 30,
              color: AppColors.whiteColor,
            ),
            selectedIcon: Icon(
              Icons.notifications,
              size: 30,
              color: AppColors.whiteColor,
            ),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.mail_outlined,
              size: 30,
              color: AppColors.whiteColor,
            ),
            selectedIcon: Icon(
              Icons.mail,
              size: 30,
              color: AppColors.whiteColor,
            ),
            label: 'Messages',
          ),
        ],
        surfaceTintColor: Colors.black,
        elevation: 10,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      ),
    );
  }
}
