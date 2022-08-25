import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_app_development/DataLayer/Providers/FiltersProvider/filterProviders.dart';
import 'package:ts_app_development/DataLayer/Providers/UserProvider/userProvider.dart';
import 'package:ts_app_development/Generic/AppScreens/appScreens.dart';
import 'package:ts_app_development/UserControls/CustomTabBar/customTabBar.dart';
import 'package:ts_app_development/UserControls/SliceContainer/sliceContainer.dart';
import '../../DataLayer/Models/ApiResponse/ApiResponse.dart';
import '../../DataLayer/Providers/DateTimeRangeProvider/dateTimeRangeProvider.dart';
import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../DataLayer/Services/AttendanceService/attendanceService.dart';
import '../../Generic/Functions/functions.dart';
import '../../Generic/appConst.dart';
import '../../UserControls/PopUpDialog/popupDialog.dart';

class MyHistory extends StatefulWidget {
  final String route;
  const MyHistory({
    Key? key,
    required this.route,
  }) : super(key: key);

  @override
  State<MyHistory> createState() => _MyHistoryState();
}

class _MyHistoryState extends State<MyHistory> with TickerProviderStateMixin {
  late TabController tabController;
  List<String> tabsList = [];
  ApiResponse attendanceHistoryDataFuture = ApiResponse();
  List attendanceHistoryData = [];
  List lastMonthData = [];
  List previousMonthData = [];
  List previousMonthBeforeData = [];
  bool isDataLoaded = false;
  bool isErrorGot = false;
  bool isSessionExpired = false;

