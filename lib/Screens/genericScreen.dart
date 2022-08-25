import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_app_development/DataLayer/Providers/DateTimeRangeProvider/dateTimeRangeProvider.dart';
import 'package:ts_app_development/DataLayer/Providers/FiltersProvider/filterProviders.dart';
import 'package:ts_app_development/Screens/FAQ/faq.dart';
import 'package:ts_app_development/Screens/MarkAttendance/markAttendance.dart';
import 'package:ts_app_development/Screens/MyHistory/myHistory.dart';
import 'package:ts_app_development/Screens/OrderStatus/orderStatus.dart';
import 'package:ts_app_development/Screens/Payroll/payroll.dart';
import 'package:ts_app_development/Screens/Settings/settings.dart';
import 'package:ts_app_development/Screens/UpdatePassword/updatePassword.dart';
import 'package:ts_app_development/UserControls/AppDrawer/appDrawer.dart';
import '../DataLayer/Providers/LocationProvider/location.dart';
import '../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../Generic/Functions/functions.dart';
import '../Generic/appConst.dart';
import '../UserControls/PopUpDialog/popupDialog.dart';
import 'About/about.dart';
import 'Dashboard/dashboard.dart';

class GenericScreen extends StatefulWidget {
  String route;
  String? title;
  GenericScreen({
    Key? key,
    required this.route,
    this.title,
  }) : super(key: key);

  @override
  State<GenericScreen> createState() => _GenericScreenState();
}

