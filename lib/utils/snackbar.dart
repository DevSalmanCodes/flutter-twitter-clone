import 'package:get/get.dart';
import 'package:twitter/constants/app_colors.dart';
class CustomSnackBar{
  
static void error(String message) {
  Get.closeAllSnackbars();
  Get.snackbar('Error', message,
      colorText: AppColors.whiteColor,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM);
} 
static void success(String message) {
  Get.closeAllSnackbars();
  Get.snackbar('Success', message,
      colorText: AppColors.whiteColor,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM);
}
static void info(String message) {
  Get.closeAllSnackbars();
  Get.snackbar('Info', message,
      colorText: AppColors.whiteColor,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM);
}


 
}