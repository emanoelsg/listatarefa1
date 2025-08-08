// app/utils/helpers/helper_functions.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class THelperFunctions {
  static void showSnackBar(String message) {
    Get.snackbar(
      'Aviso',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[800],
      colorText: Colors.white,
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Get.to(() => screen);
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
