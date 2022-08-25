import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/appConst.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConst.appMainBodyVerticalPadding, horizontal: AppConst.appMainBodyHorizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'We are pleased to announce launching of a new mobile application to mark your attendance remotely, especially when you are working outside the office. With emerging technologies, people perform most of their tasks at the touch of their fingers, and so is attendance tracking and monitoring. Mobile apps for attendance tracking are integrated with BEx for providing a smarter output. With this, you can mark attendance, access real-time location and many more features under development. Mobile apps tend to ease mobility and motivate self-service.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: context.read<ThemeProvider>().selectedPrimaryColor,
              fontSize:
              AppConst.appFontSizeh10,
              fontWeight: AppConst
                  .appTextFontWeightLight,
            ),
          ),
        ],
      ),
    );
  }
}
