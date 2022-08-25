import 'package:flutter/material.dart';
import 'package:ts_app_development/Generic/Settings/settingsData.dart';
import '../../Generic/appConst.dart';
import '../../UserControls/SettingsButton/settingsButton.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppConst.appMainBodyVerticalPadding,
          horizontal: AppConst.appMainPaddingSmall,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Settings Iterations from settings array
            for (int i = 0; i < SettingsData.settings.keys.length; i++)
              Padding(
                padding:
                    const EdgeInsets.only(bottom: AppConst.appMainPaddingLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        SettingsData.settings.keys.elementAt(i).toString(),
                        style: const TextStyle(
                          fontSize: AppConst.appFontSizeh10,
                          fontWeight: AppConst.appTextFontWeightBold,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    for (int j = 0;
                        j <
                            SettingsData
                                .settings[SettingsData.settings.keys
                                    .elementAt(i)
                                    .toString()]
                                .length;
                        j++)
                      SettingsButton(
                        iconData: SettingsData.settings[SettingsData
                                .settings.keys
                                .elementAt(i)
                                .toString()]
                            .elementAt(j)['Icon'],
                        title: SettingsData.settings[SettingsData.settings.keys
                                .elementAt(i)
                                .toString()]
                            .elementAt(j)['Name']
                            .toString(),
                        onPressed: () {
                          Navigator.pushNamed(
                              context,
                              SettingsData.settings[SettingsData.settings.keys
                                      .elementAt(i)
                                      .toString()]
                                  .elementAt(j)['Route']);
                        },
                      ),
                  ],
                ),
              ),

            // App Theme Section
            // Primary Color Changing Work Has Been Done
            // Column(
            //   children: [
            //     const Align(
            //       alignment: Alignment.centerLeft,
            //       child: Text(
            //         'App Theme',
            //         style: TextStyle(
            //           fontSize: AppConst.appFontSizeh10,
            //           fontWeight: AppConst.appTextFontWeightBold,
            //           letterSpacing: 2.0,
            //         ),
            //       ),
            //     ),
            //     for (int i = 0; i < ThemeSettings.selectedPrimaryColors.keys.length; i++)
            //       SettingsButton(
            //         iconData: Icons.color_lens_outlined,
            //         title: ThemeSettings.selectedPrimaryColors.keys.elementAt(i),
            //         backgroundColor: Color(ThemeSettings.selectedPrimaryColors.values.elementAt(i)),
            //         onPressed: () async {
            //           context.read<ThemeProvider>().setPrimaryColor(ThemeSettings.selectedPrimaryColors.values.elementAt(i));
            //           final prefs = await SharedPreferences.getInstance();
            //           // set value
            //           await prefs.setString('primaryColor', ThemeSettings.selectedPrimaryColors.values.elementAt(i).toString());
            //           Navigator.pushReplacement(
            //               context, CustomPageRouteBuilder.createRoute('/Dashboard'));
            //           Functions.ShowSnackBar(
            //               context, 'Theme changed to ${ThemeSettings.selectedPrimaryColors.keys.elementAt(i)}.');
            //         },
            //       ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
