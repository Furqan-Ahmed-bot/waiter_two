import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_app_development/DataLayer/Models/ApiResponse/ApiResponse.dart';
import 'package:ts_app_development/DataLayer/Providers/DateTimeRangeProvider/dateTimeRangeProvider.dart';
import 'package:ts_app_development/DataLayer/Providers/UserProvider/userProvider.dart';
import 'package:ts_app_development/DataLayer/Services/PayrollService/payrollService.dart';
import 'package:intl/intl.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/Functions/functions.dart';
import '../../Generic/appConst.dart';
import '../../UserControls/PopUpDialog/popupDialog.dart';
import '../../UserControls/SliceContainer/sliceContainer.dart';

class Payroll extends StatefulWidget {
  const Payroll({Key? key}) : super(key: key);

  @override
  State<Payroll> createState() => _PayrollState();
}

class _PayrollState extends State<Payroll> {
  ApiResponse payrollDataFuture = ApiResponse();
  ApiResponse payrollDataDetailsFuture = ApiResponse();
  List<dynamic> payrollData = [];
  List<dynamic> payrollDataDetails = [];
  dynamic payrolDetailsGroupedData = {};
  bool isDataLoaded = false;
  bool isErrorGot = false;
  bool isSessionExpired = false;
  bool isDetailsDataLoaded = false;
  bool isErrorGotInDetail = false;

