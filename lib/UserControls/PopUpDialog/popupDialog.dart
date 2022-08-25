import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/appConst.dart';

class PopUpDialog extends StatefulWidget {
  final String title;
  final Widget content;
  final bool isAction;
  final bool isCloseBtn;
  final bool isHeader;
  VoidCallback onPressYes;
  double? horizontalContentPadding;
  PopUpDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.isAction,
    required this.isCloseBtn,
    required this.isHeader,
    required this.onPressYes,
    this.horizontalContentPadding,
  }) : super(key: key);

  @override
  State<PopUpDialog> createState() => _PopUpDialogState();
}

class _PopUpDialogState extends State<PopUpDialog> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return AlertDialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: AppConst.appMainPaddingSmall),
      title: widget.isHeader
          ? Container(
              color: context.read<ThemeProvider>().selectedPrimaryColor,
              width: double.infinity,
              height: 40.0,
              child: widget.isCloseBtn
                  ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConst.appMainPaddingExtraSmall),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: AppConst.appFontSizeh9,
                              fontWeight: AppConst.appTextFontWeightMedium,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              size: AppConst.appFontSizeh8,
                              color: AppConst.appColorWhite,
                            ),
                          ),
                        ],
                      ),
                  )
                  : Center(
                    child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: AppConst.appFontSizeh9,
                          fontWeight: AppConst.appTextFontWeightMedium,
                        ),
                      ),
                  ),
            )
          : Container(),
      content: widget.content,
      contentPadding: EdgeInsets.symmetric(
          vertical: AppConst.appMainPaddingMedium,
          horizontal: widget.horizontalContentPadding != null
              ? widget.horizontalContentPadding!
              : AppConst.appMainPaddingSmall),
      titleTextStyle: const TextStyle(
        fontSize: AppConst.appFontSizeh9,
        fontWeight: AppConst.appTextFontWeightMedium,
        color: AppConst.appColorWhite,
      ),
      actions: widget.isAction
          ? [
              ElevatedButton(
                onPressed: () {
                  widget.onPressYes();
                },
                style: ElevatedButton.styleFrom(
                  // Foreground color
                  onPrimary: AppConst.appColorAccent,
                  // Background color
                  primary: context.read<ThemeProvider>().selectedPrimaryColor,
                  shape: RoundedRectangleBorder(
                    // borderRadius:
                    //     BorderRadius.circular(AppConst.appButtonsBorderRadiusMed),
                  ),
                ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                child: const Text("Yes"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  // Foreground color
                  onPrimary: AppConst.appColorAccent,
                  // Background color
                  primary: context.read<ThemeProvider>().selectedPrimaryColor,
                  shape: RoundedRectangleBorder(
                    // borderRadius:
                    //     BorderRadius.circular(AppConst.appButtonsBorderRadiusMed),
                  ),
                ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                child: const Text("No"),
              ),
            ]
          : [],
    );
  }
}
