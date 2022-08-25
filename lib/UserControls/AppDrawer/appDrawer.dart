import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_app_development/DataLayer/Models/ApiResponse/ApiResponse.dart';
import 'package:ts_app_development/DataLayer/Providers/APIConnectionProvider/apiConnectionProvider.dart';
import 'package:ts_app_development/DataLayer/Providers/UserProvider/userProvider.dart';
import 'package:ts_app_development/Generic/AppScreens/appScreens.dart';
import 'package:ts_app_development/WaitersOrder/OrderScreen.dart';
import 'package:ts_app_development/WaitersOrder/SelectTable.dart';
import 'package:ts_app_development/WaitersOrder/orders.dart';
import '../../DataLayer/Providers/DataProvider/dataProvider.dart';
import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../DataLayer/Services/AuthenticationService/authenticationService.dart';
import '../../Generic/Functions/functions.dart';
import '../../Generic/appConst.dart';
import '../PageRouteBuilder/pageRouteBuilder.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context);
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    APIConnectionProvider apiProvider =
        Provider.of<APIConnectionProvider>(context);
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.read<ThemeProvider>().selectedPrimaryColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // Picture Container
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        bottom: 15.0,
                      ),
                      child: userProvider.userData['ImageBlock'] != null
                          ? PhysicalModel(elevation: 20.0, color: Colors.transparent, child: Image.memory(
                        base64Decode(userProvider.userData['ImageBlock']),height: screenSize.height*0.13, width: screenSize.width*0.25,))
                          : Center(
                              child: Text(
                                'No Image',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: context.read<ThemeProvider>().selectedPrimaryColor,
                                  fontSize: AppConst.appFontSizeh10,
                                  fontWeight: AppConst.appTextFontWeightBold,
                                ),
                              ),
                            ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     top: 10.0,
                    //     bottom: 20.0,
                    //   ),
                    //   child: CircleAvatar(
                    //     radius: (screenSize.width * 0.12),
                    //     backgroundColor: Colors.transparent,
                    //     child: userProvider.userData['ImageBlock'] != 'null'
                    //         ? Functions.imageFromBase64String(
                    //             userProvider.userData['ImageBlock'])
                    //         : const Center(
                    //             child: Text(
                    //               'No Image',
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(
                    //                 color: context.read<ThemeProvider>().selectedPrimaryColor,
                    //                 fontSize: AppConst.appFontSizeh10,
                    //                 fontWeight: AppConst.appTextFontWeightBold,
                    //               ),
                    //             ),
                    //           ),
                    //   ),
                    // ),
                    // Name Container
                    Text(
                      '${userProvider.userData['EmployeeName']}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: screenSize.width < 350
                            ? AppConst.appFontSizeh9
                            : AppConst.appFontSizeh10,
                        fontWeight: AppConst.appTextFontWeightMedium,
                      ),
                    ),
                    // Designation Container
                    Text(
                      '${userProvider.userData['Designation']}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: AppConst.appFontSizeh10,
                        fontWeight: AppConst.appTextFontWeightExtraLight,
                      ),
                    ),
                    // Department Container
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppConst.appMainBodyVerticalPadding),
                      child: Text(
                        '${userProvider.userData['Department']}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: AppConst.appFontSizeh10,
                          fontWeight: AppConst.appTextFontWeightExtraLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IntrinsicHeight(
            child: ListTile(
              title: const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: AppConst.appFontSizeh10,
                ),
              ),
              leading: const Icon(Icons.dashboard_outlined),
              onTap: () {
                Navigator.pushReplacement(
                    context, CustomPageRouteBuilder.createRoute('/Dashboard'));
              },
              textColor: AppConst.appColorText,
              minLeadingWidth: 10.0,
              iconColor: AppConst.appColorText,
            ),
          ),
          IntrinsicHeight(
            child:  ListTile(
              title: const Text(
                'Point of Sale',
                style: TextStyle(
                  fontSize: AppConst.appFontSizeh10,
                ),
              ),
              leading: const Icon(Icons.point_of_sale),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SelectTable()));
              },
              textColor: AppConst.appColorText,
              minLeadingWidth: 10.0,
              iconColor: AppConst.appColorText,
            ),
          ),
          // SizedBox(
          //   height: screenSize.height * 0.35,
          //   child: SingleChildScrollView(
          //     child: Column(
          //       children: [
          //         for (int index = 0;
          //             index < AppScreens.screens.length;
          //             index++)
          //           GestureDetector(
          //             onTap: () {
          //               Navigator.pushReplacementNamed(
          //                   context, AppScreens.screens[index]['Route']);
          //             },
          //             child: ListTile(
          //               title: Text(
          //                 AppScreens.screens[index]['Title'],
          //                 style: const TextStyle(
          //                   fontSize: AppConst.appFontSizeh10,
          //                 ),
          //               ),
          //               leading: AppScreens.screens[index]['Icon'],
          //               textColor: AppConst.appColorText,
          //               minLeadingWidth: 10.0,
          //               iconColor: AppConst.appColorText,
          //             ),
          //           ),
          //       ],
          //     ),
          //   ),
          // ),

          // Dynamic Menu
          SizedBox(
            height: screenSize.height * 0.30,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int levelOne = 0;
                      levelOne < dataProvider.rolesData.length;
                      levelOne++)
                    ExpansionTile(
                      title: Text(
                        dataProvider.rolesData[levelOne]['MenuName'],
                        style: const TextStyle(
                          fontSize: AppConst.appFontSizeh10,
                        ),
                      ),
                      leading: const Icon(Icons.dashboard),
                      textColor: AppConst.appColorText,
                      iconColor: AppConst.appColorText,
                      children: <Widget>[
                        for (int levelTwo = 0;
                            levelTwo <
                                dataProvider
                                    .rolesData[levelOne]['MenuChildren'].length;
                            levelTwo++)
                          dataProvider
                                      .rolesData[levelOne]['MenuChildren']
                                          [levelTwo]['MenuChildren']
                                      .length >
                                  0
                              ? ExpansionTile(
                                  title: Text(
                                    dataProvider.rolesData[levelOne]
                                        ['MenuName'],
                                    style: const TextStyle(
                                      fontSize: AppConst.appFontSizeh10,
                                    ),
                                  ),
                                  leading: const Icon(Icons.dashboard),
                                  textColor: AppConst.appColorText,
                                  iconColor: AppConst.appColorText,
                                  children: <Widget>[
                                    for (int levelThree = 0;
                                        levelThree <
                                            dataProvider
                                                .rolesData[levelOne]
                                                    ['MenuChildren'][levelTwo]
                                                    ['MenuChildren']
                                                .length;
                                        levelThree++)
                                      ListTile(
                                        title: Padding(
                                          padding: const EdgeInsets.only(
                                              left: AppConst
                                                  .appMainPaddingMedium),
                                          child: Text(
                                            dataProvider.rolesData[levelOne]
                                                        ['MenuChildren']
                                                    [levelTwo]['MenuChildren']
                                                [levelThree]['FormName'],
                                            style: const TextStyle(
                                              fontSize: AppConst.appFontSizeh10,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          var comp = AppScreens
                                              .screens[levelOne]['Component'];
                                          Navigator.pushReplacement(
                                              context,
                                              CustomPageRouteBuilder
                                                  .createRoute(AppScreens
                                                          .screens[levelOne]
                                                      ['Route']));
                                        },
                                        leading: const Padding(
                                          padding: EdgeInsets.only(
                                              left: AppConst
                                                  .appMainPaddingMedium),
                                          child: Icon(Icons.dashboard_outlined),
                                        ),
                                        textColor: AppConst.appColorText,
                                        minLeadingWidth: 10.0,
                                        iconColor: AppConst.appColorText,
                                      ),
                                  ],
                                )
                              : ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(
                                        left: AppConst.appMainPaddingMedium),
                                    child: Text(
                                      dataProvider.rolesData[levelOne]
                                              ['MenuChildren'][levelTwo]
                                          ['MenuName'],
                                      style: const TextStyle(
                                        fontSize: AppConst.appFontSizeh10,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        CustomPageRouteBuilder.createRoute(
                                            '/${dataProvider.rolesData[levelOne]['MenuChildren'][levelTwo]['FormName']}'));
                                  },
                                  leading: Padding(
                                    padding: const EdgeInsets.only(
                                        left: AppConst.appMainPaddingMedium),
                                    child: dataProvider
                                                .rolesData[levelOne]
                                                    ['MenuChildren'][levelTwo]
                                                    ['FormName']
                                                .length ==
                                            0
                                        ? const Icon(Icons.dashboard_outlined)
                                        : (AppScreens.screenIcons[dataProvider
                                                        .rolesData[levelOne]
                                                    ['MenuChildren'][levelTwo]
                                                ['FormName']] ??
                                            const Icon(
                                                Icons.dashboard_outlined)),
                                  ),
                                  textColor: AppConst.appColorText,
                                  minLeadingWidth: 10.0,
                                  iconColor: AppConst.appColorText,
                                ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          Container(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: AppConst.appMainPaddingLarge,
                    ),
                    child: ListTile(
                      title: const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: AppConst.appFontSizeh10,
                        ),
                      ),
                      leading: const Icon(Icons.settings),
                      onTap: () {
                        Navigator.pushReplacement(context,
                            CustomPageRouteBuilder.createRoute('/settings'));
                      },
                      textColor: AppConst.appColorText,
                      minLeadingWidth: 10.0,
                      iconColor: AppConst.appColorText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: AppConst.appMainPaddingLarge),
                    child: ListTile(
                      onTap: () async {
                        Functions.ShowPopUpDialog(
                          context,
                          'Confirm',
                          SizedBox(
                            width: screenSize.width * 0.65,
                            height: 40.0,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppConst
                                          .appMainPaddingLarge),
                                  child: Text(
                                    'Are you sure?',
                                    style: TextStyle(
                                      fontSize:
                                      AppConst.appFontSizeh9,
                                      fontWeight: AppConst
                                          .appTextFontWeightLight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                              () async {
                                try {
                                  if (userProvider.userData.isNotEmpty) {
                                    ApiResponse response = await AuthenticationService()
                                        .logoutUser(
                                        userProvider.userData['UserId'].toString(),
                                        userProvider.userData['GUID'],
                                        apiProvider.selectedAppKey);
                                    if (response.Data == "success") {
                                      if (mounted) {
                                        Navigator.pushReplacementNamed(
                                            context, '/login');
                                        Functions.ShowSnackBar(context,
                                            'Logged Out Successfully');
                                      }
                                    } else {
                                      if (mounted) {
                                        Navigator.pushReplacementNamed(
                                            context, '/login');
                                        // obtain shared preferences
                                        final prefs = await SharedPreferences.getInstance();
                                        // set value
                                        await prefs.remove('user');
                                        await prefs.remove('appKey');
                                        if (mounted) {
                                          Functions.ShowSnackBar(context,
                                              'Something went wrong, please try again.');
                                        }
                                      }
                                    }
                                  } else {
                                    // obtain shared preferences
                                    final prefs = await SharedPreferences.getInstance();
                                    // set value
                                    await prefs.remove('user');
                                    await prefs.remove('appKey');
                                    if (mounted) {
                                      Functions.ShowSnackBar(
                                          context, 'Logging out failed. No user found.');
                                    }
                                  }
                                } catch (e) {
                                  // obtain shared preferences
                                  final prefs = await SharedPreferences.getInstance();
                                  // set value
                                  await prefs.remove('user');
                                  await prefs.remove('appKey');
                                  if (mounted) {
                                    Functions.ShowSnackBar(context,
                                        'Something went wrong, please try again.');
                                  }
                                }
                          },
                          true,
                          isHeader: true,
                          isCloseBtn: true,
                        );
                      },
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: AppConst.appFontSizeh10,
                        ),
                      ),
                      leading: const Icon(Icons.logout),
                      textColor: AppConst.appColorText,
                      minLeadingWidth: 10.0,
                      iconColor: AppConst.appColorText,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
