import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/appConst.dart';

class HistoryContainer extends StatelessWidget {
  final int day;
  final String month;
  final String timeIn;
  final String timeOut;
  final bool isSelected;
  final Color? statusColor;
  final VoidCallback onPressed;
  const HistoryContainer({
    Key? key,
    required this.day,
    required this.month,
    required this.timeIn,
    required this.timeOut,
    required this.isSelected,
    required this.statusColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: AppConst.appMainPaddingSmall),
        child: Container(
          width: double.infinity,
          height: 90.0,
          decoration: BoxDecoration(
            color: AppConst.appColorSperator,
            border: isSelected ? Border.all(color: context.read<ThemeProvider>().selectedPrimaryColor, width: 3.0) : const Border(),
            borderRadius: const BorderRadius.all(
              Radius.circular(AppConst.appButtonsBorderRadiusMax),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Side Row
              Row(
                children: [
                  Container(
                    height: 90.0,
                    width: 80.0,
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: statusColor ?? AppConst.appColorWhite,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$day',
                            style: const TextStyle(
                              fontSize: AppConst.appFontSizeh10,
                              fontWeight: AppConst.appTextFontWeightBold,
                            ),
                          ),
                          Text(
                            month,
                            style: const TextStyle(
                              fontSize: AppConst.appFontSizeh10,
                              fontWeight: AppConst.appTextFontWeightMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: AppConst.appMainPaddingMedium),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Time In',
                          style: TextStyle(
                            fontSize: AppConst.appFontSizeh10,
                            color: AppConst.appColorTextBlack,
                            fontWeight: AppConst.appTextFontWeightLight,
                          ),
                        ),
                        Text(
                          timeIn,
                          style: const TextStyle(
                            fontSize: AppConst.appFontSizeh11,
                            color: AppConst.appColorTextBlack,
                            fontWeight: AppConst.appTextFontWeightLight,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              // Right Side Container
              Container(
                padding:
                    const EdgeInsets.only(right: AppConst.appMainPaddingLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Time Out',
                      style: TextStyle(
                        fontSize: AppConst.appFontSizeh10,
                        color: AppConst.appColorTextBlack,
                        fontWeight: AppConst.appTextFontWeightLight,
                      ),
                    ),
                    Text(
                      timeOut,
                      style: const TextStyle(
                        fontSize: AppConst.appFontSizeh11,
                        color: AppConst.appColorTextBlack,
                        fontWeight: AppConst.appTextFontWeightLight,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
