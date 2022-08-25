import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/appConst.dart';

class SettingsButton extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onPressed;
  Color? backgroundColor;
  SettingsButton({
    Key? key,
    required this.iconData,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConst.appMainPaddingSmall),
      child: PhysicalModel(
        color: Colors.transparent,
        elevation: 10,
        child: ElevatedButton(
          onPressed: () {
            onPressed();
          },
          style: ElevatedButton.styleFrom(
            // Foreground color
            onPrimary: AppConst.appColorAccent,
            // Background color
            primary: backgroundColor ?? context.read<ThemeProvider>().selectedPrimaryColor,
            fixedSize: Size(screenSize.width - 70.0, 60.0),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConst.appButtonsBorderRadiusMed)),
          ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon with title
              Row(
                children: [
                  Icon(
                    iconData,
                    color: AppConst.appColorWhite,
                    size: 35.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: AppConst.appMainPaddingLarge),
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: AppConst.appFontSizeh11,
                          fontWeight: AppConst.appTextFontWeightLight),
                    ),
                  ),
                ],
              ),

              const Icon(
                Icons.arrow_forward_ios,
                color: AppConst.appColorWhite,
                size: 35.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
