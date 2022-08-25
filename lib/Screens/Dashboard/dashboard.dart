// ignore_for_file: unused_field, unused_local_variable, non_constant_identifier_names, avoid_print, unused_element, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ts_app_development/DataLayer/Models/ApiResponse/ApiResponse.dart';
import 'package:ts_app_development/DataLayer/Providers/DataProvider/dataProvider.dart';
import 'package:ts_app_development/DataLayer/Providers/UserProvider/userProvider.dart';
import 'package:ts_app_development/DataLayer/Services/AttendanceService/attendanceService.dart';
import 'package:ts_app_development/UserControls/InfoContainer/infoContainer.dart';
import 'package:ts_app_development/UserControls/PopUpDialog/popupDialog.dart';
import 'package:ts_app_development/WaitersOrder/orders.dart';
import '../../DataLayer/Providers/DateTimeRangeProvider/dateTimeRangeProvider.dart';
import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/Functions/functions.dart';
import '../../Generic/appConst.dart';
import '../../UserControls/SliceContainer/sliceContainer.dart';

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ApiResponse attendanceSummaryDataFuture = ApiResponse();
  ApiResponse attendanceStatusDataFuture = ApiResponse();
  ApiResponse attendanceHistoryDataFuture = ApiResponse();
  List<dynamic> attendanceSummaryData = [];
  List<dynamic> attendanceStatusData = [];
  List<dynamic> attendanceHistoryData = [];
  bool isDataLoaded = false;
  bool isErrorGot = false;
  bool isSessionExpired = false;
  List<ChartData> pieChartData = [];
  List<ChartData> barChartData = [];

  String? _timeString;
  String? _timeStringtwo;
  String? _timeStringthree;

  // void _getTime() {
  //   // final String formattedDateTime =
  //   //     DateFormat.MMMMd('yyyy-MM-dd \n kk:mm:ss').format(DateTime.now()).toString();

  //       DateFormat formatter =DateFormat('EEEE, d MMM, yyyy');
  //       String date = formatter.format((attendanceHistoryData[9][attendanceHistoryData[9]['AttendanceDateTime']]));
  //       var dateSplit = date.split(',');

  //        print(attendanceHistoryData[0]['AttendanceDateTime']);

  //   setState(() {
  //     _timeString = date;
  //     _timeStringtwo = dateSplit[0];
  //     _timeStringthree = dateSplit[1];

  //     print('Hello$date');

  //   });
  // }

      void _getTime() {
    // final String formattedDateTime =
    //     DateFormat.MMMMd('yyyy-MM-dd \n kk:mm:ss').format(DateTime.now()).toString();

        DateFormat formatter =DateFormat.MMMEd('en_US');
        String date = formatter.format(DateTime.now()).toString();
        var dateSplit = date.split(',');
        
    setState(() {
      _timeString = dateSplit[0];
      _timeStringtwo = dateSplit[1];
      _timeStringthree = date;
      

      
     
    });
  }
  static String formatTimeOfDayone(String date) {
    final now = DateTime.parse(date);
    final dt = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    final format = DateFormat.jms(); //"6:00 AM"
    return format.format(dt);
  }

  @override
  void initState() {
    isDataLoaded = false;
    isErrorGot = false;
    isSessionExpired = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UserSessionProvider userProvider =
          Provider.of<UserSessionProvider>(context, listen: false);
      DateTimeRangeProvider dateTime =
          Provider.of<DateTimeRangeProvider>(context, listen: false);
      DataProvider dataProvider =
          Provider.of<DataProvider>(context, listen: false);
      // Services
      dynamic result = await APICalls(userProvider, dateTime);
      if (result.length > 0) {
        setState(() {
          if (result[0].Data.length > 0 &&
              result[1].Data.length > 0 &&
              result[2].Data.length > 0) {
            attendanceStatusData =
                Functions.convertToListOfObjects(result[0].Data);
            attendanceSummaryData =
                Functions.convertToListOfObjects(result[1].Data);
            attendanceHistoryData =
                Functions.convertToListOfObjects(result[2].Data);
            dataProvider.setAttendanceData(attendanceStatusData);
            // Pie Chart Making
            for (int i = 0; i < attendanceSummaryData.length; i++) {
              if (attendanceSummaryData[i]['AttendanceType'] ==
                  'Attendance Summary') {
                if (attendanceSummaryData[i]['AttendanceStatus'] != 'Total' &&
                    attendanceSummaryData[i]['Summary'] != '0') {
                  pieChartData.add(ChartData(
                      attendanceSummaryData[i]['AttendanceStatus'],
                      double.parse(attendanceSummaryData[i]['Summary']),
                      AppConst.statusColors[attendanceSummaryData[i]
                              ['AttendanceStatus']] ??
                          AppConst.appColorSeparator));
                }
              }
            }

            // Bar Chart Making
            for (int i = 0; i < attendanceSummaryData.length; i++) {
              if (attendanceSummaryData[i]['AttendanceType'] ==
                  'Punctuality Summary') {
                if (attendanceSummaryData[i]['Summary'] != '00:00' &&
                    attendanceSummaryData[i]['Summary'] != '0' &&
                    attendanceSummaryData[i]['AttendanceStatus'] !=
                        'Over Time') {
                  barChartData.add(ChartData(
                      attendanceSummaryData[i]['AttendanceStatus'],
                      double.parse(attendanceSummaryData[i]['Summary']),
                      AppConst.statusColors[attendanceSummaryData[i]
                              ['AttendanceStatus']] ??
                          AppConst.appColorSeparator));
                }
              }
            }
            isDataLoaded = true;
            isErrorGot = false;
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
        });
      }
    });
    super.initState();
  }

  Future<List<ApiResponse>> APICalls(userProvider, dateTime) async {
    attendanceStatusDataFuture = await AttendanceService.getAttendanceStatus(
        userProvider.userData['EmployeeInformationId'].toString());
    attendanceSummaryDataFuture =
        await AttendanceService.getEmployeeAttendanceSummary({
      'fromDate': dateTime.dateTime.start.toString(),
      'toDate': dateTime.dateTime.end.toString(),
      'EmployeeInformationId':
          userProvider.userData['EmployeeInformationId'].toString(),
    });
    attendanceHistoryDataFuture =
        await AttendanceService.getEmployeeAttendanceHistory({
      'fromDate': dateTime.dateTime.start.toString(),
      'toDate': dateTime.dateTime.end.toString(),
      'EmployeeInformationId':
          userProvider.userData['EmployeeInformationId'].toString(),
    });

    return [
      attendanceStatusDataFuture,
      attendanceSummaryDataFuture,
      attendanceHistoryDataFuture
    ];
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context);
    DateTimeRangeProvider dateTime =
        Provider.of<DateTimeRangeProvider>(context);
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    var userData = Provider.of<UserSessionProvider>(context);
    if (isDataLoaded) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: AppConst.appMainBodyVerticalPadding,
              horizontal: AppConst.appMainPaddingSmall),
          child: Column(
            children: [
// Working Hours Section
              Padding(
                padding:
                    const EdgeInsets.only(bottom: AppConst.appMainPaddingLarge),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: AppConst.appMainPaddingSmall),
                        child: Text(
                          'Working Hours',
                          style: TextStyle(
                            fontSize: AppConst.appFontSizeh10,
                            color: AppConst.appColorText,
                            fontWeight: AppConst.appTextFontWeightMedium,
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      runSpacing: AppConst.appMainPaddingSmall,
                      spacing: 9.8,
                      alignment: WrapAlignment.start,
                      children: [
                        for (int i = 0; i < attendanceSummaryData.length; i++)
                          if (attendanceSummaryData[i]['AttendanceType'] ==
                              'Working Hours')
                            InfoContainer(
                              time: attendanceSummaryData[i]['Summary'],
                              infoTitle: attendanceSummaryData[i]
                                  ['AttendanceStatus'],
                              tileColor: AppConst.statusColors[
                                      attendanceSummaryData[i]
                                          ['AttendanceStatus']] ??
                                  AppConst.appColorSeparator,
                              onPress: () {},
                            )
                      ],
                    ),
                  ],
                ),
              ),