  @override
  void initState() {
    isDataLoaded = false;
    isErrorGot = false;
    isSessionExpired = false;
    isDetailsDataLoaded = false;
    isErrorGotInDetail = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      DateTimeRangeProvider dateTime =
          Provider.of<DateTimeRangeProvider>(context, listen: false);
      UserSessionProvider userProvider =
          Provider.of<UserSessionProvider>(context, listen: false);
      // Services
      dynamic result = await APICalls(userProvider, dateTime);
      if (result.length > 0) {
        if (result.length > 0) {
          setState(() {
            if (result[0].Data.length > 0) {
              payrollData = result[0].Data['Table'];
              isDataLoaded = true;
              isErrorGot = false;
            } else {
              isErrorGot = true;
            }
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
    super.initState();
  }

  Future<List<ApiResponse>> APICalls(userProvider, dateTime) async {
    payrollDataFuture = await PayrollService.getEmployeePayroll([
      {
        'Parameter': 'FromDate',
        'Value2': dateTime.twelveMonthsDateTime.start.toString(),
      },
      {
        'Parameter': 'ToDate',
        'Value2': dateTime.twelveMonthsDateTime.end.toString(),
      },
      {
        'Parameter': 'EmployeeInformationIds',
        'Value2': userProvider.userData['EmployeeInformationId'].toString(),
      },
      {
        'Parameter': 'IsmonthlySummary',
        'Value2': 1,
      },
    ]);
    return [payrollDataFuture];
  }

  Future<List<ApiResponse>> DetailPayrollDetailsAPI(
      userProvider, year, month) async {
    payrollDataDetailsFuture = await PayrollService.getEmployeePayroll([
      {
        'Parameter': 'FromDate',
        'Value2': '$year-${Functions.getMonthNumber(month)}-01T00:00:00',
      },
      {
        'Parameter': 'ToDate',
        'Value2':
            '$year-${Functions.getMonthNumber(month)}-${Functions.getDaysInMonth(DateTime.parse('$year-${Functions.getMonthNumber(month)}-01T00:00:00'))}T00:00:00',
      },
      {
        'Parameter': 'EmployeeInformationIds',
        'Value2': userProvider.userData['EmployeeInformationId'].toString(),
      },
      {
        'Parameter': 'IsmonthlySummary',
        'Value2': 0,
      },
    ]);
    return [payrollDataDetailsFuture];
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat formatNumber = NumberFormat.decimalPattern('en_us');
    Size screenSize = MediaQuery.of(context).size;
    DateTimeRangeProvider dateTime =
        Provider.of<DateTimeRangeProvider>(context);
    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context);

    if (isDataLoaded) {
      if (payrollData.isNotEmpty) {
        return SingleChildScrollView(
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
                      for (int outer = 0; outer < payrollData.length; outer++)
                        Slice(
                          height: 120.0,
                          contentHorizontalPadding:
                          AppConst.appMainPaddingExtraSmall,
                          isSelected: false,
                          leftAreaContent: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppConst.months[payrollData[outer]['Time_Month'] - 1],
                                style: const TextStyle(
                                  color: AppConst.appColorWhite,
                                  fontSize: AppConst.appFontSizeh9,
                                  fontWeight: AppConst.appTextFontWeightBold,
                                ),
                              ),
                              Text(
                                '${payrollData[outer]['Time_Year']}',
                                style: const TextStyle(
                                  color: AppConst.appColorWhite,
                                  fontSize: AppConst.appFontSizeh10,
                                  fontWeight: AppConst.appTextFontWeightMedium,
                                ),
                              ),
                            ],
                          ),
                          rightAreaContent: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Net Salary
                              Container(
                                padding: const EdgeInsets.only(
                                    left: AppConst.appMainPaddingMedium),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Net',
                                      style: TextStyle(
                                        fontSize: AppConst.appFontSizeh10,
                                        color: AppConst.appColorTextBlack,
                                        fontWeight:
                                        AppConst.appTextFontWeightLight,
                                      ),
                                    ),
                                    Text(
                                      formatNumber.format((payrollData[outer]['Earning'] - payrollData[outer]['Deduction'])),
                                      style: const TextStyle(
                                        fontSize: AppConst.appFontSizeh11,
                                        color: AppConst.appColorTextBlack,
                                        fontWeight:
                                        AppConst.appTextFontWeightLight,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // AdvanceAndLoan
                              if ('${payrollData[outer]['AdvanceAndLoan']}' != '0.0')
                                Container(
                                  padding: const EdgeInsets.only(
                                      right: AppConst.appMainPaddingLarge),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Advance',
                                        style: TextStyle(
                                          fontSize: AppConst.appFontSizeh10,
                                          color: AppConst.appColorTextBlack,
                                          fontWeight:
                                          AppConst.appTextFontWeightLight,
                                        ),
                                      ),
                                      Text(
                                        formatNumber.format(payrollData[outer]['AdvanceAndLoan']),
                                        style: const TextStyle(
                                          fontSize: AppConst.appFontSizeh11,
                                          color: AppConst.appColorTextBlack,
                                          fontWeight:
                                          AppConst.appTextFontWeightLight,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              if ('${(payrollData[outer]['Earning'] - payrollData[outer]['Deduction']).toStringAsFixed(2)}' != '${(payrollData[outer]['Earning'] - payrollData[outer]['Deduction'] - payrollData[outer]['AdvanceAndLoan']).toStringAsFixed(2)}')
                                Container(
                                  padding: const EdgeInsets.only(
                                      right: AppConst.appMainPaddingLarge),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Balance',
                                        style: TextStyle(
                                          fontSize: AppConst.appFontSizeh10,
                                          color: AppConst.appColorTextBlack,
                                          fontWeight:
                                          AppConst.appTextFontWeightLight,
                                        ),
                                      ),
                                      Text(
                                        formatNumber.format((payrollData[outer]['Earning'] - payrollData[outer]['Deduction'] - payrollData[outer]['AdvanceAndLoan'])),
                                        style: const TextStyle(
                                          fontSize: AppConst.appFontSizeh11,
                                          color: AppConst.appColorTextBlack,
                                          fontWeight:
                                          AppConst.appTextFontWeightLight,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          onPress: () async {
                            isDetailsDataLoaded = false;
                            isErrorGotInDetail = false;
                            var keysPresent = [];
                            var basicSalary = [];
                            Map<String, double> totalArray = {};
                            Map<String, double> netTotalArray = {};
                            dynamic detailsReturn = await DetailPayrollDetailsAPI(
                                userProvider,
                                payrollData[outer]['Time_Year'],
                                payrollData[outer]['Time_Month']);
                            if (detailsReturn[0].Data.length > 0) {
                              payrollDataDetails = detailsReturn[0].Data['Table'];
                              // TO DO : Remove Ordering When Added From Backend
                              payrollDataDetails.sort((a, b) =>
                                  (a['OrderBy']).compareTo(b['OrderBy']));
                              payrolDetailsGroupedData =
                                  Functions.getGroupedByMap(
                                      payrollDataDetails, 'SalaryGroup');
                              // Keys in Data
                              keysPresent = Functions.getKeysInList(
                                  payrolDetailsGroupedData);
                              // Calculating Total
                              for (int i = 0;
                              i < payrolDetailsGroupedData.length;
                              i++) {
                                var sum = 0.0;
                                for (int j = 0;
                                j <
                                    payrolDetailsGroupedData[i]
                                    [keysPresent[i]]
                                        .length;
                                j++) {
                                  sum += payrolDetailsGroupedData[i]
                                  [keysPresent[i]][j]['Amount'];
                                }
                                totalArray[keysPresent[i]] = sum;
                              }
                              if (totalArray['Earning'] != null &&
                                  totalArray['Deduction'] != null &&
                                  totalArray['AdvanceAndLoanDeduction'] != null) {
                                netTotalArray['NetSalary'] =
                                    (totalArray['Earning'] as double) -
                                        (totalArray['Deduction'] as double);
                                netTotalArray['BalanceSalary'] =
                                    (netTotalArray['NetSalary'] as double) -
                                        (totalArray['AdvanceAndLoanDeduction']
                                        as double);
                              } else if (totalArray['Earning'] != null &&
                                  totalArray['Deduction'] != null) {
                                netTotalArray['NetSalary'] =
                                    (totalArray['Earning'] as double) -
                                        (totalArray['Deduction'] as double);
                                netTotalArray['BalanceSalary'] =
                                netTotalArray['NetSalary']!;
                              }
                              // Basic Salary
                              basicSalary = payrollDataDetails.where((element) {
                                return element['StructureName'] == 'BASIC';
                              }).toList();
                              isDetailsDataLoaded = true;
                              isErrorGotInDetail = false;
                            } else {
                              isDetailsDataLoaded = false;
                              isErrorGotInDetail = true;
                            }
                            if (isDetailsDataLoaded) {
                              if (mounted) {
                                Functions.ShowPopUpDialog(
                                  context,
                                  'Payroll Details ${AppConst.months[DateTime.parse('${payrollDataDetails[0]['PayMonth']}').month - 1]}, ${DateTime.parse('${payrollDataDetails[0]['PayMonth']}').year}',
                                  SizedBox(
                                    width: screenSize.width * 0.8,
                                    height: screenSize.height * 0.6,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Basic Salary
                                          // Padding(
                                          //   padding: const EdgeInsets.only(
                                          //       bottom:
                                          //           AppConst.appMainPaddingLarge),
                                          //   child: Row(
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment.spaceBetween,
                                          //     children: [
                                          //       Text(
                                          //         'Basic Salary',
                                          //         style: const TextStyle(
                                          //           fontSize:
                                          //               AppConst.appFontSizeh8,
                                          //           fontWeight: AppConst
                                          //               .appTextFontWeightLight,
                                          //         ),
                                          //       ),
                                          //       Text(
                                          //         '${basicSalary[0]['Amount']}',
                                          //         style: const TextStyle(
                                          //             fontSize:
                                          //                 AppConst.appFontSizeh8,
                                          //             fontWeight: AppConst
                                          //                 .appTextFontWeightLight),
                                          //       )
                                          //     ],
                                          //   ),
                                          // ),
                                          // Rest Information
                                          for (int outer = 0;
                                          outer <
                                              payrolDetailsGroupedData.length;
                                          outer++)
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: outer > 0
                                                          ? AppConst
                                                          .appMainPaddingLarge
                                                          : 0.0),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: AppConst
                                                            .appMainPaddingMedium,
                                                        horizontal: AppConst
                                                            .appMainPaddingSmall),
                                                    width: double.infinity,
                                                    decoration: const BoxDecoration(
                                                      color: AppConst
                                                          .appColorLightBlue,
                                                    ),
                                                    child: Text(
                                                      '${keysPresent[outer]}',
                                                      style: const TextStyle(
                                                          color: AppConst
                                                              .appColorWhite,
                                                          fontSize: AppConst
                                                              .appFontSizeh9,
                                                          fontWeight: AppConst
                                                              .appTextFontWeightMedium),
                                                    ),
                                                  ),
                                                ),
                                                for (int i = 0;
                                                i < payrollDataDetails.length;
                                                i++)
                                                  keysPresent[outer] ==
                                                      payrollDataDetails[i]
                                                      ['SalaryGroup']
                                                      ? Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: AppConst
                                                            .appMainPaddingSmall),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: AppConst
                                                              .appMainPaddingMedium),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            payrollDataDetails[
                                                            i][
                                                            'StructureName'],
                                                            style:
                                                            const TextStyle(
                                                              fontSize: AppConst
                                                                  .appFontSizeh11,
                                                              fontWeight: AppConst
                                                                  .appTextFontWeightLight,
                                                            ),
                                                          ),
                                                          Text(
                                                            formatNumber.format(payrollDataDetails[i]['Amount']),
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight:
                                                                AppConst
                                                                    .appTextFontWeightLight),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                      : Container(),

                                                // Total Row
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: AppConst
                                                          .appMainPaddingLarge,
                                                      horizontal: AppConst
                                                          .appMainPaddingMedium),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Total',
                                                        style: TextStyle(
                                                            fontSize: AppConst
                                                                .appFontSizeh9,
                                                            fontWeight: AppConst
                                                                .appTextFontWeightMedium),
                                                      ),
                                                      Text(
                                                        formatNumber.format(totalArray[keysPresent[outer]]),
                                                        style: const TextStyle(
                                                            fontSize: AppConst
                                                                .appFontSizeh9,
                                                            fontWeight: AppConst
                                                                .appTextFontWeightMedium),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          // Totals
                                          // Net Salary
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom:
                                                AppConst.appMainPaddingLarge),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Net Salary',
                                                  style: const TextStyle(
                                                    fontSize:
                                                    AppConst.appFontSizeh10,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightLight,
                                                  ),
                                                ),
                                                Text(
                                                  formatNumber.format(netTotalArray['NetSalary']),
                                                  style: const TextStyle(
                                                      fontSize:
                                                      AppConst.appFontSizeh10,
                                                      fontWeight: AppConst
                                                          .appTextFontWeightLight),
                                                )
                                              ],
                                            ),
                                          ),
                                          // Balance Salary
                                          netTotalArray['NetSalary'] != netTotalArray['BalanceSalary'] ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom:
                                                AppConst.appMainPaddingLarge),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Balance Salary',
                                                  style: TextStyle(
                                                    fontSize:
                                                    AppConst.appFontSizeh10,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightLight,
                                                  ),
                                                ),
                                                Text(
                                                  '${netTotalArray['BalanceSalary']}',
                                                  style: const TextStyle(
                                                      fontSize:
                                                      AppConst.appFontSizeh10,
                                                      fontWeight: AppConst
                                                          .appTextFontWeightLight),
                                                )
                                              ],
                                            ),
                                          ) : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                      () {},
                                  false,
                                  isHeader: true,
                                  isCloseBtn: true,
                                );
                              }
                            } else if (isErrorGotInDetail) {
                              if (mounted) {
                                Functions.ShowPopUpDialog(
                                  context,
                                  'Error',
                                  SizedBox(
                                    height: 60,
                                    width: 150,
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
                                      () {},
                                  false,
                                  isHeader: true,
                                  isCloseBtn: true,
                                );
                              }
                            } else {
                              if (mounted) {
                                Functions.ShowPopUpDialog(
                                  context,
                                  'Awaiting Result',
                                  SizedBox(
                                    height: 60,
                                    width: 150,
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
                                      () {},
                                  false,
                                  isHeader: false,
                                  isCloseBtn: false,
                                );
                              }
                            }
                          },
                        ),
                      // PayrollContainer(
                      //   month:
                      //       AppConst.months[payrollData[i]['Time_Month'] - 1],
                      //   year: '${payrollData[i]['Time_Year']}',
                      //   salary: '${payrollData[i]['Salary']}',
                      //   earning: '${payrollData[i]['Earning']}',
                      //   advance: '${payrollData[i]['AdvanceAndLoan']}',
                      //   isSelected: false,
                      //   statusColor: context.read<ThemeProvider>().selectedPrimaryColor,
                      //   onPressed: () async {
                      //     isDetailsDataLoaded = false;
                      //     isErrorGotInDetail = false;
                      //     var payrolDetailsKeys = [];
                      //     dynamic detailsReturn = await DetailPayrollDetailsAPI(
                      //         userProvider,
                      //         payrollData[i]['Time_Year'],
                      //         payrollData[i]['Time_Month']);
                      //     if (detailsReturn[0].Data.length > 0) {
                      //       payrollDataDetails = detailsReturn[0].Data['Table'];
                      //       // payrolDetailsGroupedData = Functions.getGroupedByMap(payrollDataDetails, 'SalaryGroup');
                      //       payrolDetailsGroupedData = Functions.getGroupedByData(payrollDataDetails, 'SalaryGroup');
                      //       print(payrollDataDetails);
                      //       print(payrolDetailsGroupedData.length);
                      //       setState(() {
                      //         isDetailsDataLoaded = true;
                      //         isErrorGotInDetail = false;
                      //       });
                      //     } else {
                      //       setState(() {
                      //         isDetailsDataLoaded = false;
                      //         isErrorGotInDetail = true;
                      //       });
                      //     }
                      //     if (isDetailsDataLoaded) {
                      //       // Functions.ShowPopUpDialog(
                      //       //     context,
                      //       //     'Payroll Details ${AppConst.months[DateTime.parse('${payrollDataDetails[i]['PayMonth']}').month-1]}, ${DateTime.parse('${payrollDataDetails[i]['PayMonth']}').year}',
                      //       //     SizedBox(
                      //       //       width: screenSize.width * 0.8,
                      //       //       height: screenSize.height * 0.6,
                      //       //       child: SingleChildScrollView(
                      //       //         child: Column(
                      //       //           mainAxisAlignment: MainAxisAlignment.center,
                      //       //           children: [
                      //       //             for (int outer = 0; outer < payrolDetailsGroupedData.length; outer++)
                      //       //               Column(
                      //       //                 children: [
                      //       //                   // Text(
                      //       //                   //   '${payrolDetailsGroupedData[i][payrolDetailsGroupedData[i].keys[0]]}',
                      //       //                   //   style: const TextStyle(
                      //       //                   //       fontSize: AppConst.appFontSizeh10,
                      //       //                   //       fontWeight: AppConst.appTextFontWeightMedium
                      //       //                   //   ),
                      //       //                   // ),
                      //       //                   for(int i = 0; i < payrollDataDetails.length; i++)
                      //       //                     payrolDetailsGroupedData[i].keys[0] == payrollDataDetails[i]['SalaryGroup'] ? Padding(
                      //       //                       padding: const EdgeInsets.symmetric(vertical: AppConst.appMainPaddingSmall),
                      //       //                       child: Row(
                      //       //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       //                         children: [
                      //       //                           Text(
                      //       //                             'Salary Group',
                      //       //                             style: const TextStyle(
                      //       //                                 fontSize: AppConst.appFontSizeh10,
                      //       //                                 fontWeight: AppConst.appTextFontWeightMedium
                      //       //                             ),
                      //       //                           ),
                      //       //                           Text(
                      //       //                             payrollDataDetails[i]['SalaryGroup'],
                      //       //                             style: const TextStyle(
                      //       //                                 fontSize: AppConst.appFontSizeh10,
                      //       //                                 fontWeight: AppConst.appTextFontWeightLight
                      //       //                             ),
                      //       //                           )
                      //       //                         ],
                      //       //                       ),
                      //       //                     ) : Container(),
                      //       //                 ],
                      //       //               )
                      //       //           ],
                      //       //         ),
                      //       //       ),
                      //       //     ),
                      //       //     () {},
                      //       //     false);
                      //     } else if (isErrorGotInDetail) {
                      //       Functions.ShowPopUpDialog(
                      //           context,
                      //           'Error',
                      //           SizedBox(
                      //             height: 60,
                      //             width: 150,
                      //             child: Column(
                      //               children: const [
                      //                 SizedBox(
                      //                   width: 60,
                      //                   height: 60,
                      //                   child: Icon(
                      //                     size: AppConst.appFontSizeh5,
                      //                     Icons.error_outline_rounded,
                      //                     color: context.read<ThemeProvider>().selectedPrimaryColor,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           () {},
                      //           false);
                      //     } else {
                      //       Functions.ShowPopUpDialog(
                      //           context,
                      //           'Awaiting Result',
                      //           SizedBox(
                      //             height: 60,
                      //             width: 150,
                      //             child: Column(
                      //               children: const [
                      //                 SizedBox(
                      //                   width: 60,
                      //                   height: 60,
                      //                   child:
                      //                       const CircularProgressIndicator(color: context.read<ThemeProvider>().selectedPrimaryColor,),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           () {},
                      //           false);
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text(
            'No Data',
            style: TextStyle(
                fontSize: AppConst.appFontSizeh9,
                fontWeight: AppConst.appTextFontWeightMedium),
          ),
        );
      }
    } else if (isSessionExpired) {
      return PopUpDialog(
        title: 'Session Expired',
        content: SizedBox(
          height: 60,
          width: 150,
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
        content: SizedBox(
          height: 60,
          width: 150,
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
        content: SizedBox(
          height: 60,
          width: 150,
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