  @override
  void initState() {
    super.initState();
    isDataLoaded = false;
    isErrorGot = false;
    isSessionExpired = false;
    tabController = TabController(
        vsync: this,
        length: AppScreens.screenTabs[widget.route]['tabs'],
        initialIndex: AppScreens.screenTabs[widget.route]['tabs'] - 1);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UserSessionProvider userProvider =
          Provider.of<UserSessionProvider>(context, listen: false);
      DateTimeRangeProvider dateTime =
          Provider.of<DateTimeRangeProvider>(context, listen: false);
      // Services
      dynamic result = await APICalls(userProvider, dateTime);
      await setTabs(dateTime);
      if (result.length > 0) {
        if (result[0].Data.length > 0) {
          setState(() {
            attendanceHistoryData =
                Functions.convertToListOfObjects(result[0].Data);
            isDataLoaded = true;
            isSessionExpired = false;
            isErrorGot = false;
          });
        } else {
          if (result[0].ApiError['StatusCode'] == 401) {
            setState(() {
              isSessionExpired = true;
              isDataLoaded = false;
              isErrorGot = false;
            });
          } else {
            setState(() {
              isSessionExpired = false;
              isDataLoaded = false;
              isErrorGot = true;
            });
          }
        }
      }
    });
  }

  Future<List<ApiResponse>> APICalls(userProvider, dateTime) async {
    attendanceHistoryDataFuture =
        await AttendanceService.getEmployeeAttendanceHistory({
      'fromDate': dateTime.threeMonthsDateTime.start.toString(),
      'toDate': dateTime.threeMonthsDateTime.end.toString(),
      'EmployeeInformationId': userProvider.userData['EmployeeInformationId'].toString(),
    });

    return [attendanceHistoryDataFuture];
  }

  Future<void> setTabs(DateTimeRangeProvider dateTime) async {
    tabsList = [];
    for (int i = 0; i < AppScreens.screenTabs[widget.route]['tabs']; i++) {
      tabsList.add("0");
    }
    var count = 0;
    // Dynamic Tabs Making
    for (int i = 2; i >= 0; i--) {
      tabsList[i] = AppConst.months[dateTime.dateTime.start!.month - count - 1];
      count += 1;
    }
  }

  setHistoryData(String filter, attendanceHistoryData) {
    if (filter == 'All') {
      // Separating The Data
      setState(() {
        lastMonthData = attendanceHistoryData.where((elem) {
          return elem['AttendanceDate'].toString().contains(
              '${DateTime.now().year}-${Functions.getMonthNumber(DateTime.now().month)}');
        }).toList();
        previousMonthData = attendanceHistoryData.where((elem) {
          return elem['AttendanceDate'].toString().contains(
              '${DateTime.now().year}-${Functions.getMonthNumber(DateTime.now().month - 1)}');
        }).toList();
        previousMonthBeforeData = attendanceHistoryData.where((elem) {
          return elem['AttendanceDate'].toString().contains(
              '${DateTime.now().year}-${Functions.getMonthNumber(DateTime.now().month - 2)}');
        }).toList();
      });
    } else {
      setState(() {
        lastMonthData = attendanceHistoryData.where((elem) {
          return elem['AttendanceDate'].toString().contains(
                  '${DateTime.now().year}-${Functions.getMonthNumber(DateTime.now().month)}') &&
              elem['Status'] == filter;
        }).toList();
        previousMonthData = attendanceHistoryData.where((elem) {
          return elem['AttendanceDate'].toString().contains(
                  '${DateTime.now().year}-${Functions.getMonthNumber(DateTime.now().month - 1)}') &&
              elem['Status'] == filter;
        }).toList();
        previousMonthBeforeData = attendanceHistoryData.where((elem) {
          return elem['AttendanceDate'].toString().contains(
                  '${DateTime.now().year}-${Functions.getMonthNumber(DateTime.now().month - 2)}') &&
              elem['Status'] == filter;
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    tabsList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    FilterProvider filterProvider = Provider.of<FilterProvider>(context);
    // Setting Data
    setHistoryData(filterProvider.selectedFilter, attendanceHistoryData);

    if (isDataLoaded) {
      return Column(
        children: [
          // Custom Tab Bar
          CustomTabBar(
              route: widget.route,
              tabsNotificationList: null,
              tabsList: tabsList,
              tabController: tabController),

          // Rest Data
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                // Previous Before Month
                previousMonthBeforeData.length > 0
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
// the Tabs view
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppConst.appMainBodyVerticalPadding,
                                horizontal: AppConst.appMainPaddingSmall,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    for (var i = 0;
                                        i < previousMonthBeforeData.length;
                                        i++)
                                      Slice(
                                        height: 120.0,
                                        statusColor: AppConst.statusColors[previousMonthBeforeData[i]['Status']],
                                        leftAreaContent: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${DateTime.parse(previousMonthBeforeData[i]['AttendanceDateTime']).day}',
                                              style: const TextStyle(
                                                color: AppConst.appColorWhite,
                                                fontSize:
                                                    AppConst.appFontSizeh8,
                                                fontWeight: AppConst
                                                    .appTextFontWeightBold,
                                              ),
                                            ),
                                            Text(
                                              AppConst.months[DateTime.parse(
                                                          previousMonthBeforeData[
                                                                  i][
                                                              'AttendanceDateTime'])
                                                      .month -
                                                  1],
                                              style: const TextStyle(
                                                color: AppConst.appColorWhite,
                                                fontSize:
                                                    AppConst.appFontSizeh9,
                                                fontWeight: AppConst
                                                    .appTextFontWeightMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                        rightAreaContent: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Time In',
                                                  style: TextStyle(
                                                    fontSize:
                                                        AppConst.appFontSizeh10,
                                                    color: AppConst
                                                        .appColorTextBlack,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightLight,
                                                  ),
                                                ),
                                                Text(
                                                  previousMonthBeforeData[i]
                                                              ['DateTimeIN'] !=
                                                          null
                                                      ? Functions.formatTimeOfDay(
                                                          previousMonthBeforeData[
                                                              i]['DateTimeIN'])
                                                      : '-- : --',
                                                  style: const TextStyle(
                                                    fontSize:
                                                        AppConst.appFontSizeh11,
                                                    color: AppConst
                                                        .appColorTextBlack,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightLight,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Time Out',
                                                  style: TextStyle(
                                                    fontSize:
                                                        AppConst.appFontSizeh10,
                                                    color: AppConst
                                                        .appColorTextBlack,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightLight,
                                                  ),
                                                ),
                                                Text(
                                                  previousMonthBeforeData[i]
                                                              ['DateTimeOut'] !=
                                                          null
                                                      ? Functions.formatTimeOfDay(
                                                          previousMonthBeforeData[
                                                              i]['DateTimeOut'])
                                                      : '-- : --',
                                                  style: const TextStyle(
                                                    fontSize:
                                                        AppConst.appFontSizeh11,
                                                    color: AppConst
                                                        .appColorTextBlack,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightLight,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        onPress: () {
                                          Map<String, dynamic>
                                              attendanceDetail = {
                                            'Date':
                                                '${Functions.getDayNumber(DateTime.parse(previousMonthBeforeData[i]['AttendanceDateTime']).day)}-${Functions.getMonthNumber(DateTime.parse(previousMonthBeforeData[i]['AttendanceDateTime']).month)}-${DateTime.parse(previousMonthBeforeData[i]['AttendanceDateTime']).year}',
                                            'Work Shift':
                                                previousMonthBeforeData[i]
                                                    ['WorkShiftName'],
                                            'In Time': previousMonthBeforeData[
                                                        i]['DateTimeIN'] !=
                                                    null
                                                ? Functions.formatTimeOfDay(
                                                    previousMonthBeforeData[i]
                                                        ['DateTimeIN'])
                                                : '-- : --',
                                            'Out Time': previousMonthBeforeData[
                                                        i]['DateTimeOut'] !=
                                                    null
                                                ? Functions.formatTimeOfDay(
                                                    previousMonthBeforeData[i]
                                                        ['DateTimeOut'])
                                                : '-- : --',
                                            'Status': previousMonthBeforeData[i]
                                                ['Status'],
                                            'Day': previousMonthBeforeData[i]
                                                ['WeekDay'],
                                            'Day Type':
                                                previousMonthBeforeData[i]
                                                    ['DayTypeName'],
                                            'In Status':
                                                previousMonthBeforeData[i]
                                                    ['InStatus'],
                                            'Out Status':
                                                previousMonthBeforeData[i]
                                                    ['OutStatus'],
                                            'Holiday Type':
                                                previousMonthBeforeData[i]
                                                        ['LeaveType'] ??
                                                    '-- : --',
                                          };
                                          Functions.ShowPopUpDialog(
                                            context,
                                            'Attendance Details',
                                            SizedBox(
                                              width: screenSize.width * 0.8,
                                              height: screenSize.height * 0.6,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          attendanceDetail
                                                              .keys.length;
                                                      i++)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: AppConst
                                                              .appMainPaddingSmall),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            attendanceDetail
                                                                .keys
                                                                .toList()[i],
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh10,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightMedium),
                                                          ),
                                                          Text(
                                                            attendanceDetail
                                                                .values
                                                                .toList()[i],
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh10,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            () {},
                                            false,
                                            isHeader: true,
                                            isCloseBtn: true,
                                          );
                                        },
                                        isSelected:
                                            '${DateTime.parse(previousMonthBeforeData[i]['AttendanceDateTime']).year}-${DateTime.parse(previousMonthBeforeData[i]['AttendanceDateTime']).month}-${DateTime.parse(previousMonthBeforeData[i]['AttendanceDateTime']).day}' ==
                                                '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Text(
                          'No Data',
                          style: TextStyle(
                              fontSize: AppConst.appFontSizeh9,
                              fontWeight: AppConst.appTextFontWeightMedium),
                        ),
                      ),
                // Previous Month
                previousMonthData.length > 0
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
// the Tabs view
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppConst.appMainBodyVerticalPadding,
                                horizontal: AppConst.appMainPaddingSmall,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    for (var i = 0;
                                        i < previousMonthData.length;
                                        i++)
                                      Slice(
                                        height: 120.0,
                                        statusColor: AppConst.statusColors[previousMonthData[i]['Status']],
                                        leftAreaContent: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${DateTime.parse(previousMonthData[i]['AttendanceDateTime']).day}',
                                              style: const TextStyle(
                                                color: AppConst.appColorWhite,
                                                fontSize:
                                                    AppConst.appFontSizeh8,
                                                fontWeight: AppConst
                                                    .appTextFontWeightBold,
                                              ),
                                            ),
                                            Text(
                                              AppConst.months[DateTime.parse(
                                                          previousMonthData[i][
                                                              'AttendanceDateTime'])
                                                      .month -
                                                  1],
                                              style: const TextStyle(
                                                color: AppConst.appColorWhite,
                                                fontSize:
                                                    AppConst.appFontSizeh9,
                                                fontWeight: AppConst
                                                    .appTextFontWeightMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                        rightAreaContent: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Time In',
                                                  style: TextStyle(
                                                    fontSize:
                                                        AppConst.appFontSizeh10,
                                                    color: AppConst
                                                        .appColorTextBlack,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightLight,
                                                  ),
                                                ),
                                                Text(
                                                  previousMonthData[i]
                                                              ['DateTimeIN'] !=
                                                          null
                                                      ? Functions
                                                          .formatTimeOfDay(
                                                              previousMonthData[
                                                                      i][
                                                                  'DateTimeIN'])
                                                      : '-- : --',
                                                  style: const TextStyle(
                                                    fontSize:
                                                        AppConst.appFontSizeh11,
                                                    color: AppConst
                                                        .appColorTextBlack,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightLight,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Time Out',
                                                  style: TextStyle(
                                                    fontSize:
                                                        AppConst.appFontSizeh10,
                                                    color: AppConst
                                                        .appColorTextBlack,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightLight,
                                                  ),
                                                ),
                                                Text(
                                                  previousMonthData[i]
                                                              ['DateTimeOut'] !=
                                                          null
                                                      ? Functions
                                                          .formatTimeOfDay(
                                                              previousMonthData[
                                                                      i][
                                                                  'DateTimeOut'])
                                                      : '-- : --',
                                                  style: const TextStyle(
                                                    fontSize:
                                                        AppConst.appFontSizeh11,
                                                    color: AppConst
                                                        .appColorTextBlack,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightLight,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        onPress: () {
                                          Map<String, dynamic>
                                              attendanceDetail = {
                                            'Date':
                                                '${Functions.getDayNumber(DateTime.parse(previousMonthData[i]['AttendanceDateTime']).day)}-${Functions.getMonthNumber(DateTime.parse(previousMonthData[i]['AttendanceDateTime']).month)}-${DateTime.parse(previousMonthData[i]['AttendanceDateTime']).year}',
                                            'Work Shift': previousMonthData[i]
                                                ['WorkShiftName'],
                                            'In Time': previousMonthData[i]
                                                        ['DateTimeIN'] !=
                                                    null
                                                ? Functions.formatTimeOfDay(
                                                    previousMonthData[i]
                                                        ['DateTimeIN'])
                                                : '-- : --',
                                            'Out Time': previousMonthData[i]
                                                        ['DateTimeOut'] !=
                                                    null
                                                ? Functions.formatTimeOfDay(
                                                    previousMonthData[i]
                                                        ['DateTimeOut'])
                                                : '-- : --',
                                            'Status': previousMonthData[i]
                                                ['Status'],
                                            'Day': previousMonthData[i]
                                                ['WeekDay'],
                                            'Day Type': previousMonthData[i]
                                                ['DayTypeName'],
                                            'In Status': previousMonthData[i]
                                                ['InStatus'],
                                            'Out Status': previousMonthData[i]
                                                ['OutStatus'],
                                            'Holiday Type': previousMonthData[i]
                                                    ['LeaveType'] ??
                                                '-- : --',
                                          };
                                          Functions.ShowPopUpDialog(
                                            context,
                                            'Attendance Details',
                                            SizedBox(
                                              width: screenSize.width * 0.8,
                                              height: screenSize.height * 0.6,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          attendanceDetail
                                                              .keys.length;
                                                      i++)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: AppConst
                                                              .appMainPaddingSmall),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            attendanceDetail
                                                                .keys
                                                                .toList()[i],
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh10,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightMedium),
                                                          ),
                                                          Text(
                                                            attendanceDetail
                                                                .values
                                                                .toList()[i],
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh10,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            () {},
                                            false,
                                            isHeader: true,
                                            isCloseBtn: true,
                                          );
                                        },
                                        isSelected:
                                            '${DateTime.parse(previousMonthData[i]['AttendanceDateTime']).year}-${DateTime.parse(previousMonthData[i]['AttendanceDateTime']).month}-${DateTime.parse(previousMonthData[i]['AttendanceDateTime']).day}' ==
                                                '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Text(
                          'No Data',
                          style: TextStyle(
                              fontSize: AppConst.appFontSizeh9,
                              fontWeight: AppConst.appTextFontWeightMedium),
                        ),
                      ),
                // Current Month
                lastMonthData.length > 0
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
// the Tabs view
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppConst.appMainBodyVerticalPadding,
                                horizontal: AppConst.appMainPaddingSmall,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    for (var i = 0;
                                        i < lastMonthData.length;
                                        i++)
                                      Slice(
                                        height: 120.0,
                                        statusColor: AppConst.statusColors[lastMonthData[i]['Status']],
                                        leftAreaContent: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${DateTime.parse(lastMonthData[i]['AttendanceDateTime']).day}',
                                              style: const TextStyle(
                                                color: AppConst.appColorWhite,
                                                fontSize:
                                                    AppConst.appFontSizeh8,
                                                fontWeight: AppConst
                                                    .appTextFontWeightBold,
                                              ),
                                            ),
                                            Text(
                                              AppConst.months[DateTime.parse(
                                                          lastMonthData[i][
                                                              'AttendanceDateTime'])
                                                      .month -
                                                  1],
                                              style: const TextStyle(
                                                color: AppConst.appColorWhite,
                                                fontSize:
                                                    AppConst.appFontSizeh9,
                                                fontWeight: AppConst
                                                    .appTextFontWeightMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                        rightAreaContent: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Time In',
                                                  style: TextStyle(
                                                    fontSize:
                                                        AppConst.appFontSizeh10,
                                                    color: AppConst
                                                        .appColorTextBlack,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightLight,
                                                  ),
                                                ),
                                                Text(
                                                  lastMonthData[i]
                                                              ['DateTimeIN'] !=
                                                          null
                                                      ? Functions
                                                          .formatTimeOfDay(
                                                              lastMonthData[i][
                                                                  'DateTimeIN'])
                                                      : '-- : --',
                                                  style: const TextStyle(
                                                    fontSize:
                                                        AppConst.appFontSizeh11,
                                                    color: AppConst
                                                        .appColorTextBlack,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightLight,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Time Out',
                                                  style: TextStyle(
                                                    fontSize:
                                                        AppConst.appFontSizeh10,
                                                    color: AppConst
                                                        .appColorTextBlack,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightLight,
                                                  ),
                                                ),
                                                Text(
                                                  lastMonthData[i]
                                                              ['DateTimeOut'] !=
                                                          null
                                                      ? Functions
                                                          .formatTimeOfDay(
                                                              lastMonthData[i][
                                                                  'DateTimeOut'])
                                                      : '-- : --',
                                                  style: const TextStyle(
                                                    fontSize:
                                                        AppConst.appFontSizeh11,
                                                    color: AppConst
                                                        .appColorTextBlack,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightLight,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        onPress: () {
                                          Map<String, dynamic>
                                              attendanceDetail = {
                                            'Date':
                                                '${Functions.getDayNumber(DateTime.parse(lastMonthData[i]['AttendanceDateTime']).day)}-${Functions.getMonthNumber(DateTime.parse(lastMonthData[i]['AttendanceDateTime']).month)}-${DateTime.parse(lastMonthData[i]['AttendanceDateTime']).year}',
                                            'Work Shift': lastMonthData[i]
                                                ['WorkShiftName'],
                                            'In Time': lastMonthData[i]
                                                        ['DateTimeIN'] !=
                                                    null
                                                ? Functions.formatTimeOfDay(
                                                    lastMonthData[i]
                                                        ['DateTimeIN'])
                                                : '-- : --',
                                            'Out Time': lastMonthData[i]
                                                        ['DateTimeOut'] !=
                                                    null
                                                ? Functions.formatTimeOfDay(
                                                    lastMonthData[i]
                                                        ['DateTimeOut'])
                                                : '-- : --',
                                            'Status': lastMonthData[i]
                                                ['Status'],
                                            'Day': lastMonthData[i]['WeekDay'],
                                            'Day Type': lastMonthData[i]
                                                ['DayTypeName'],
                                            'In Status': lastMonthData[i]
                                                ['InStatus'],
                                            'Out Status': lastMonthData[i]
                                                ['OutStatus'],
                                            'Holiday Type': lastMonthData[i]
                                                    ['LeaveType'] ??
                                                '-- : --',
                                          };
                                          Functions.ShowPopUpDialog(
                                            context,
                                            'Attendance Details',
                                            SizedBox(
                                              width: screenSize.width * 0.8,
                                              height: screenSize.height * 0.6,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          attendanceDetail
                                                              .keys.length;
                                                      i++)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: AppConst
                                                              .appMainPaddingSmall),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            attendanceDetail
                                                                .keys
                                                                .toList()[i],
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh10,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightMedium),
                                                          ),
                                                          Text(
                                                            attendanceDetail
                                                                .values
                                                                .toList()[i],
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh10,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            () {},
                                            false,
                                            isHeader: true,
                                            isCloseBtn: true,
                                          );
                                        },
                                        isSelected:
                                            '${DateTime.parse(lastMonthData[i]['AttendanceDateTime']).year}-${DateTime.parse(lastMonthData[i]['AttendanceDateTime']).month}-${DateTime.parse(lastMonthData[i]['AttendanceDateTime']).day}' ==
                                                '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Text(
                          'No Data',
                          style: TextStyle(
                              fontSize: AppConst.appFontSizeh9,
                              fontWeight: AppConst.appTextFontWeightMedium),
                        ),
                      ),
              ],
            ),
          ),
        ],
      );
    } else if (isSessionExpired) {
      return PopUpDialog(
        title: 'Session Expired',
        content: IntrinsicHeight(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  // Foreground color
                  onPrimary: AppConst.appColorAccent,
                  // Background color
                  primary: context.read<ThemeProvider>().selectedPrimaryColor,
                  fixedSize: const Size(80, 60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppConst.appButtonsBorderRadiusMed)),
                ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                child: const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: AppConst.appFontSizeh10,
                      fontWeight: AppConst.appTextFontWeightMedium),
                ),
              ),
            ],
          ),
        ),
        onPressYes: () => {},
        isAction: false,
        isCloseBtn: false,
        isHeader: true,
      );
    } else if (isErrorGot) {
      return PopUpDialog(
        title: 'Something went wrong',
        content: IntrinsicHeight(
          child: Column(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: Icon(
                  size: AppConst.appFontSizeh5,
                  Icons.error_outline_rounded,
                  color: context.read<ThemeProvider>().selectedPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        onPressYes: () => {},
        isAction: false,
        isCloseBtn: false,
        isHeader: false,
      );
    } else {
      return PopUpDialog(
        title: 'Awaiting Result',
        content: IntrinsicHeight(
          child: Column(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(color: context.read<ThemeProvider>().selectedPrimaryColor,),
              ),
            ],
          ),
        ),
        onPressYes: () => {},
        isAction: false,
        isCloseBtn: false,
        isHeader: false,
      );
    }
  }
}
