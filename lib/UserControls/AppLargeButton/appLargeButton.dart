import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/appConst.dart';

class AppLargeButton extends StatelessWidget {
  final Widget titleWidget;
  Color? backgroundColor;
  final VoidCallback onPressedFunc;
  AppLargeButton({
    Key? key,
    required this.titleWidget,
    required this.onPressedFunc,
    this.backgroundColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: () {
        onPressedFunc();
      },
      style: ElevatedButton.styleFrom(
        // Foreground color
        onPrimary: AppConst.appColorAccent,
        // Background color
        primary: backgroundColor ?? context.read<ThemeProvider>().selectedPrimaryColor,
        fixedSize: Size(screenSize.width - 70.0, 50.0),
        shape: const RoundedRectangleBorder(
          // borderRadius:
          //     BorderRadius.circular(AppConst.appButtonsBorderRadiusMed),
        ),
      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
      child: titleWidget,
    );
  }
}