// Attendance Section
              Padding(
                padding:
                    const EdgeInsets.only(bottom: AppConst.appMainPaddingLarge),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: AppConst.appMainPaddingSmall),
                        child: Text(
                          'Attendance Summary',
                          style: TextStyle(
                            fontSize: AppConst.appFontSizeh10,
                            color: AppConst.appColorText,
                            fontWeight: AppConst.appTextFontWeightMedium,
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      runSpacing: AppConst.appMainPaddingSmall,
                      spacing: 9.8,
                      alignment: WrapAlignment.start,
                      children: [
                        for (int i = 0; i < attendanceSummaryData.length; i++)
                          if (attendanceSummaryData[i]['AttendanceType'] ==
                              'Attendance Summary')
                            InfoContainer(
                              time: attendanceSummaryData[i]['Summary'],
                              infoTitle: attendanceSummaryData[i]
                                  ['AttendanceStatus'],
                              tileColor: AppConst.statusColors[
                                      attendanceSummaryData[i]
                                          ['AttendanceStatus']] ??
                                  AppConst.appColorSeparator,
                              onPress: () {
                                var filteredData = [];
                                
                                if (attendanceSummaryData[i]
                                        ['AttendanceStatus'] ==
                                    'Total') {
                                  filteredData = attendanceHistoryData;
                                  print('Hello');
                                  print(filteredData[i]);
                                  print(filteredData[i]['AttendanceDate']);
                                  print(filteredData[i]['WeekDay']);
                                  print('Time is $_timeStringtwo');
                                  print(DateTime.now());
                                
                              
                                } else {
                                  filteredData =
                                      attendanceHistoryData.where((element) {
                                    if (element['Status'] ==
                                            attendanceSummaryData[i]
                                                ['AttendanceStatus'] ||
                                        element['OutStatus'] ==
                                            attendanceSummaryData[i]
                                                ['AttendanceStatus']) {
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  }).toList();
                                }
                                Functions.ShowPopUpDialog(
                                  context,
                                  attendanceSummaryData[i]['AttendanceStatus'],
                                  filteredData.isNotEmpty
                                      ? SizedBox(
                                          width: screenSize.width * 0.8,
                                          height: screenSize.height * 0.6,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                for (int i = 0;
                                                    i < filteredData.length;
                                                    i++)
                                                  Slice(
                                                    height: 120.0,
                                                    statusColor:
                                                        AppConst.statusColors[
                                                            filteredData[i]
                                                                ['Status']],
                                                    leftAreaContent: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${filteredData[i]['WeekDay']}, ${DateTime.parse(filteredData[i]['AttendanceDateTime']).day}',
                                                          style:
                                                              const TextStyle(
                                                            color: AppConst
                                                                .appColorWhite,
                                                            fontSize: AppConst
                                                                .appFontSizeh10,
                                                            fontWeight: AppConst
                                                                .appTextFontWeightBold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 9,),
                                                        Text(
                                                          AppConst
                                                              .months[DateTime.parse(
                                                                      filteredData[
                                                                              i]
                                                                          [
                                                                          'AttendanceDateTime'])
                                                                  .month -
                                                              1],
                                                          style:
                                                              const TextStyle(
                                                            color: AppConst
                                                                .appColorWhite,
                                                            fontSize: AppConst
                                                                .appFontSizeh10,
                                                            fontWeight: AppConst
                                                                .appTextFontWeightMedium,
                                                          ),
                                                        ),
                                                        // SizedBox(height: 10,),
                                                        // Text(
                                                        //   filteredData[i]['WeekDay'],
                                                        //   style:
                                                        //       const TextStyle(
                                                        //     color: AppConst
                                                        //         .appColorWhite,
                                                        //     fontSize: AppConst
                                                        //         .appFontSizeh10,
                                                        //     fontWeight: AppConst
                                                        //         .appTextFontWeightMedium,
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                    rightAreaContent: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'Time In',
                                                              style: TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh10,
                                                                color: AppConst
                                                                    .appColorTextBlack,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight,
                                                              ),
                                                            ),
                                                            Text(
                                                              filteredData[i][
                                                                          'DateTimeIN'] !=
                                                                      null
                                                                  ? Functions.formatTimeOfDay(
                                                                      filteredData[
                                                                              i]
                                                                          [
                                                                          'DateTimeIN'])
                                                                  : '-- : --',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
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
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'Time Out',
                                                              style: TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh10,
                                                                color: AppConst
                                                                    .appColorTextBlack,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight,
                                                              ),
                                                            ),
                                                            Text(
                                                              filteredData[i][
                                                                          'DateTimeOut'] !=
                                                                      null
                                                                  ? Functions.formatTimeOfDay(
                                                                      filteredData[
                                                                              i]
                                                                          [
                                                                          'DateTimeOut'])
                                                                  : '-- : --',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
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
                                                    onPress: () {},
                                                    isSelected:
                                                        '${DateTime.parse(filteredData[i]['AttendanceDateTime']).year}-${DateTime.parse(filteredData[i]['AttendanceDateTime']).month}-${DateTime.parse(filteredData[i]['AttendanceDateTime']).day}' ==
                                                            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                                                  ),
                                                // HistoryContainer(
                                                //   day: DateTime.parse(
                                                //           filteredData[i][
                                                //               'AttendanceDateTime'])
                                                //       .day,
                                                //   month: AppConst
                                                //       .months[DateTime.parse(
                                                //               filteredData[
                                                //                       i][
                                                //                   'AttendanceDateTime'])
                                                //           .month -
                                                //       1],
                                                //   timeIn: filteredData[i][
                                                //               'DateTimeIN'] !=
                                                //           null
                                                //       ? Functions
                                                //           .formatTimeOfDay(
                                                //               filteredData[
                                                //                       i][
                                                //                   'DateTimeIN'])
                                                //       : '-- : --',
                                                //   timeOut: filteredData[i][
                                                //               'DateTimeOut'] !=
                                                //           null
                                                //       ? Functions
                                                //           .formatTimeOfDay(
                                                //               filteredData[
                                                //                       i][
                                                //                   'DateTimeOut'])
                                                //       : '-- : --',
                                                //   statusColor:
                                                //       AppConst.statusColors[
                                                //           filteredData[i]
                                                //               ['InStatus']],
                                                //   isSelected:
                                                //       '${DateTime.parse(filteredData[i]['AttendanceDateTime']).year}-${DateTime.parse(filteredData[i]['AttendanceDateTime']).month}-${DateTime.parse(filteredData[i]['AttendanceDateTime']).day}' ==
                                                //           '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                                                //   // On Click Function
                                                //   onPressed: () {},
                                                // ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: screenSize.width * 0.8,
                                          height: screenSize.height * 0.6,
                                          child: const Center(
                                            child: Text(
                                              'No Data',
                                              style: TextStyle(
                                                fontSize:
                                                    AppConst.appFontSizeh9,
                                                fontWeight: AppConst
                                                    .appTextFontWeightMedium,
                                              ),
                                            ),
                                          ),
                                        ),
                                  () {},
                                  false,
                                  isCloseBtn: true,
                                  isHeader: true,
                                );
                              },
                            )
                      ],
                    ),
                  ],
                ),
              ),

              // Chart Section
              SfCircularChart(
                  legend: Legend(isVisible: true),
                  series: <CircularSeries>[
                    // Renders doughnut chart
                    DoughnutSeries<ChartData, String>(
                      dataSource: pieChartData,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      animationDuration: 2500,
                      pointColorMapper: (ChartData data, _) => data.color,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                    )
                  ]),

              // Punctuality Section
              Padding(
                padding:
                    const EdgeInsets.only(bottom: AppConst.appMainPaddingLarge),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: AppConst.appMainPaddingSmall),
                        child: Text(
                          'Punctuality Summary',
                          style: TextStyle(
                            fontSize: AppConst.appFontSizeh10,
                            color: AppConst.appColorText,
                            fontWeight: AppConst.appTextFontWeightMedium,
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      runSpacing: AppConst.appMainPaddingSmall,
                      spacing: 9.5,
                      alignment: WrapAlignment.start,
                      children: [
                        for (int i = 0; i < attendanceSummaryData.length; i++)
                          if (attendanceSummaryData[i]['AttendanceType'] ==
                              'Punctuality Summary')
                            InfoContainer(
                              time: attendanceSummaryData[i]['Summary'],
                              infoTitle: attendanceSummaryData[i]
                                  ['AttendanceStatus'],
                              tileColor: AppConst.statusColors[
                                      attendanceSummaryData[i]
                                          ['AttendanceStatus']] ??
                                  AppConst.appColorSeparator,
                              onPress: () {
                                var filteredData = [];
                                if (attendanceSummaryData[i]
                                        ['AttendanceStatus'] ==
                                    'Total') {
                                  filteredData = attendanceHistoryData;
                                } else {
                                  filteredData =
                                      attendanceHistoryData.where((element) {
                                    if (element['InStatus'] ==
                                            attendanceSummaryData[i]
                                                ['AttendanceStatus'] ||
                                        element['OutStatus'] ==
                                            attendanceSummaryData[i]
                                                ['AttendanceStatus']) {
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  }).toList();
                                }
                                Functions.ShowPopUpDialog(
                                  context,
                                  attendanceSummaryData[i]['AttendanceStatus'],
                                  filteredData.isNotEmpty
                                      ? SizedBox(
                                          width: screenSize.width * 0.8,
                                          height: screenSize.height * 0.6,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                for (int inner = 0;
                                                    inner < filteredData.length;
                                                    inner++)
                                                  Slice(
                                                    height: 120.0,
                                                    statusColor: AppConst
                                                            .statusColors[
                                                        attendanceSummaryData[i]
                                                            [
                                                            'AttendanceStatus']],
                                                    leftAreaContent: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${DateTime.parse(filteredData[inner]['AttendanceDateTime']).day}',
                                                          style:
                                                              const TextStyle(
                                                            color: AppConst
                                                                .appColorWhite,
                                                            fontSize: AppConst
                                                                .appFontSizeh8,
                                                            fontWeight: AppConst
                                                                .appTextFontWeightBold,
                                                          ),
                                                        ),
                                                        Text(
                                                          AppConst
                                                              .months[DateTime.parse(
                                                                      filteredData[
                                                                              inner]
                                                                          [
                                                                          'AttendanceDateTime'])
                                                                  .month -
                                                              1],
                                                          style:
                                                              const TextStyle(
                                                            color: AppConst
                                                                .appColorWhite,
                                                            fontSize: AppConst
                                                                .appFontSizeh9,
                                                            fontWeight: AppConst
                                                                .appTextFontWeightMedium,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    rightAreaContent: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'Time In',
                                                              style: TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh10,
                                                                color: AppConst
                                                                    .appColorTextBlack,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight,
                                                              ),
                                                            ),
                                                            Text(
                                                              filteredData[inner]
                                                                          [
                                                                          'DateTimeIN'] !=
                                                                      null
                                                                  ? Functions.formatTimeOfDay(
                                                                      filteredData[
                                                                              inner]
                                                                          [
                                                                          'DateTimeIN'])
                                                                  : '-- : --',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
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
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'Time Out',
                                                              style: TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh10,
                                                                color: AppConst
                                                                    .appColorTextBlack,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight,
                                                              ),
                                                            ),
                                                            Text(
                                                              filteredData[inner]
                                                                          [
                                                                          'DateTimeOut'] !=
                                                                      null
                                                                  ? Functions.formatTimeOfDay(
                                                                      filteredData[
                                                                              inner]
                                                                          [
                                                                          'DateTimeOut'])
                                                                  : '-- : --',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
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
                                                    onPress: () {},
                                                    isSelected:
                                                        '${DateTime.parse(filteredData[inner]['AttendanceDateTime']).year}-${DateTime.parse(filteredData[inner]['AttendanceDateTime']).month}-${DateTime.parse(filteredData[inner]['AttendanceDateTime']).day}' ==
                                                            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                                                  ),
                                                // HistoryContainer(
                                                //   day: DateTime.parse(
                                                //           filteredData[i][
                                                //               'AttendanceDateTime'])
                                                //       .day,
                                                //   month: AppConst
                                                //       .months[DateTime.parse(
                                                //               filteredData[
                                                //                       i][
                                                //                   'AttendanceDateTime'])
                                                //           .month -
                                                //       1],
                                                //   timeIn: filteredData[i][
                                                //               'DateTimeIN'] !=
                                                //           null
                                                //       ? Functions
                                                //           .formatTimeOfDay(
                                                //               filteredData[
                                                //                       i][
                                                //                   'DateTimeIN'])
                                                //       : '-- : --',
                                                //   timeOut: filteredData[i][
                                                //               'DateTimeOut'] !=
                                                //           null
                                                //       ? Functions
                                                //           .formatTimeOfDay(
                                                //               filteredData[
                                                //                       i][
                                                //                   'DateTimeOut'])
                                                //       : '-- : --',
                                                //   statusColor:
                                                //       AppConst.statusColors[
                                                //           filteredData[i]
                                                //               ['InStatus']],
                                                //   isSelected:
                                                //       '${DateTime.parse(filteredData[i]['AttendanceDateTime']).year}-${DateTime.parse(filteredData[i]['AttendanceDateTime']).month}-${DateTime.parse(filteredData[i]['AttendanceDateTime']).day}' ==
                                                //           '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                                                //   // On Click Function
                                                //   onPressed: () {},
                                                // ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: screenSize.width * 0.8,
                                          height: screenSize.height * 0.6,
                                          child: const Center(
                                            child: Text(
                                              'No Data',
                                              style: TextStyle(
                                                fontSize:
                                                    AppConst.appFontSizeh9,
                                                fontWeight: AppConst
                                                    .appTextFontWeightMedium,
                                              ),
                                            ),
                                          ),
                                        ),
                                  () {},
                                  false,
                                  isCloseBtn: true,
                                  isHeader: true,
                                );
                              },
                            )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: AppConst.appMainPaddingLarge),
                      child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          series: <ChartSeries>[
                            // Renders bar chart
                            StackedColumnSeries<ChartData, String>(
                                dataSource: barChartData,
                                animationDuration: 2500,
                                pointColorMapper: (ChartData data, _) =>
                                    data.color,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y)
                          ]),
                    ),


                    // Container(
                    //   height: 100,
                    //   width: 100,
                    //   color: Colors.amber,
                    //   child: ElevatedButton(onPressed: (){
                    //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(title: 'Order')));
                    //   } ,
                    //   child: Center(child: Text('Point of sell' , style: TextStyle(fontSize: 20),)),),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
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
                child: CircularProgressIndicator(
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
    }
  }
}