class _GenericScreenState extends State<GenericScreen>
    with TickerProviderStateMixin {
  LocationIdentifier location = LocationIdentifier();
  late TextEditingController _controllerDate;
  dynamic component = const Dashboard();
  DateTime result = DateTime.now();
  int dropDownValue = DateTime.now().year;
  String calendarMonthValue = '01';
  int monthSelectedIndex = 0;
  bool isDataLoaded = false;
  bool isLocationMock = false;

  handleScreens(routeName) {
    if (routeName == '/Dashboard') {
      // print(routeName);
      widget.route = routeName;
      return const Dashboard();
    } else if (routeName == '/MarkAttendanceNew') {
      // print(routeName);
      widget.route = routeName;
      return const MarkAttendance();
    } else if (routeName == '/TimeAndAttendance') {
      // print(routeName);
      widget.route = routeName;
      return MyHistory(
        route: routeName,
      );
    } else if (routeName == '/settings') {
      // print(routeName);
      widget.route = routeName;
      return const Settings();
    } else if (routeName == '/updatePassword') {
      // print(routeName);
      widget.route = routeName;
      return const UpdatePasswordScreen();
    } else if (routeName == '/EmployeePayroll') {
      // print(routeName);
      widget.route = routeName;
      return const Payroll();
    } else if (routeName == '/about') {
      // print(routeName);
      widget.route = routeName;
      return const About();
    } else if (routeName == '/faq') {
      // print(routeName);
      widget.route = routeName;
      return const FAQScreen();
    } else if (routeName == '/OrderDeliveryStatus') {
      // print(routeName);
      widget.route = routeName;
      return OrderStatus(
        route: routeName,
      );
    } else {
      widget.route = '/Dashboard';
      return const Dashboard();
    }
  }

  @override
  initState() {
    super.initState();
    isLocationMock = false;
    _controllerDate = TextEditingController(text: DateTime.now().toString());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      location = Provider.of<LocationIdentifier>(context, listen: false);
      await location.getLocation();
      if (mounted) {
        DateTimeRangeProvider dateTime =
            Provider.of<DateTimeRangeProvider>(context, listen: false);
        calendarMonthValue =
            Functions.getMonthNumber(dateTime.dateTime.end!.month);
        monthSelectedIndex = dateTime.dateTime.end!.month - 1;
        setState(() {
          isLocationMock = location.isLocationMock;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    DateTimeRangeProvider dateTimeRangeProvider =
        Provider.of<DateTimeRangeProvider>(context);
    FilterProvider filterProvider = Provider.of<FilterProvider>(context);
    if (isLocationMock == false) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConst.appColorAccent,
            foregroundColor: AppConst.appColorText,
            title: Text(
              widget.title ?? Functions.getAppTitle(widget.route),
            ),
            centerTitle: true,
            elevation: 0.0,
            actions: [
              // Date Range Picker
              widget.route == '/OrderDeliveryStatus'
                  ? ElevatedButton(
                      onPressed: () async {
                        DateTimeRange? result = await showDateRangePicker(
                          context: context,
                          firstDate:
                              DateTime(2022, 1, 1), // the earliest allowable
                          lastDate:
                              DateTime(2030, 12, 31), // the latest allowable
                          currentDate: DateTime.now(),
                          saveText: 'Done',
                        );
                        if (result != null) {
                          dateTimeRangeProvider.setCustomDate(
                              result.start, result.end);
                          if (mounted) {
                            Navigator.pushReplacementNamed(
                                context, widget.route);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        // Foreground color
                        onPrimary: AppConst.appColorText,
                        // Background color
                        primary: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppConst.appButtonsBorderRadiusMed)),
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      child: const Icon(Icons.calendar_today),
                    )
                  : Container(),

              // Calendar Button
              widget.route == '/Dashboard'
                  ? ElevatedButton(
                      onPressed: () async {
                        List yearList = [];
                        var currentYear = DateTime.now().year;
                        for (int i = currentYear - 4; i <= currentYear; i++) {
                          yearList.add(i);
                        }
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return SimpleDialog(
                                children: [
                                  SizedBox(
                                    height: 430.0,
                                    width: 300.0,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        AppConst.appMainPaddingSmall,
                                        0.0,
                                        AppConst.appMainPaddingSmall,
                                        0.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 200.0,
                                            color: context
                                                .read<ThemeProvider>()
                                                .selectedPrimaryColor,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconButton(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      icon: const Icon(
                                                        Icons.close,
                                                        color: AppConst
                                                            .appColorWhite,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        dateTimeRangeProvider
                                                            .setDateTime(
                                                                DateTime.parse(
                                                                    '$dropDownValue-$calendarMonthValue-01T00:00:00'));
                                                        Navigator
                                                            .pushReplacementNamed(
                                                                context,
                                                                widget.route);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        // Foreground color
                                                        onPrimary: AppConst
                                                            .appColorWhite,
                                                        // Background color
                                                        primary:
                                                            Colors.transparent,
                                                      ).copyWith(
                                                          elevation:
                                                              ButtonStyleButton
                                                                  .allOrNull(
                                                                      0.0)),
                                                      child: const Text("Done"),
                                                    ),
                                                  ],
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: AppConst
                                                          .appMainPaddingMedium),
                                                  child: Text(
                                                    'Select Date',
                                                    style: TextStyle(
                                                      color: AppConst
                                                          .appColorWhite,
                                                      fontSize: AppConst
                                                          .appFontSizeh8,
                                                      fontWeight: AppConst
                                                          .appTextFontWeightMedium,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: AppConst
                                                              .appMainPaddingMedium),
                                                      child: SizedBox(
                                                        width: 80.0,
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child:
                                                              DropdownButtonFormField<
                                                                  int>(
                                                            style:
                                                                const TextStyle(
                                                              color: AppConst
                                                                  .appColorWhite,
                                                              fontSize: AppConst
                                                                  .appFontSizeh10,
                                                              fontWeight: AppConst
                                                                  .appTextFontWeightLight,
                                                            ),
                                                            focusColor: context
                                                                .read<
                                                                    ThemeProvider>()
                                                                .selectedPrimaryColor,
                                                            iconEnabledColor:
                                                                AppConst
                                                                    .appColorWhite,
                                                            dropdownColor: context
                                                                .read<
                                                                    ThemeProvider>()
                                                                .selectedPrimaryColor,
                                                            // underline: Container(),
                                                            value:
                                                                dropDownValue,
                                                            isExpanded: true,

                                                            items: yearList.map<
                                                                DropdownMenuItem<
                                                                    int>>((dynamic
                                                                items) {
                                                              return DropdownMenuItem<
                                                                  int>(
                                                                value: items,
                                                                child: Text(
                                                                    '$items'),
                                                              );
                                                            }).toList(),
                                                            onChanged: (val) {
                                                              setState(() {
                                                                dropDownValue =
                                                                    val!;
                                                              });
                                                            },
                                                            onSaved: (val) {
                                                              setState(() {
                                                                dropDownValue =
                                                                    val!;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Center(
                                            child: SizedBox(
                                              height: 230.0,
                                              width: 250.0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: AppConst
                                                        .appMainPaddingMedium),
                                                child: GridView.count(
                                                  childAspectRatio: 2 / 2,
                                                  crossAxisSpacing: 60,
                                                  mainAxisSpacing: 10,
                                                  crossAxisCount: 3,
                                                  children: List.generate(
                                                      AppConst.months.length,
                                                      (index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          monthSelectedIndex =
                                                              index;
                                                          calendarMonthValue =
                                                              Functions
                                                                  .getMonthNumber(
                                                                      index +
                                                                          1);
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 80.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: monthSelectedIndex ==
                                                                  index
                                                              ? context
                                                                  .read<
                                                                      ThemeProvider>()
                                                                  .selectedPrimaryColor
                                                              : AppConst
                                                                  .appColorWhite,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            AppConst
                                                                .months[index],
                                                            style: TextStyle(
                                                              color: monthSelectedIndex == index
                                                                  ? AppConst
                                                                      .appColorWhite
                                                                  : context
                                                                      .read<
                                                                          ThemeProvider>()
                                                                      .selectedPrimaryColor,
                                                              fontSize: AppConst
                                                                  .appFontSizeh10,
                                                              fontWeight: AppConst
                                                                  .appTextFontWeightMedium,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                          },
                          barrierDismissible: false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        // Foreground color
                        onPrimary: AppConst.appColorText,
                        // Background color
                        primary: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppConst.appButtonsBorderRadiusMed)),
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      child: const Icon(Icons.calendar_today),
                    )
                  : Container(),

              // Filter Button
              widget.route == '/TimeAndAttendance'
                  ? ElevatedButton(
                      onPressed: () async {
                        Functions.ShowPopUpDialog(
                          context,
                          'Select Attendance Status',
                          SizedBox(
                            height: screenSize.height * 0.55,
                            width: screenSize.height * 0.4,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          AppConst.attendanceStatus.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(AppConst
                                                        .appButtonsBorderRadiusSam)),
                                            tileColor: AppConst.statusColors[
                                                AppConst
                                                    .attendanceStatus[index]],
                                            title: Text(
                                              AppConst.attendanceStatus[index],
                                              style: const TextStyle(
                                                color: AppConst.appColorBlack,
                                                fontSize:
                                                    AppConst.appFontSizeh10,
                                              ),
                                            ),
                                            onTap: () {
                                              filterProvider.setFilter(AppConst
                                                  .attendanceStatus[index]);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                          () {},
                          false,
                          isHeader: true,
                          isCloseBtn: true,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        // Foreground color
                        onPrimary: AppConst.appColorText,
                        // Background color
                        primary: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppConst.appButtonsBorderRadiusMed)),
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      child: const Icon(Icons.filter_alt_outlined),
                    )
                  : Container(),

              // Date Range Picker
              widget.route == '/about' || widget.route == '/faq'
                  ? ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        // Foreground color
                        onPrimary: AppConst.appColorText,
                        // Background color
                        primary: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppConst.appButtonsBorderRadiusMed)),
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      child: const Icon(Icons.arrow_back),
                    )
                  : Container(),
            ],
          ),
          drawer: const AppDrawer(),
          // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          // floatingActionButton: widget.route != '/MarkAttendanceNew'
          //     ? Stack(
          //         fit: StackFit.expand,
          //         children: [
          //           Positioned(
          //             bottom: 20,
          //             right: 70,
          //             child: FloatingActionButton(
          //               heroTag: "hist",
          //               backgroundColor: context.read<ThemeProvider>().selectedPrimaryColor,
          //               child: const Icon(Icons.history),
          //               onPressed: () {
          //                 Navigator.pushReplacementNamed(context, '/myHistory');
          //               },
          //             ),
          //           ),
          //           Positioned(
          //             bottom: 20,
          //             right: 0,
          //             child: FloatingActionButton(
          //               heroTag: "mark",
          //               backgroundColor: context.read<ThemeProvider>().selectedPrimaryColor,
          //               child: const Icon(Icons.add),
          //               onPressed: () {
          //                 Navigator.pushReplacementNamed(
          //                     context, '/MarkAttendanceNew');
          //               },
          //             ),
          //           )
          //         ],
          //       )
          //     : Container(),
          body: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  textScaleFactor: Functions.getScaleFactor(screenSize)),
              child: handleScreens(widget.route)));
    } else {
      return Scaffold(
        body: PopUpDialog(
          title: 'Mock Location',
          content: IntrinsicHeight(
            child: Column(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(
                    size: AppConst.appFontSizeh5,
                    Icons.location_off_sharp,
                    color: context.read<ThemeProvider>().selectedPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          onPressYes: () => {},
          isAction: false,
          isCloseBtn: false,
          isHeader: true,
        ),
      );
    }
  }
}
