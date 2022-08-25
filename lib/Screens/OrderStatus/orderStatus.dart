import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ts_app_development/DataLayer/Models/ApiResponse/ApiResponse.dart';
import 'package:ts_app_development/DataLayer/Providers/DateTimeRangeProvider/dateTimeRangeProvider.dart';
import 'package:ts_app_development/DataLayer/Providers/LocationProvider/location.dart';
import 'package:ts_app_development/DataLayer/Services/OrderStatusService/orderStatusService.dart';
import 'package:ts_app_development/Generic/AppScreens/appScreens.dart';
import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/Functions/functions.dart';
import '../../Generic/appConst.dart';
import '../../UserControls/CustomTabBar/customTabBar.dart';
import '../../UserControls/OrderStatusContainer/orderStatusContainer.dart';
import '../../UserControls/PopUpDialog/popupDialog.dart';

class OrderStatus extends StatefulWidget {
  final String route;
  const OrderStatus({
    Key? key,
    required this.route,
  }) : super(key: key);

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus>
    with TickerProviderStateMixin {
  Timer? timer;
  Map<String, dynamic> timeDictionary = {};
  late TabController tabController;
  ApiResponse orderStatusDataFuture = ApiResponse();
  ApiResponse orderDetailsDataFuture = ApiResponse();
  dynamic orderStatusData = [];
  dynamic orderStatusFilteredData = [];
  dynamic orderDetailData = [];
  List pendingOrdersData = [];
  List deliveredOrdersData = [];
  bool isDataLoaded = false;
  bool isErrorGot = false;
  bool isSessionExpired = false;
  bool isDetailsDataLoaded = false;
  bool isDetailsErrorGot = false;
  bool isDetailsSessionExpired = false;
  bool isDeliverLoading = false;
  bool isDeliverDone = false;
  final Completer<GoogleMapController> _controller = Completer();
  NumberFormat formatNumber = NumberFormat.decimalPattern('en_us');
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeDictionary = {};
    tabController = TabController(
        vsync: this, length: AppScreens.screenTabs[widget.route]['tabs']);
    isDataLoaded = false;
    isErrorGot = false;
    isSessionExpired = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      DateTimeRangeProvider dateTime =
          Provider.of<DateTimeRangeProvider>(context, listen: false);

      // Services
      dynamic result = await APICalls(dateTime);
      if (result[0].Data.length >= 0) {
        setState(() {
          if (result[0].Data.length > 0) {
            orderStatusData = result[0].Data;
            orderStatusFilteredData = orderStatusData;
            // Separating The Data
            pendingOrdersData = orderStatusFilteredData.where((elem) {
              return elem['ProcessTypeId'] == 8;
            }).toList();
            deliveredOrdersData = orderStatusFilteredData.where((elem) {
              return [6, 9].contains(elem['ProcessTypeId']);
            }).toList();
          }
          isDataLoaded = true;
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
    });
    timer = Timer.periodic(const Duration(seconds: 1),
        (Timer t) => TimerFunction(pendingOrdersData));
  }

  Future<void> _refreshFunction() async {
    DateTimeRangeProvider dateTime =
        Provider.of<DateTimeRangeProvider>(context, listen: false);

    // Services
    dynamic result = await APICalls(dateTime);
    if (result.length > 0) {
      if (result[0].Data.length >= 0) {
        setState(() {
          if (result[0].Data.length > 0) {
            orderStatusData = result[0].Data;
            orderStatusFilteredData = orderStatusData;
            // Separating The Data
            pendingOrdersData = orderStatusFilteredData.where((elem) {
              return elem['ProcessTypeId'] == 8;
            }).toList();
            deliveredOrdersData = orderStatusFilteredData.where((elem) {
              return [6, 9].contains(elem['ProcessTypeId']);
            }).toList();
            isDataLoaded = true;
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
  }

  Future<List<ApiResponse>> APICalls(dateTime) async {
    orderStatusDataFuture = await OrderStatusService.getRestaurantOrderStatus(
      [
        {
          'Parameter': '_FromDate',
          'Value2': dateTime.customDateRange.start.toString(),
        },
        {
          'Parameter': '_ToDate',
          'Value2': dateTime.customDateRange.end.toString(),
        },
        {
          'Parameter': 'SaleTypeIds',
          'Value2': "2",
        },
      ],
    );

    return [orderStatusDataFuture];
  }

  void TimerFunction(pendingOrders) {
    if (pendingOrders.length > 0) {
      for (int i = 0; i < pendingOrders.length; i++) {
        setState(() {
          timeDictionary[pendingOrders[i]['SaleInvoiceId'].toString()] =
              pendingOrders[i]['ExpectedDeliveryDate2'] != null
                  ? DateTime.parse(pendingOrders[i]['ExpectedDeliveryDate2'])
                      .difference(DateTime.now())
                      .toString()
                      .split('.')[0]
                  : AppConst.nullString;
        });
      }
    }
  }

  Future<List<ApiResponse>> GetOrderDetails(order) async {
    orderDetailsDataFuture = await OrderStatusService.getOrderDetails({
      'SaleInvoiceId': '${order['SaleInvoiceId']}',
      'NoOfRecord': '1',
      'ShouldIncludeItems': 'true',
    });

    return [orderDetailsDataFuture];
  }

  @override
  void dispose() {
    tabController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    DateTimeRangeProvider dateTime =
        Provider.of<DateTimeRangeProvider>(context);
    LocationIdentifier locationProvider =
        Provider.of<LocationIdentifier>(context);

    if (isDataLoaded) {
      return Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConst.appMainPaddingSmall,
                vertical: AppConst.appMainPaddingExtraSmall),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  isDataLoaded = false;
                  orderStatusFilteredData = orderStatusData.where((elem) {
                    var concatenatedString =
                        '${elem['TokenNumber']}${elem['ClientName']}${elem['ContactNo']}${elem['Address']}${elem['NetAmount']}';
                    return concatenatedString
                            .toLowerCase()
                            .contains(value.toLowerCase())
                        ? true
                        : false;
                  }).toList();
                  // Separating The Data
                  pendingOrdersData = orderStatusFilteredData.where((elem) {
                    return elem['ProcessTypeId'] == 8;
                  }).toList();
                  deliveredOrdersData = orderStatusFilteredData.where((elem) {
                    return [6, 9].contains(elem['ProcessTypeId']);
                  }).toList();
                  isDataLoaded = true;
                });
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: context.read<ThemeProvider>().selectedPrimaryColor,
                      width: 1.0),
                ),
                border: const OutlineInputBorder(),
                labelStyle: const TextStyle(
                  color: AppConst.appColorLightBlue,
                  fontSize: AppConst.appFontSizeh11,
                ),
                suffixIcon: IconButton(
                  onPressed: _searchController.clear,
                  icon: Icon(
                    Icons.clear,
                    color: context.read<ThemeProvider>().selectedPrimaryColor,
                  ),
                ),
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: context.read<ThemeProvider>().selectedPrimaryColor,
                  fontSize: AppConst.appFontSizeh11,
                ),
              ),
            ),
          ),

          // Custom Tab Bar
          CustomTabBar(
              route: widget.route,
              tabsNotificationList: [
                pendingOrdersData.length,
                deliveredOrdersData.length
              ],
              tabsList: const ['Pending', 'Delivered'],
              tabController: tabController),

          // Component
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                pendingOrdersData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppConst.appMainPaddingSmall),
                        child: RefreshIndicator(
                          onRefresh: _refreshFunction,
                          child: ListView.builder(
                              itemCount: pendingOrdersData.length,
                              itemBuilder: (context, i) {
                                return OrderStatusContainer(
                                  expectedTime: timeDictionary[
                                          pendingOrdersData[i]['SaleInvoiceId']
                                              .toString()]
                                      .toString(),
                                  orderNo: pendingOrdersData[i]['TokenNumber']
                                              .runtimeType
                                              .toString() ==
                                          'Null'
                                      ? 0.toString()
                                      : pendingOrdersData[i]['TokenNumber']
                                          .toString(),
                                  dateText: pendingOrdersData[i]['DispatchDate']
                                              .runtimeType
                                              .toString() ==
                                          'Null'
                                      ? '-- --'
                                      : pendingOrdersData[i]['DispatchDate']
                                          .split(' ')[0]
                                          .toString(),
                                  customerName: pendingOrdersData[i]
                                                  ['ClientName']
                                              .runtimeType
                                              .toString() ==
                                          'Null'
                                      ? '-- --'
                                      : pendingOrdersData[i]['ClientName']
                                          .toString(),
                                  customerPhone: pendingOrdersData[i]
                                                  ['ContactNo']
                                              .runtimeType
                                              .toString() ==
                                          'Null'
                                      ? '-- --'
                                      : pendingOrdersData[i]['ContactNo']
                                          .toString(),
                                  customerAddress: pendingOrdersData[i]
                                                  ['Address']
                                              .runtimeType
                                              .toString() ==
                                          'Null'
                                      ? '-- --'
                                      : pendingOrdersData[i]['Address']
                                          .toString(),
                                  customerRemarks: pendingOrdersData[i]
                                              .keys
                                              .contains('Remarks') &&
                                          pendingOrdersData[i]['Remarks'] ==
                                              null
                                      ? '-- --'
                                      : pendingOrdersData[i]['Remarks']
                                          .toString(),
                                  amount: pendingOrdersData[i]['NetAmount']
                                              .runtimeType
                                              .toString() ==
                                          'Null'
                                      ? '-- --'
                                      : pendingOrdersData[i]['NetAmount'],
                                  showLocation: pendingOrdersData[i]
                                              .keys
                                              .contains('LocationLink') &&
                                          pendingOrdersData[i]
                                                  ['LocationLink'] !=
                                              null
                                      ? true
                                      : false,
                                  onPressDelivered: () {
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
                                        if (mounted) {
                                          Navigator.pop(context);
                                        }
                                        setState(() {
                                          isDeliverLoading = true;
                                          isDeliverDone = false;
                                        });
                                        // API Call to Save
                                        try {
                                          if (isDeliverLoading) {
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
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: context
                                                              .read<
                                                                  ThemeProvider>()
                                                              .selectedPrimaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                () => {},
                                                false,
                                                isHeader: false,
                                                isCloseBtn: false,
                                              );
                                            }
                                          }
                                          var deliveryResult =
                                              await OrderStatusService
                                                  .postRestaurantOrderStatus([
                                            {
                                              'Parameter': '_FromDate',
                                              'Value2': dateTime
                                                  .customDateRange.start
                                                  .toString(),
                                            },
                                            {
                                              'Parameter': '_ToDate',
                                              'Value2': dateTime
                                                  .customDateRange.end
                                                  .toString(),
                                            },
                                            {
                                              'Parameter': 'SaleTypeIds',
                                              'Value2': "2",
                                            },
                                            {
                                              'Parameter': '_SaleInvoiceId',
                                              'Value2': pendingOrdersData[i]
                                                      ['SaleInvoiceId']
                                                  .toString(),
                                            }
                                          ]);
                                          if (deliveryResult.Data != null) {
                                            List<dynamic> data =
                                                deliveryResult.Data as List;
                                            setState(() {
                                              // Separating The Data
                                              pendingOrdersData =
                                                  data.where((elem) {
                                                return elem['ProcessTypeId'] ==
                                                    8;
                                              }).toList();
                                              deliveredOrdersData =
                                                  data.where((elem) {
                                                return [6, 9].contains(
                                                    elem['ProcessTypeId']);
                                              }).toList();
                                              isDeliverLoading = false;
                                              isDeliverDone = true;
                                            });
                                          }
                                          if (mounted) {
                                            Navigator.pop(context);
                                          }
                                        } catch (e) {
                                          setState(() {
                                            isDeliverLoading = false;
                                            isDeliverDone = true;
                                          });
                                          if (mounted) {
                                            Functions.ShowPopUpDialog(
                                              context,
                                              'Not Updated Successfully.',
                                              const Icon(
                                                Icons.error_outline_outlined,
                                                color: Colors.red,
                                                size: 80,
                                              ),
                                              () => {},
                                              false,
                                              isHeader: true,
                                              isCloseBtn: true,
                                            );
                                          }
                                        }
                                        if (isDeliverDone) {
                                          if (mounted) {
                                            Functions.ShowPopUpDialog(
                                              context,
                                              'Updated Successfully.',
                                              Icon(
                                                Icons.done_outline_outlined,
                                                color: context
                                                    .read<ThemeProvider>()
                                                    .selectedPrimaryColor,
                                                size: 80,
                                              ),
                                              () => {},
                                              false,
                                              isHeader: true,
                                              isCloseBtn: true,
                                            );
                                          }
                                        } else {
                                          if (mounted) {
                                            Functions.ShowPopUpDialog(
                                              context,
                                              'Something went wrong',
                                              Icon(
                                                Icons.done_outline_outlined,
                                                color: context
                                                    .read<ThemeProvider>()
                                                    .selectedPrimaryColor,
                                                size: 80,
                                              ),
                                              () => {},
                                              false,
                                              isHeader: true,
                                              isCloseBtn: true,
                                            );
                                          }
                                        }
                                      },
                                      true,
                                      isHeader: true,
                                      isCloseBtn: true,
                                    );
                                  },
                                  onPressLocation: () {
                                    if (pendingOrdersData[i]['LocationLink'] !=
                                        null) {
                                      Functions.openGoogleMap(
                                          context,
                                          pendingOrdersData[i]['LocationLink']
                                              .toString());
                                    } else {
                                      Functions.ShowPopUpDialog(
                                        context,
                                        'Location Not Given',
                                        Icon(
                                          Icons.error_outline_sharp,
                                          color: context
                                              .read<ThemeProvider>()
                                              .selectedPrimaryColor,
                                          size: 80,
                                        ),
                                        () => {},
                                        false,
                                        isHeader: true,
                                        isCloseBtn: true,
                                      );
                                    }

                                    // if (pendingOrdersData[i]
                                    //         ['LocationLink'] !=
                                    //     null) {
                                    //   List<String> splitted =
                                    //       pendingOrdersData[i]
                                    //               ['LocationLatLong']
                                    //           .split(',');
                                    //   double lat = 0.0;
                                    //   double long = 0.0;
                                    //   if (splitted.isNotEmpty) {
                                    //     try {
                                    //       lat = double.parse(splitted[0]);
                                    //       long = double.parse(splitted[1]);
                                    //       showLocationPopUp = true;
                                    //     } catch (e) {
                                    //       showLocationPopUp = false;
                                    //       if (mounted) {
                                    //         Functions.ShowPopUpDialog(
                                    //           context,
                                    //           'Location Not Correct',
                                    //           SizedBox(
                                    //             height: 60,
                                    //             width: 150,
                                    //             child: Column(
                                    //               children: const [
                                    //                 SizedBox(
                                    //                   width: 60,
                                    //                   height: 60,
                                    //                   child: Icon(
                                    //                     size: AppConst
                                    //                         .appFontSizeh5,
                                    //                     Icons
                                    //                         .error_outline_rounded,
                                    //                     color: AppConst
                                    //                         .appColorPrimary,
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //           () {},
                                    //           false,
                                    //           isCloseBtn: true,
                                    //           isHeader: true,
                                    //         );
                                    //       }
                                    //     }
                                    //   }
                                    //   if (showLocationPopUp) {
                                    //     Functions.ShowPopUpDialog(
                                    //       context,
                                    //       'Order Location',
                                    //       SizedBox(
                                    //         width: screenSize.width * 0.8,
                                    //         height: screenSize.height * 0.6,
                                    //         child: SingleChildScrollView(
                                    //           child: Column(
                                    //             mainAxisAlignment:
                                    //                 MainAxisAlignment.center,
                                    //             children: [
                                    //               // Google Maps
                                    //               SizedBox(
                                    //                 width: double.infinity,
                                    //                 height:
                                    //                     (screenSize.height *
                                    //                         0.6),
                                    //                 child: GoogleMap(
                                    //                   mapType: MapType.normal,
                                    //                   markers: <Marker>{
                                    //                     Marker(
                                    //                       draggable: true,
                                    //                       markerId:
                                    //                           const MarkerId(
                                    //                               "1"),
                                    //                       position: LatLng(
                                    //                         lat,
                                    //                         long,
                                    //                       ),
                                    //                       icon: BitmapDescriptor
                                    //                           .defaultMarker,
                                    //                       infoWindow:
                                    //                           InfoWindow(
                                    //                         title: locationProvider
                                    //                             .address
                                    //                             .postalCode
                                    //                             .toString(),
                                    //                       ),
                                    //                     )
                                    //                   },
                                    //                   initialCameraPosition:
                                    //                       CameraPosition(
                                    //                     target: LatLng(
                                    //                         context
                                    //                             .read<
                                    //                                 LocationIdentifier>()
                                    //                             .currentLocation
                                    //                             .latitude!,
                                    //                         context
                                    //                             .read<
                                    //                                 LocationIdentifier>()
                                    //                             .currentLocation
                                    //                             .longitude!),
                                    //                     zoom: 15.0,
                                    //                   ),
                                    //                   onMapCreated:
                                    //                       (GoogleMapController
                                    //                           controller) {
                                    //                     _controller.complete(
                                    //                         controller);
                                    //                   },
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       () {},
                                    //       false,
                                    //       isHeader: true,
                                    //       isCloseBtn: true,
                                    //     );
                                    //   }
                                    // }
                                  },
                                  onPressDetails: () async {
                                    isDetailsDataLoaded = false;
                                    isDetailsErrorGot = false;
                                    isDetailsSessionExpired = false;
                                    orderDetailData = [];
                                    dynamic orderDetailsDealsData = {};
                                    var orderDetailsIndependantData = [];
                                    dynamic result = await GetOrderDetails(
                                        pendingOrdersData[i]);
                                    if (result[0].Data.length > 0) {
                                      orderDetailData = json
                                          .decode(result[0].Data.toString());
                                      isDetailsDataLoaded = true;
                                      isDetailsErrorGot = false;
                                      isDetailsSessionExpired = false;
                                    } else {
                                      if (result[0].ApiError['StatusCode'] ==
                                          401) {
                                        setState(() {
                                          isDetailsDataLoaded = false;
                                          isDetailsErrorGot = false;
                                          isDetailsSessionExpired = true;
                                        });
                                      } else {
                                        setState(() {
                                          isDetailsDataLoaded = false;
                                          isDetailsErrorGot = true;
                                          isDetailsSessionExpired = false;
                                        });
                                      }
                                    }
                                    if (isDetailsDataLoaded) {
                                      // Taking Independant
                                      orderDetailsIndependantData =
                                          orderDetailData['Table1']
                                              .where((elem) {
                                        return elem['ParentId'] == null;
                                      }).toList();

                                      for (int i = 0;
                                          i < orderDetailData['Table1'].length;
                                          i++) {
                                        if (orderDetailData['Table1'][i]
                                                ['ParentId'] ==
                                            null) {
                                          continue;
                                        } else {
                                          for (int j = 0;
                                              j <
                                                  orderDetailsIndependantData
                                                      .length;
                                              j++) {
                                            if (orderDetailsIndependantData[j]
                                                    ['SaleInvoiceItemId'] ==
                                                orderDetailData['Table1'][i]
                                                    ['ParentId']) {
                                              if (orderDetailsDealsData[
                                                      orderDetailsIndependantData[
                                                                  j][
                                                              'SaleInvoiceItemId']
                                                          .toString()] ==
                                                  null) {
                                                orderDetailsDealsData[
                                                    orderDetailsIndependantData[
                                                                j][
                                                            'SaleInvoiceItemId']
                                                        .toString()] = [];
                                              } else {
                                                orderDetailsDealsData[
                                                        orderDetailsIndependantData[
                                                                    j][
                                                                'SaleInvoiceItemId']
                                                            .toString()]
                                                    .add(orderDetailData[
                                                        'Table1'][i]);
                                              }
                                            }
                                          }
                                        }
                                      }
                                      // Deals Keys If Any
                                      var dealsKeys =
                                          orderDetailsDealsData.keys.toList();

                                      if (mounted) {
                                        Functions.ShowPopUpDialog(
                                          context,
                                          'Order',
                                          SizedBox(
                                            width: screenSize.width * 0.8,
                                            height: screenSize.height * 0.6,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Order
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: AppConst
                                                            .appMainPaddingLarge),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Sale Type',
                                                              style: TextStyle(
                                                                color: AppConst
                                                                    .appColorLightBlue,
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${orderDetailData['Table'][0]['SaleType']}',
                                                              style: const TextStyle(
                                                                  fontSize: AppConst
                                                                      .appFontSizeh11,
                                                                  fontWeight:
                                                                      AppConst
                                                                          .appTextFontWeightLight),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Token/Order #',
                                                              style: TextStyle(
                                                                color: AppConst
                                                                    .appColorLightBlue,
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight,
                                                              ),
                                                            ),
                                                            Text(
                                                              pendingOrdersData[i]
                                                                              [
                                                                              'TokenNumber'] !=
                                                                          null &&
                                                                      orderDetailData['Table'][0]
                                                                              [
                                                                              'InvoiceNumber'] !=
                                                                          null
                                                                  ? '${pendingOrdersData[i]['TokenNumber']}/${orderDetailData['Table'][0]['InvoiceNumber']}'
                                                                  : AppConst
                                                                      .nullString,
                                                              style: const TextStyle(
                                                                  fontSize: AppConst
                                                                      .appFontSizeh11,
                                                                  fontWeight:
                                                                      AppConst
                                                                          .appTextFontWeightLight),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Order Amt.',
                                                              style: TextStyle(
                                                                color: AppConst
                                                                    .appColorLightBlue,
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight,
                                                              ),
                                                            ),
                                                            Text(
                                                              formatNumber.format(
                                                                  orderDetailData[
                                                                          'Table'][0]
                                                                      [
                                                                      'NetAmount']),
                                                              style: const TextStyle(
                                                                  fontSize: AppConst
                                                                      .appFontSizeh11,
                                                                  fontWeight:
                                                                      AppConst
                                                                          .appTextFontWeightLight),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Order Date',
                                                              style: TextStyle(
                                                                color: AppConst
                                                                    .appColorLightBlue,
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight,
                                                              ),
                                                            ),
                                                            Text(
                                                              orderDetailData['Table']
                                                                              [
                                                                              0]
                                                                          [
                                                                          'InvoiceDate'] !=
                                                                      null
                                                                  ? '${DateTime.parse(orderDetailData['Table'][0]['InvoiceDate']).day}-${AppConst.months[DateTime.parse(orderDetailData['Table'][0]['InvoiceDate']).month - 1]}-${DateTime.parse(orderDetailData['Table'][0]['InvoiceDate']).year} ${Functions.formatTimeOfDay(orderDetailData['Table'][0]['InvoiceDate'])}'
                                                                  : '-- : --',
                                                              style: const TextStyle(
                                                                  fontSize: AppConst
                                                                      .appFontSizeh11,
                                                                  fontWeight:
                                                                      AppConst
                                                                          .appTextFontWeightLight),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Delivery Date',
                                                              style: TextStyle(
                                                                color: AppConst
                                                                    .appColorLightBlue,
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight,
                                                              ),
                                                            ),
                                                            Text(
                                                              orderDetailData['Table']
                                                                              [
                                                                              0]
                                                                          [
                                                                          'DeliveryDate'] !=
                                                                      null
                                                                  ? '${DateTime.parse(orderDetailData['Table'][0]['DeliveryDate']).day}-${AppConst.months[DateTime.parse(orderDetailData['Table'][0]['DeliveryDate']).month - 1]}-${DateTime.parse(orderDetailData['Table'][0]['DeliveryDate']).year} ${Functions.formatTimeOfDay(orderDetailData['Table'][0]['DeliveryDate'])}'
                                                                  : '-- : --',
                                                              style: const TextStyle(
                                                                  fontSize: AppConst
                                                                      .appFontSizeh11,
                                                                  fontWeight:
                                                                      AppConst
                                                                          .appTextFontWeightLight),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Delivery Branch',
                                                              style: TextStyle(
                                                                color: AppConst
                                                                    .appColorLightBlue,
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${orderDetailData['Table'][0]['CompanyBranch']}',
                                                              style: const TextStyle(
                                                                  fontSize: AppConst
                                                                      .appFontSizeh11,
                                                                  fontWeight:
                                                                      AppConst
                                                                          .appTextFontWeightLight),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Order Branch',
                                                              style: TextStyle(
                                                                color: AppConst
                                                                    .appColorLightBlue,
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${orderDetailData['Table'][0]['OrderBranch']}',
                                                              style: const TextStyle(
                                                                  fontSize: AppConst
                                                                      .appFontSizeh11,
                                                                  fontWeight:
                                                                      AppConst
                                                                          .appTextFontWeightLight),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Client Name',
                                                              style: TextStyle(
                                                                color: AppConst
                                                                    .appColorLightBlue,
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${orderDetailData['Table'][0]['ClientName']}',
                                                              style: const TextStyle(
                                                                  fontSize: AppConst
                                                                      .appFontSizeh11,
                                                                  fontWeight:
                                                                      AppConst
                                                                          .appTextFontWeightLight),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Order Source',
                                                              style: TextStyle(
                                                                color: AppConst
                                                                    .appColorLightBlue,
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${orderDetailData['Table'][0]['CommunicateType']}',
                                                              style: const TextStyle(
                                                                  fontSize: AppConst
                                                                      .appFontSizeh11,
                                                                  fontWeight:
                                                                      AppConst
                                                                          .appTextFontWeightLight),
                                                            )
                                                          ],
                                                        ),
                                                        // Row(
                                                        //   mainAxisAlignment:
                                                        //       MainAxisAlignment
                                                        //           .spaceBetween,
                                                        //   children: [
                                                        //     const Text(
                                                        //       'Location',
                                                        //       style: TextStyle(
                                                        //         color: AppConst
                                                        //             .appColorLightBlue,
                                                        //         fontSize: AppConst
                                                        //             .appFontSizeh11,
                                                        //         fontWeight: AppConst
                                                        //             .appTextFontWeightLight,
                                                        //       ),
                                                        //     ),
                                                        //     Text(
                                                        //       orderDetailData['Table']
                                                        //                       [
                                                        //                       0]
                                                        //                   [
                                                        //                   'LocationLatLong'] !=
                                                        //               null
                                                        //           ? '${orderDetailData['Table'][0]['LocationLatLong']}'
                                                        //           : '-- : --',
                                                        //       style: const TextStyle(
                                                        //           fontSize: AppConst
                                                        //               .appFontSizeh11,
                                                        //           fontWeight:
                                                        //               AppConst
                                                        //                   .appTextFontWeightLight),
                                                        //     )
                                                        //   ],
                                                        // ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: const [
                                                            Text(
                                                              'Order Remarks',
                                                              style: TextStyle(
                                                                color: AppConst
                                                                    .appColorLightBlue,
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              orderDetailData['Table']
                                                                              [
                                                                              0]
                                                                          [
                                                                          'Remarks'] !=
                                                                      ' '
                                                                  ? '${orderDetailData['Table'][0]['Remarks']}'
                                                                  : '-- : --',
                                                              style: const TextStyle(
                                                                  fontSize: AppConst
                                                                      .appFontSizeh11,
                                                                  fontWeight:
                                                                      AppConst
                                                                          .appTextFontWeightLight),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // Order Details
                                                  const Text(
                                                    'Order Details',
                                                    style: TextStyle(
                                                      fontSize: AppConst
                                                          .appFontSizeh9,
                                                      fontWeight: AppConst
                                                          .appTextFontWeightMedium,
                                                    ),
                                                  ),
                                                  // Header
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .only(
                                                        top: AppConst
                                                            .appMainPaddingSmall),
                                                    child: Container(
                                                      height: 40,
                                                      color: AppConst
                                                          .appColorLightBlue,
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            vertical: AppConst
                                                                .appMainPaddingSmall,
                                                            horizontal: AppConst
                                                                .appMainPaddingSmall),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: const [
                                                                  SizedBox(
                                                                    width:
                                                                        100.0,
                                                                    child: Text(
                                                                      'Item Name',
                                                                      style:
                                                                          TextStyle(
                                                                        color: AppConst
                                                                            .appColorWhite,
                                                                        fontSize:
                                                                            AppConst.appFontSizeh11,
                                                                        fontWeight:
                                                                            AppConst.appTextFontWeightBold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 60.0,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Price',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              AppConst.appColorWhite,
                                                                          fontSize:
                                                                              AppConst.appFontSizeh11,
                                                                          fontWeight:
                                                                              AppConst.appTextFontWeightBold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 102.0,
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              5.0),
                                                                  child: Text(
                                                                    'Quantity',
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppConst
                                                                          .appColorWhite,
                                                                      fontSize:
                                                                          AppConst
                                                                              .appFontSizeh11,
                                                                      fontWeight:
                                                                          AppConst
                                                                              .appTextFontWeightBold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  for (int outer = 0;
                                                      outer <
                                                          orderDetailsIndependantData
                                                              .length;
                                                      outer++)
                                                    dealsKeys.contains(
                                                            orderDetailsIndependantData[
                                                                        outer][
                                                                    'SaleInvoiceItemId']
                                                                .toString())
                                                        ? ExpansionTile(
                                                            title: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      '${orderDetailsIndependantData[outer]['LongName']}',
                                                                      style: const TextStyle(
                                                                          fontSize: AppConst
                                                                              .appFontSizeh11,
                                                                          fontWeight:
                                                                              AppConst.appTextFontWeightLight),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          AppConst
                                                                              .appMainPaddingMedium),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            100.0,
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            80.0,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            formatNumber.format(orderDetailsIndependantData[outer]['SaleRate']),
                                                                            style:
                                                                                const TextStyle(fontSize: AppConst.appFontSizeh11, fontWeight: AppConst.appTextFontWeightLight),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      // Container(
                                                                      //   width: 70.0,
                                                                      //   child: Center(
                                                                      //     child: Text(
                                                                      //       '${orderDetailData['Table1'][outer]['Quantity']}',
                                                                      //       style: const TextStyle(
                                                                      //           fontSize: AppConst
                                                                      //               .appFontSizeh11,
                                                                      //           fontWeight:
                                                                      //           AppConst
                                                                      //               .appTextFontWeightLight),
                                                                      //     ),
                                                                      //   ),
                                                                      // )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            trailing: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          23.0),
                                                              child: Container(
                                                                width: 60.0,
                                                                child: Center(
                                                                  child: Text(
                                                                    formatNumber.format(orderDetailData['Table1']
                                                                            [
                                                                            outer]
                                                                        [
                                                                        'Quantity']),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            AppConst
                                                                                .appFontSizeh11,
                                                                        fontWeight:
                                                                            AppConst.appTextFontWeightLight),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            children: [
                                                              for (int inner =
                                                                      0;
                                                                  inner <
                                                                      orderDetailsDealsData[
                                                                              orderDetailsIndependantData[outer]['SaleInvoiceItemId'].toString()]
                                                                          .length;
                                                                  inner++)
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          AppConst
                                                                              .appMainPaddingSmall),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: AppConst.appMainPaddingMedium),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              '${orderDetailsDealsData[orderDetailsIndependantData[outer]['SaleInvoiceItemId'].toString()][inner]['LongName']}',
                                                                              style: const TextStyle(fontSize: AppConst.appFontSizeh11, fontWeight: AppConst.appTextFontWeightLight),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: AppConst.appMainPaddingMedium),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Container(
                                                                              width: 100.0,
                                                                            ),
                                                                            Container(
                                                                              width: 80.0,
                                                                            ),
                                                                            Container(
                                                                              width: 60.0,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  formatNumber.format(orderDetailsDealsData[orderDetailsIndependantData[outer]['SaleInvoiceItemId'].toString()][inner]['Quantity']),
                                                                                  style: const TextStyle(fontSize: AppConst.appFontSizeh11, fontWeight: AppConst.appTextFontWeightLight),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                            ],
                                                          )
                                                        : Padding(
                                                            padding: const EdgeInsets
                                                                    .fromLTRB(
                                                                AppConst
                                                                    .appMainPaddingMedium,
                                                                AppConst
                                                                    .appMainPaddingMedium,
                                                                0,
                                                                0),
                                                            child: Column(
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    '${orderDetailsIndependantData[outer]['LongName']}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            AppConst
                                                                                .appFontSizeh11,
                                                                        fontWeight:
                                                                            AppConst.appTextFontWeightLight),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                100.0,
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                80.0,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                formatNumber.format(orderDetailsIndependantData[outer]['SaleRate']),
                                                                                style: const TextStyle(fontSize: AppConst.appFontSizeh11, fontWeight: AppConst.appTextFontWeightLight),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              12.0,
                                                                          left:
                                                                              5.0),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            90.0,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            formatNumber.format(orderDetailData['Table1'][outer]['Quantity']),
                                                                            style:
                                                                                const TextStyle(fontSize: AppConst.appFontSizeh11, fontWeight: AppConst.appTextFontWeightLight),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
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
                                    } else if (isDetailsSessionExpired) {
                                      if (mounted) {
                                        Functions.ShowPopUpDialog(
                                            context,
                                            'Session Expired',
                                            SizedBox(
                                              height: 60,
                                              width: 150,
                                              child: Column(
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      // Foreground color
                                                      onPrimary: AppConst
                                                          .appColorAccent,
                                                      // Background color
                                                      primary: AppConst
                                                          .appColorPrimary,
                                                      fixedSize:
                                                          const Size(80, 60),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(AppConst
                                                                  .appButtonsBorderRadiusMed)),
                                                    ).copyWith(
                                                        elevation:
                                                            ButtonStyleButton
                                                                .allOrNull(
                                                                    0.0)),
                                                    child: const Text(
                                                      'Login',
                                                      style: TextStyle(
                                                          fontSize: AppConst
                                                              .appFontSizeh10,
                                                          fontWeight: AppConst
                                                              .appTextFontWeightMedium),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            () {},
                                            false,
                                            isCloseBtn: false,
                                            isHeader: true);
                                      }
                                    } else if (isDetailsErrorGot) {
                                      if (mounted) {
                                        Functions.ShowPopUpDialog(
                                          context,
                                          'Something went wrong',
                                          SizedBox(
                                            height: 60,
                                            width: 150,
                                            child: Column(
                                              children: const [
                                                SizedBox(
                                                  width: 60,
                                                  height: 60,
                                                  child: Icon(
                                                    size:
                                                        AppConst.appFontSizeh5,
                                                    Icons.error_outline_rounded,
                                                    color: AppConst
                                                        .appColorPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          () {},
                                          false,
                                          isCloseBtn: false,
                                          isHeader: true,
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
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: context
                                                          .read<ThemeProvider>()
                                                          .selectedPrimaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            () {},
                                            false,
                                            isCloseBtn: false,
                                            isHeader: false);
                                      }
                                    }
                                  },
                                  isDelivered: false,
                                );
                              }),
                        ),
                      )
                    : const Center(
                        child: Text(
                          'No Orders',
                          style: TextStyle(
                              fontSize: AppConst.appFontSizeh9,
                              fontWeight: AppConst.appTextFontWeightMedium),
                        ),
                      ),

                // Tab 2
                deliveredOrdersData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppConst.appMainPaddingSmall),
                        child: RefreshIndicator(
                          onRefresh: _refreshFunction,
                          child: ListView.builder(
                            itemCount: deliveredOrdersData.length,
                            itemBuilder: (context, i) {
                              return OrderStatusContainer(
                                expectedTime: null,
                                orderNo: deliveredOrdersData[i]['TokenNumber']
                                            .runtimeType
                                            .toString() ==
                                        'Null'
                                    ? 0.toString()
                                    : deliveredOrdersData[i]['TokenNumber']
                                        .toString(),
                                dateText: deliveredOrdersData[i]
                                            ['ProcessTypeId'] ==
                                        9
                                    ? (deliveredOrdersData[i]['DeliveryDate']
                                                .runtimeType
                                                .toString() ==
                                            'Null'
                                        ? '-- --'
                                        : deliveredOrdersData[i]['DeliveryDate']
                                            // .split(' ')[0]
                                            .toString())
                                    : (deliveredOrdersData[i]['TenderDate']
                                                .runtimeType
                                                .toString() ==
                                            'Null'
                                        ? '-- --'
                                        : deliveredOrdersData[i]['TenderDate']
                                            // .split(' ')[0]
                                            .toString()),
                                customerName: deliveredOrdersData[i]
                                                ['ClientName']
                                            .runtimeType
                                            .toString() ==
                                        'Null'
                                    ? '-- --'
                                    : deliveredOrdersData[i]['ClientName']
                                        .toString(),
                                customerPhone: deliveredOrdersData[i]
                                                ['ContactNo']
                                            .runtimeType
                                            .toString() ==
                                        'Null'
                                    ? '-- --'
                                    : deliveredOrdersData[i]['ContactNo']
                                        .toString(),
                                customerAddress: deliveredOrdersData[i]
                                                ['Address']
                                            .runtimeType
                                            .toString() ==
                                        'Null'
                                    ? '-- --'
                                    : deliveredOrdersData[i]['Address']
                                        .toString(),
                                customerRemarks: deliveredOrdersData[i]
                                            .keys
                                            .contains('Remarks') &&
                                        deliveredOrdersData[i]['Remarks'] ==
                                            null
                                    ? '-- --'
                                    : deliveredOrdersData[i]['Remarks']
                                        .toString(),
                                amount: deliveredOrdersData[i]['NetAmount']
                                            .runtimeType
                                            .toString() ==
                                        'Null'
                                    ? '-- --'
                                    : deliveredOrdersData[i]['NetAmount'],
                                showLocation: deliveredOrdersData[i]
                                            .keys
                                            .contains('LocationLink') &&
                                        deliveredOrdersData[i]
                                                ['LocationLink'] !=
                                            null
                                    ? true
                                    : false,
                                onPressDelivered: () {},
                                onPressLocation: () {
                                  if (deliveredOrdersData[i]['LocationLink'] !=
                                      null) {
                                    Functions.openGoogleMap(
                                        context,
                                        deliveredOrdersData[i]['LocationLink']
                                            .toString());
                                  } else {
                                    Functions.ShowPopUpDialog(
                                      context,
                                      'Location Not Given',
                                      Icon(
                                        Icons.error_outline_sharp,
                                        color: context
                                            .read<ThemeProvider>()
                                            .selectedPrimaryColor,
                                        size: 80,
                                      ),
                                      () => {},
                                      false,
                                      isHeader: true,
                                      isCloseBtn: true,
                                    );
                                  }
                                  // try {
                                  //   bool showLocationPopUp = false;
                                  //   if (deliveredOrdersData[i]
                                  //           ['LocationLink'] !=
                                  //       null) {
                                  //     List<String> splitted =
                                  //         deliveredOrdersData[i]
                                  //                 ['LocationLatLong']
                                  //             .split(',');
                                  //     double lat = 0.0;
                                  //     double long = 0.0;
                                  //     if (splitted.isNotEmpty) {
                                  //       try {
                                  //         lat = double.parse(splitted[0]);
                                  //         long = double.parse(splitted[1]);
                                  //         showLocationPopUp = true;
                                  //       } catch (e) {
                                  //         showLocationPopUp = false;
                                  //         if (mounted) {
                                  //           Functions.ShowPopUpDialog(
                                  //             context,
                                  //             'Location Not Correct',
                                  //             SizedBox(
                                  //               height: 60,
                                  //               width: 150,
                                  //               child: Column(
                                  //                 children: const [
                                  //                   SizedBox(
                                  //                     width: 60,
                                  //                     height: 60,
                                  //                     child: Icon(
                                  //                       size: AppConst
                                  //                           .appFontSizeh5,
                                  //                       Icons
                                  //                           .error_outline_rounded,
                                  //                       color: AppConst
                                  //                           .appColorPrimary,
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //             () {},
                                  //             false,
                                  //             isCloseBtn: true,
                                  //             isHeader: true,
                                  //           );
                                  //         }
                                  //       }
                                  //     }
                                  //     if (showLocationPopUp) {
                                  //       Functions.ShowPopUpDialog(
                                  //         context,
                                  //         'Order Location',
                                  //         SizedBox(
                                  //           width: screenSize.width * 0.8,
                                  //           height: screenSize.height * 0.6,
                                  //           child: SingleChildScrollView(
                                  //             child: Column(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.center,
                                  //               children: [
                                  //                 // Google Maps
                                  //                 SizedBox(
                                  //                   width: double.infinity,
                                  //                   height:
                                  //                       (screenSize.height *
                                  //                           0.6),
                                  //                   child: GoogleMap(
                                  //                     mapType: MapType.normal,
                                  //                     markers: <Marker>{
                                  //                       Marker(
                                  //                         draggable: true,
                                  //                         markerId:
                                  //                             const MarkerId(
                                  //                                 "1"),
                                  //                         position: LatLng(
                                  //                           lat,
                                  //                           long,
                                  //                         ),
                                  //                         icon: BitmapDescriptor
                                  //                             .defaultMarker,
                                  //                         infoWindow:
                                  //                             InfoWindow(
                                  //                           title:
                                  //                               '$lat, $long',
                                  //                         ),
                                  //                       )
                                  //                     },
                                  //                     initialCameraPosition:
                                  //                         CameraPosition(
                                  //                       target:
                                  //                           LatLng(lat, long),
                                  //                       zoom: 15.0,
                                  //                     ),
                                  //                     onMapCreated:
                                  //                         (GoogleMapController
                                  //                             controller) {
                                  //                       _controller.complete(
                                  //                           controller);
                                  //                     },
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         () {},
                                  //         false,
                                  //         isHeader: true,
                                  //         isCloseBtn: true,
                                  //       );
                                  //     }
                                  //   }
                                  // } catch (e) {
                                  //   if (mounted) {
                                  //     Functions.ShowPopUpDialog(
                                  //       context,
                                  //       'Error in location',
                                  //       SizedBox(
                                  //         height: 60,
                                  //         width: 150,
                                  //         child: Column(
                                  //           children: const [
                                  //             SizedBox(
                                  //               width: 60,
                                  //               height: 60,
                                  //               child: Icon(
                                  //                 size:
                                  //                     AppConst.appFontSizeh5,
                                  //                 Icons.error_outline_rounded,
                                  //                 color: AppConst
                                  //                     .appColorPrimary,
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       () {},
                                  //       false,
                                  //       isCloseBtn: true,
                                  //       isHeader: true,
                                  //     );
                                  //   }
                                  // }
                                },
                                onPressDetails: () async {
                                  isDetailsDataLoaded = false;
                                  isDetailsErrorGot = false;
                                  isDetailsSessionExpired = false;
                                  orderDetailData = [];
                                  dynamic orderDetailsDealsData = {};
                                  var orderDetailsIndependantData = [];
                                  dynamic result = await GetOrderDetails(
                                      deliveredOrdersData[i]);
                                  if (result[0].Data.length > 0) {
                                    orderDetailData =
                                        json.decode(result[0].Data.toString());
                                    isDetailsDataLoaded = true;
                                    isDetailsErrorGot = false;
                                    isDetailsSessionExpired = false;
                                  } else {
                                    if (result[0].ApiError['StatusCode'] ==
                                        401) {
                                      setState(() {
                                        isDetailsDataLoaded = false;
                                        isDetailsErrorGot = false;
                                        isDetailsSessionExpired = true;
                                      });
                                    } else {
                                      setState(() {
                                        isDetailsDataLoaded = false;
                                        isDetailsErrorGot = true;
                                        isDetailsSessionExpired = false;
                                      });
                                    }
                                  }
                                  if (isDetailsDataLoaded) {
                                    // Taking Independant
                                    orderDetailsIndependantData =
                                        orderDetailData['Table1'].where((elem) {
                                      return elem['ParentId'] == null;
                                    }).toList();

                                    for (int i = 0;
                                        i < orderDetailData['Table1'].length;
                                        i++) {
                                      if (orderDetailData['Table1'][i]
                                              ['ParentId'] ==
                                          null) {
                                        continue;
                                      } else {
                                        for (int j = 0;
                                            j <
                                                orderDetailsIndependantData
                                                    .length;
                                            j++) {
                                          if (orderDetailsIndependantData[j]
                                                  ['SaleInvoiceItemId'] ==
                                              orderDetailData['Table1'][i]
                                                  ['ParentId']) {
                                            if (orderDetailsDealsData[
                                                    orderDetailsIndependantData[
                                                                j][
                                                            'SaleInvoiceItemId']
                                                        .toString()] ==
                                                null) {
                                              orderDetailsDealsData[
                                                  orderDetailsIndependantData[j]
                                                          ['SaleInvoiceItemId']
                                                      .toString()] = [];
                                            } else {
                                              orderDetailsDealsData[
                                                      orderDetailsIndependantData[
                                                                  j][
                                                              'SaleInvoiceItemId']
                                                          .toString()]
                                                  .add(orderDetailData['Table1']
                                                      [i]);
                                            }
                                          }
                                        }
                                      }
                                    }
                                    // Deals Keys If Any
                                    var dealsKeys =
                                        orderDetailsDealsData.keys.toList();

                                    if (mounted) {
                                      Functions.ShowPopUpDialog(
                                        context,
                                        'Order',
                                        SizedBox(
                                          width: screenSize.width * 0.8,
                                          height: screenSize.height * 0.6,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Order
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: AppConst
                                                          .appMainPaddingLarge),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Sale Type',
                                                            style: TextStyle(
                                                              color: AppConst
                                                                  .appColorLightBlue,
                                                              fontSize: AppConst
                                                                  .appFontSizeh11,
                                                              fontWeight: AppConst
                                                                  .appTextFontWeightLight,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${orderDetailData['Table'][0]['SaleType']}',
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Token/Order #',
                                                            style: TextStyle(
                                                              color: AppConst
                                                                  .appColorLightBlue,
                                                              fontSize: AppConst
                                                                  .appFontSizeh11,
                                                              fontWeight: AppConst
                                                                  .appTextFontWeightLight,
                                                            ),
                                                          ),
                                                          Text(
                                                            deliveredOrdersData[i]
                                                                            [
                                                                            'TokenNumber'] !=
                                                                        null &&
                                                                    orderDetailData['Table'][0]
                                                                            [
                                                                            'InvoiceNumber'] !=
                                                                        null
                                                                ? '${deliveredOrdersData[i]['TokenNumber']}/${orderDetailData['Table'][0]['InvoiceNumber']}'
                                                                : AppConst
                                                                    .nullString,
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Order Amt.',
                                                            style: TextStyle(
                                                              color: AppConst
                                                                  .appColorLightBlue,
                                                              fontSize: AppConst
                                                                  .appFontSizeh11,
                                                              fontWeight: AppConst
                                                                  .appTextFontWeightLight,
                                                            ),
                                                          ),
                                                          Text(
                                                            formatNumber.format(
                                                                orderDetailData[
                                                                        'Table'][0]
                                                                    [
                                                                    'NetAmount']),
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Order Date',
                                                            style: TextStyle(
                                                              color: AppConst
                                                                  .appColorLightBlue,
                                                              fontSize: AppConst
                                                                  .appFontSizeh11,
                                                              fontWeight: AppConst
                                                                  .appTextFontWeightLight,
                                                            ),
                                                          ),
                                                          Text(
                                                            orderDetailData['Table']
                                                                            [0][
                                                                        'InvoiceDate'] !=
                                                                    null
                                                                ? '${DateTime.parse(orderDetailData['Table'][0]['InvoiceDate']).day}-${AppConst.months[DateTime.parse(orderDetailData['Table'][0]['InvoiceDate']).month - 1]}-${DateTime.parse(orderDetailData['Table'][0]['InvoiceDate']).year} ${Functions.formatTimeOfDay(orderDetailData['Table'][0]['InvoiceDate'])}'
                                                                : '-- : --',
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Delivery Date',
                                                            style: TextStyle(
                                                              color: AppConst
                                                                  .appColorLightBlue,
                                                              fontSize: AppConst
                                                                  .appFontSizeh11,
                                                              fontWeight: AppConst
                                                                  .appTextFontWeightLight,
                                                            ),
                                                          ),
                                                          Text(
                                                            orderDetailData['Table']
                                                                            [0][
                                                                        'DeliveryDate'] !=
                                                                    null
                                                                ? '${DateTime.parse(orderDetailData['Table'][0]['DeliveryDate']).day}-${AppConst.months[DateTime.parse(orderDetailData['Table'][0]['DeliveryDate']).month - 1]}-${DateTime.parse(orderDetailData['Table'][0]['DeliveryDate']).year} ${Functions.formatTimeOfDay(orderDetailData['Table'][0]['DeliveryDate'])}'
                                                                : '-- : --',
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Delivery Branch',
                                                            style: TextStyle(
                                                              color: AppConst
                                                                  .appColorLightBlue,
                                                              fontSize: AppConst
                                                                  .appFontSizeh11,
                                                              fontWeight: AppConst
                                                                  .appTextFontWeightLight,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${orderDetailData['Table'][0]['CompanyBranch']}',
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Order Branch',
                                                            style: TextStyle(
                                                              color: AppConst
                                                                  .appColorLightBlue,
                                                              fontSize: AppConst
                                                                  .appFontSizeh11,
                                                              fontWeight: AppConst
                                                                  .appTextFontWeightLight,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${orderDetailData['Table'][0]['OrderBranch']}',
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Client Name',
                                                            style: TextStyle(
                                                              color: AppConst
                                                                  .appColorLightBlue,
                                                              fontSize: AppConst
                                                                  .appFontSizeh11,
                                                              fontWeight: AppConst
                                                                  .appTextFontWeightLight,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${orderDetailData['Table'][0]['ClientName']}',
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Order Source',
                                                            style: TextStyle(
                                                              color: AppConst
                                                                  .appColorLightBlue,
                                                              fontSize: AppConst
                                                                  .appFontSizeh11,
                                                              fontWeight: AppConst
                                                                  .appTextFontWeightLight,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${orderDetailData['Table'][0]['CommunicateType']}',
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight),
                                                          )
                                                        ],
                                                      ),
                                                      // Row(
                                                      //   mainAxisAlignment:
                                                      //       MainAxisAlignment
                                                      //           .spaceBetween,
                                                      //   children: [
                                                      //     const Text(
                                                      //       'Location',
                                                      //       style: TextStyle(
                                                      //         color: AppConst
                                                      //             .appColorLightBlue,
                                                      //         fontSize: AppConst
                                                      //             .appFontSizeh11,
                                                      //         fontWeight: AppConst
                                                      //             .appTextFontWeightLight,
                                                      //       ),
                                                      //     ),
                                                      //     Text(
                                                      //       orderDetailData['Table']
                                                      //                       [
                                                      //                       0]
                                                      //                   [
                                                      //                   'LocationLatLong'] !=
                                                      //               null
                                                      //           ? '${orderDetailData['Table'][0]['LocationLatLong']}'
                                                      //           : '-- : --',
                                                      //       style: const TextStyle(
                                                      //           fontSize: AppConst
                                                      //               .appFontSizeh11,
                                                      //           fontWeight:
                                                      //               AppConst
                                                      //                   .appTextFontWeightLight),
                                                      //     )
                                                      //   ],
                                                      // ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: const [
                                                          Text(
                                                            'Order Remarks',
                                                            style: TextStyle(
                                                              color: AppConst
                                                                  .appColorLightBlue,
                                                              fontSize: AppConst
                                                                  .appFontSizeh11,
                                                              fontWeight: AppConst
                                                                  .appTextFontWeightLight,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            orderDetailData['Table']
                                                                            [0][
                                                                        'Remarks'] !=
                                                                    ' '
                                                                ? '${orderDetailData['Table'][0]['Remarks']}'
                                                                : '-- : --',
                                                            style: const TextStyle(
                                                                fontSize: AppConst
                                                                    .appFontSizeh11,
                                                                fontWeight: AppConst
                                                                    .appTextFontWeightLight),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                // Order Details
                                                const Text(
                                                  'Order Details',
                                                  style: TextStyle(
                                                    fontSize:
                                                        AppConst.appFontSizeh13,
                                                    fontWeight: AppConst
                                                        .appTextFontWeightMedium,
                                                  ),
                                                ),
                                                // Header
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .only(
                                                      top: AppConst
                                                          .appMainPaddingSmall),
                                                  child: Container(
                                                    height:40,
                                                   
                                                    color:  AppConst
                                                                  .appColorLightBlue,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10,
                                                          horizontal: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: const [
                                                                SizedBox(
                                                                  width: 100.0,
                                                                  child: Text(
                                                                    'Item Name',
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppConst
                                                                          .appColorWhite,
                                                                      fontSize:
                                                                          AppConst
                                                                              .appFontSizeh11,
                                                                      fontWeight:
                                                                          AppConst
                                                                              .appTextFontWeightBold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 60.0,
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Price',
                                                                      style:
                                                                          TextStyle(
                                                                        color: AppConst
                                                                            .appColorWhite,
                                                                        fontSize:
                                                                            AppConst.appFontSizeh11,
                                                                        fontWeight:
                                                                            AppConst.appTextFontWeightBold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 102.0,
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            5.0),
                                                                child: Text(
                                                                  'Quantity',
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppConst
                                                                        .appColorWhite,
                                                                    fontSize:
                                                                        AppConst
                                                                            .appFontSizeh11,
                                                                    fontWeight:
                                                                        AppConst
                                                                            .appTextFontWeightBold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                for (int outer = 0;
                                                    outer <
                                                        orderDetailsIndependantData
                                                            .length;
                                                    outer++)
                                                  dealsKeys.contains(
                                                          orderDetailsIndependantData[
                                                                      outer][
                                                                  'SaleInvoiceItemId']
                                                              .toString())
                                                      ? ExpansionTile(
                                                          title: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    '${orderDetailsIndependantData[outer]['LongName']}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            AppConst
                                                                                .appFontSizeh11,
                                                                        fontWeight:
                                                                            AppConst.appTextFontWeightLight),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        AppConst
                                                                            .appMainPaddingMedium),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          100.0,
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          70.0,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          formatNumber.format(orderDetailsIndependantData[outer]
                                                                              [
                                                                              'SaleRate']),
                                                                          style: const TextStyle(
                                                                              fontSize: AppConst.appFontSizeh11,
                                                                              fontWeight: AppConst.appTextFontWeightLight),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // Container(
                                                                    //   width: 70.0,
                                                                    //   child: Center(
                                                                    //     child: Text(
                                                                    //       '${orderDetailData['Table1'][outer]['Quantity']}',
                                                                    //       style: const TextStyle(
                                                                    //           fontSize: AppConst
                                                                    //               .appFontSizeh11,
                                                                    //           fontWeight:
                                                                    //           AppConst
                                                                    //               .appTextFontWeightLight),
                                                                    //     ),
                                                                    //   ),
                                                                    // )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          trailing: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 23.0),
                                                            child: Container(
                                                              width: 60.0,
                                                              child: Center(
                                                                child: Text(
                                                                  formatNumber.format(
                                                                      orderDetailData['Table1']
                                                                              [
                                                                              outer]
                                                                          [
                                                                          'Quantity']),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          AppConst
                                                                              .appFontSizeh11,
                                                                      fontWeight:
                                                                          AppConst
                                                                              .appTextFontWeightLight),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          children: [
                                                            for (int inner = 0;
                                                                inner <
                                                                    orderDetailsDealsData[
                                                                            orderDetailsIndependantData[outer]['SaleInvoiceItemId'].toString()]
                                                                        .length;
                                                                inner++)
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        AppConst
                                                                            .appMainPaddingSmall),
                                                                child: Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              AppConst.appMainPaddingMedium),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            '${orderDetailsDealsData[orderDetailsIndependantData[outer]['SaleInvoiceItemId'].toString()][inner]['LongName']}',
                                                                            style:
                                                                                const TextStyle(fontSize: AppConst.appFontSizeh11, fontWeight: AppConst.appTextFontWeightLight),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              AppConst.appMainPaddingMedium),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                100.0,
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                80.0,
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                60.0,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                formatNumber.format(orderDetailsDealsData[orderDetailsIndependantData[outer]['SaleInvoiceItemId'].toString()][inner]['Quantity']),
                                                                                style: const TextStyle(fontSize: AppConst.appFontSizeh11, fontWeight: AppConst.appTextFontWeightLight),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                          ],
                                                        )
                                                      : Padding(
                                                          padding: const EdgeInsets
                                                                  .fromLTRB(
                                                              AppConst
                                                                  .appMainPaddingMedium,
                                                              AppConst
                                                                  .appMainPaddingMedium,
                                                              0,
                                                              0),
                                                          child: Column(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  '${orderDetailsIndependantData[outer]['LongName']}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          AppConst
                                                                              .appFontSizeh11,
                                                                      fontWeight:
                                                                          AppConst
                                                                              .appTextFontWeightLight),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              100.0,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              80.0,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              formatNumber.format(orderDetailsIndependantData[outer]['SaleRate']),
                                                                              style: const TextStyle(fontSize: AppConst.appFontSizeh11, fontWeight: AppConst.appTextFontWeightLight),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            12.0,
                                                                        left:
                                                                            5.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          90.0,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          formatNumber.format(orderDetailData['Table1'][outer]
                                                                              [
                                                                              'Quantity']),
                                                                          style: const TextStyle(
                                                                              fontSize: AppConst.appFontSizeh11,
                                                                              fontWeight: AppConst.appTextFontWeightLight),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
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
                                  } else if (isDetailsSessionExpired) {
                                    if (mounted) {
                                      Functions.ShowPopUpDialog(
                                          context,
                                          'Session Expired',
                                          SizedBox(
                                            height: 60,
                                            width: 150,
                                            child: Column(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    // Foreground color
                                                    onPrimary:
                                                        AppConst.appColorAccent,
                                                    // Background color
                                                    primary: AppConst
                                                        .appColorPrimary,
                                                    fixedSize:
                                                        const Size(80, 60),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(AppConst
                                                                .appButtonsBorderRadiusMed)),
                                                  ).copyWith(
                                                          elevation:
                                                              ButtonStyleButton
                                                                  .allOrNull(
                                                                      0.0)),
                                                  child: const Text(
                                                    'Login',
                                                    style: TextStyle(
                                                        fontSize: AppConst
                                                            .appFontSizeh10,
                                                        fontWeight: AppConst
                                                            .appTextFontWeightMedium),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          () {},
                                          false,
                                          isCloseBtn: false,
                                          isHeader: true);
                                    }
                                  } else if (isDetailsErrorGot) {
                                    if (mounted) {
                                      Functions.ShowPopUpDialog(
                                        context,
                                        'Something went wrong',
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
                                                  color: context
                                                      .read<ThemeProvider>()
                                                      .selectedPrimaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        () {},
                                        false,
                                        isCloseBtn: false,
                                        isHeader: true,
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
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: context
                                                        .read<ThemeProvider>()
                                                        .selectedPrimaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          () {},
                                          false,
                                          isCloseBtn: false,
                                          isHeader: false);
                                    }
                                  }
                                },
                                isDelivered: true,
                              );
                            },
                          ),
                        ),
                      )
                    : const Center(
                        child: Text(
                          'No Orders',
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
