import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/appConst.dart';

class AttendanceButton extends StatelessWidget {
  final IconData icon;
  final String buttonText;
  final Color buttonColor;
  final bool isSelected;
  final VoidCallback onPress;
  const AttendanceButton({
    Key? key,
    required this.icon,
    required this.buttonText,
    required this.buttonColor,
    required this.onPress,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPress();
      },
      style: ElevatedButton.styleFrom(
        // Foreground color
        onPrimary: isSelected ? AppConst.appColorWhite : AppConst.appColorTextBlack,
        // Background color
        primary: isSelected ? context.read<ThemeProvider>().selectedPrimaryColor : buttonColor,
        fixedSize: const Size(100.0, 70.0),
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: AppConst.appColorTextBlack,
            width: 1.5,
          ),
          // borderRadius:
          //     BorderRadius.circular(AppConst.appButtonsBorderRadiusMax),
        ),
      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 35.0,
          ),
          Text(
            buttonText,
            style: const TextStyle(
              fontSize: 14.0, // Fixed
              fontWeight: AppConst.appTextFontWeightExtraLight,
            ),
          ),
        ],
      ),
    );
  }
}
