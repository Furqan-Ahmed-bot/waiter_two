import 'package:flutter/material.dart';

import '../../Generic/appConst.dart';

class InfoContainer extends StatelessWidget {
  final String time;
  final String infoTitle;
  final Color? tileColor;
  final VoidCallback onPress;
  const InfoContainer({
    Key? key,
    required this.time,
    required this.infoTitle,
    required this.tileColor,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        height: 80.0,
        width: (screenSize.width / 3) - 20.0,
        decoration: BoxDecoration(
          color: tileColor,
          // borderRadius: const BorderRadius.all(
          //   Radius.circular(AppConst.appInfoContainersBorderRadius),
          // ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: AppConst.appFontSizeh10,
                color: tileColor == AppConst.appColorSeparator ? AppConst.appColorBlack : AppConst.appColorWhite,
              ),
            ),
            Text(
              infoTitle,
              style: TextStyle(
                fontSize: AppConst.appFontSizeh11,
                color: tileColor == AppConst.appColorSeparator ? AppConst.appColorBlack : AppConst.appColorWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
