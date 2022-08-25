import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/Settings/settingsData.dart';
import '../../Generic/appConst.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppConst.appMainBodyVerticalPadding, horizontal: AppConst.appMainBodyHorizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < SettingsData.updatePasswordFaqs.length; i++)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q. ${SettingsData.updatePasswordFaqs[i][0]}',
                    style: TextStyle(
                      color: context.read<ThemeProvider>().selectedPrimaryColor,
                      fontSize:
                      AppConst.appFontSizeh9,
                      fontWeight: AppConst
                          .appTextFontWeightBold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: AppConst.appMainPaddingSmall),
                    child: Text(
                      'A. ${SettingsData.updatePasswordFaqs[i][1]}',
                      style: TextStyle(
                        color: context.read<ThemeProvider>().selectedPrimaryColor,
                        fontSize:
                        AppConst.appFontSizeh9,
                        fontWeight: AppConst
                            .appTextFontWeightLight,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
