import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/appConst.dart';

class PayrollContainer extends StatelessWidget {
  final String month;
  final String year;
  final String salary;
  final String earning;
  final String advance;
  final bool isSelected;
  final Color? statusColor;
  final VoidCallback onPressed;
  const PayrollContainer({
    Key? key,
    required this.month,
    required this.year,
    required this.salary,
    required this.earning,
    required this.advance,
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
            border: isSelected
                ? Border.all(color: context.read<ThemeProvider>().selectedPrimaryColor, width: 3.0)
                : const Border(),
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
                            month,
                            style: const TextStyle(
                              color: AppConst.appColorWhite,
                              fontSize: AppConst.appFontSizeh10,
                              fontWeight: AppConst.appTextFontWeightBold,
                            ),
                          ),
                          Text(
                            year,
                            style: const TextStyle(
                              color: AppConst.appColorWhite,
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
                          'Earning',
                          style: TextStyle(
                            fontSize: AppConst.appFontSizeh10,
                            color: AppConst.appColorTextBlack,
                            fontWeight: AppConst.appTextFontWeightLight,
                          ),
                        ),
                        Text(
                          earning,
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
              Row(
                children: [
                  advance != '0.0' ? Container(
                    padding:
                    const EdgeInsets.only(right: AppConst.appMainPaddingLarge),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Advance',
                          style: TextStyle(
                            fontSize: AppConst.appFontSizeh10,
                            color: AppConst.appColorTextBlack,
                            fontWeight: AppConst.appTextFontWeightLight,
                          ),
                        ),
                        Text(
                          advance,
                          style: const TextStyle(
                            fontSize: AppConst.appFontSizeh11,
                            color: AppConst.appColorTextBlack,
                            fontWeight: AppConst.appTextFontWeightLight,
                          ),
                        )
                      ],
                    ),
                  ) : Container(),
                  Container(
                    padding:
                    const EdgeInsets.only(right: AppConst.appMainPaddingLarge),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Salary',
                          style: TextStyle(
                            fontSize: AppConst.appFontSizeh10,
                            color: AppConst.appColorTextBlack,
                            fontWeight: AppConst.appTextFontWeightLight,
                          ),
                        ),
                        Text(
                          salary,
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
            ],
          ),
        ),
      ),
    );
  }
}
