import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/AppScreens/appScreens.dart';
import '../../Generic/appConst.dart';

class CustomTabBar extends StatelessWidget {
  final List<int>? tabsNotificationList;
  final List<String> tabsList;
  final String route;
  final TabController tabController;
  const CustomTabBar(
      {Key? key,
      required this.tabsNotificationList,
      required this.tabsList,
      required this.route,
      required this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      automaticIndicatorColorAdjustment: true,
      indicatorColor: context.read<ThemeProvider>().selectedPrimaryColor,
      controller: tabController,
      tabs: [
        for (int i = 0; i < tabsList.length; i++)
          tabsNotificationList != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: context.read<ThemeProvider>().selectedPrimaryColor,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Tab(
                        child: Text(
                          '${tabsNotificationList![i]}',
                          style: const TextStyle(
                            color: AppConst.appColorWhite,
                            fontSize: AppConst.appFontSizeh11,
                            fontWeight: AppConst.appTextFontWeightLight,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: AppConst.appMainPaddingExtraSmall),
                      child: Tab(
                        child: Text(
                          tabsList[i],
                          style: const TextStyle(
                            color: AppConst.appColorTextBlack,
                            fontSize: AppConst.appFontSizeh10,
                            fontWeight: AppConst.appTextFontWeightLight,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Tab(
                  child: Text(
                    tabsList[i],
                    style: const TextStyle(
                      color: AppConst.appColorTextBlack,
                      fontSize: AppConst.appFontSizeh10,
                      fontWeight: AppConst.appTextFontWeightLight,
                    ),
                  ),
                ),
      ],
    );
  }
}
