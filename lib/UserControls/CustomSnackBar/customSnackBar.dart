import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_app_development/Generic/appConst.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';

class CustomSnackBar extends StatelessWidget {
  final String content;
  const CustomSnackBar({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: context.read<ThemeProvider>().selectedPrimaryColor,
      elevation: 20.0,
      padding: const EdgeInsets.all(10.0),
      duration: const Duration(milliseconds: 5000),
      content: Text(
        content,
        style: const TextStyle(
          color: AppConst.appColorWhite,
            fontSize: AppConst.appFontSizeh9,
            fontWeight: AppConst.appTextFontWeightMedium),
      ),
    );
  }
}
