import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/appConst.dart';

class Slice extends StatelessWidget {
  double? height;
  double? contentHorizontalPadding;
  Color? statusColor;
  final VoidCallback onPress;
  final Widget leftAreaContent;
  final Widget rightAreaContent;
  final bool isSelected;
  Slice({
    Key? key,
    required this.onPress,
    required this.leftAreaContent,
    required this.rightAreaContent,
    required this.isSelected,
    this.height,
    this.contentHorizontalPadding,
    this.statusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double? containerHeight = height ?? 250;
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppConst.appMainPaddingSmall),
        child: PhysicalModel(
          color: Colors.transparent,
          elevation: 5.0,
          child: Container(
            width: double.infinity,
            height: containerHeight,
            decoration: BoxDecoration(
              border: isSelected ? Border.all(color: context.read<ThemeProvider>().selectedPrimaryColor, width: 1.5) : const Border(),
            ),
            child: Row(
              children: [
                // Left Container
                Container(
                  height: containerHeight,
                  width: screenSize.width * 0.20,
                  color: statusColor ?? AppConst.appColorLightBlue,
                  child: leftAreaContent,
                ),
                // Right Child
                Expanded(
                  child: Container(
                    height: containerHeight,
                    padding: EdgeInsets.symmetric(
                      vertical: AppConst.appMainPaddingLarge,
                      horizontal: contentHorizontalPadding ?? AppConst.appMainPaddingLarge,
                    ),
                    decoration: const BoxDecoration(
                      color: AppConst.appColorWhite,
                    ),
                    child: rightAreaContent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
