import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/appConst.dart';

class CalendarMonths extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;
  const CalendarMonths({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<CalendarMonths> createState() => _CalendarMonthsState();
}

class _CalendarMonthsState extends State<CalendarMonths> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onPressed();
        });
      },
      child: Container(
        height: 80.0,
        decoration: BoxDecoration(
          color: widget.isSelected ? context.read<ThemeProvider>().selectedPrimaryColor : AppConst.appColorWhite,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.isSelected ? AppConst.appColorWhite : context.read<ThemeProvider>().selectedPrimaryColor,
              fontSize: AppConst.appFontSizeh10,
              fontWeight: AppConst.appTextFontWeightMedium,
            ),
          ),
        ),
      ),
    );
  }
}
