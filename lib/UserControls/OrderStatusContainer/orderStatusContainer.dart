import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/Functions/functions.dart';
import '../../Generic/appConst.dart';

class OrderStatusContainer extends StatefulWidget {
  final String? expectedTime;
  final String? orderNo;
  final String dateText;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerRemarks;
  
  final bool showLocation;
  final double amount;
  final VoidCallback onPressDelivered;
  final VoidCallback onPressDetails;
  final bool isDelivered;
  final VoidCallback onPressLocation;
  const OrderStatusContainer({
    Key? key,
    required this.expectedTime,
    required this.orderNo,
    required this.dateText,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerRemarks,
    required this.showLocation,
    required this.amount,
    required this.onPressDelivered,
    required this.onPressDetails,
    required this.isDelivered,
    required this.onPressLocation,
  }) : super(key: key);

  @override
  State<OrderStatusContainer> createState() => _OrderStatusContainerState();
}

class _OrderStatusContainerState extends State<OrderStatusContainer> {
  
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    NumberFormat formatNumber = NumberFormat.decimalPattern('en_us');
    // const double containerHeight = 250.0;
    return GestureDetector(
      onTap: () {
        widget.onPressDetails();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppConst.appMainPaddingMedium),
        child: PhysicalModel(
          color: Colors.transparent,
          elevation: 5.0,
          child: IntrinsicHeight(
            child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  // Order No. Container
                  Container(
                    // height: containerHeight,
                    width: 120.0,
                    decoration: const BoxDecoration(
                      color: AppConst.appColorLightBlue,
                      // borderRadius: BorderRadius.only(
                      //   topLeft: Radius.circular(
                      //       AppConst.appOrderStatusContainersBorderRadius),
                      //   bottomLeft: Radius.circular(
                      //       AppConst.appOrderStatusContainersBorderRadius),
                      // ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.expectedTime != null ? Padding(
                          padding: const EdgeInsets.only(top: AppConst.appMainPaddingExtraSmall,),
                          child: Text(
                            '${widget.expectedTime}',
                            style: TextStyle(
                              color: context.read<ThemeProvider>().selectedPrimaryColor,
                              fontSize: AppConst.appFontSizeh11,
                              fontWeight: AppConst.appTextFontWeightLight,
                            ),
                          ),
                        ) : Container(),
                        Padding(
                          padding: EdgeInsets.only(top: widget.expectedTime != null ? 0.0 : AppConst.appMainPaddingExtraSmall),
                          child: const Text(
                            'Order No. #',
                            style: TextStyle(
                              color: AppConst.appColorWhite,
                              fontSize: AppConst.appFontSizeh11,
                              fontWeight: AppConst.appTextFontWeightLight,
                            ),
                          ),
                        ),
                        Text(
                          widget.orderNo!,
                          style: const TextStyle(
                            color: AppConst.appColorWhite,
                            fontSize: AppConst.appFontSizeh8,
                            fontWeight: AppConst.appTextFontWeightMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: AppConst.appMainPaddingSmall),
                          child: Text(
                            widget.dateText != '-- --'
                                ? Functions.parseDateString(widget.dateText)
                                : '-- --',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppConst.appColorWhite,
                              fontSize: AppConst.appFontSizeh11,
                              fontWeight: AppConst.appTextFontWeightLight,
                            ),
                            
                          ),
                          
                          
                        ),
                       
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: AppConst.appMainPaddingExtraSmall),
                              child: !widget.isDelivered
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        // Foreground color
                                        onPrimary: AppConst.appColorWhite,
                                        // Background color
                                        // primary: AppConst.appColorLightBlue,
                                        fixedSize: const Size(95.0, 30.0),
                                        shape: RoundedRectangleBorder(
                                          // borderRadius: BorderRadius.circular(
                                          //     AppConst.appButtonsBorderRadiusSam),
                                          side: BorderSide(
                                            color: AppConst.appColorLightBlue.withOpacity(0.8),
                                            width: 1.0,
                                          ),
                                        ),
                                      ).copyWith(
                                          elevation:
                                              ButtonStyleButton.allOrNull(0.0)),
                                      onPressed: () {
                                        widget.onPressDelivered();
                                      },
                                      child: const Text(
                                        'Deliver',
                                        style: TextStyle(
                                          fontSize: AppConst.appFontSizeh11,
                                          fontWeight:
                                              AppConst.appTextFontWeightMedium,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Container(
                      // height: containerHeight,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConst.appMainPaddingExtraSmall,
                        horizontal: AppConst.appMainPaddingSmall,
                      ),
                      decoration: const BoxDecoration(
                        color: AppConst.appColorWhite,
                        // borderRadius: BorderRadius.only(
                        //   topRight: Radius.circular(
                        //       AppConst.appOrderStatusContainersBorderRadius),
                        //   bottomRight: Radius.circular(
                        //       AppConst.appOrderStatusContainersBorderRadius),
                        // ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Customer Name
                          Text(
                            widget.customerName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: AppConst.appColorBlack,
                              fontSize: AppConst.appFontSizeh10,
                              fontWeight: AppConst.appTextFontWeightMedium,
                            ),
                          ),
                          // Customer Phone Number
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone_android_sharp,
                                      color: context.read<ThemeProvider>().selectedPrimaryColor,
                                      size: AppConst.appFontSizeh9,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Functions.makePhoneCall(
                                            widget.customerPhone.trimLeft());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        // Foreground color
                                        onPrimary: AppConst.appColorLightBlue,
                                        // Background color
                                        primary: AppConst.appColorWhite,
                                        fixedSize:
                                            Size(screenSize.width * 0.35, 40.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppConst
                                                    .appButtonsBorderRadiusMed)),
                                      ).copyWith(
                                          elevation:
                                              ButtonStyleButton.allOrNull(0.0)),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.customerPhone.trimLeft(),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: AppConst.appFontSizeh11,
                                            fontWeight:
                                                AppConst.appTextFontWeightMedium,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                widget.showLocation
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 50.0,
                                            child: Center(
                                              child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                onPressed: () {
                                                  widget.onPressLocation();
                                                },
                                                icon: Icon(
                                                  Icons.location_on_sharp,
                                                  color: context.read<ThemeProvider>().selectedPrimaryColor,
                                                  size: AppConst.appFontSizeh8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          // Customer Address
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppConst.appMainPaddingLarge),
                            child: Text(
                              widget.customerAddress,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: const TextStyle(
                                color: AppConst.appColorBlack,
                                fontSize: AppConst.appFontSizeh11,
                                fontWeight: AppConst.appTextFontWeightLight,
                              ),
                            ),
                          ),

                          // Customer Address
                          widget.customerRemarks != 'null' ? Padding(
                            padding: const EdgeInsets.only(bottom: AppConst.appMainPaddingLarge),
                            child: Text(
                              widget.customerRemarks,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: const TextStyle(
                                color: AppConst.appColorBlack,
                                fontSize: AppConst.appFontSizeh11,
                                fontWeight: AppConst.appTextFontWeightLight,
                              ),
                            ),
                          ) : Container(),

                          // Amount and Button Container
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Amount Column
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Amount Container
                                    const Text(
                                      'Amount',
                                      style: TextStyle(
                                        color: AppConst.appColorGrey,
                                        fontSize: AppConst.appFontSizeh10,
                                        fontWeight:
                                            AppConst.appTextFontWeightLight,
                                      ),
                                    ),
                                    // Amount in Number Container
                                    Text(
                                      formatNumber.format(widget.amount),
                                      style: const TextStyle(
                                        color: AppConst.appColorBlack,
                                        fontSize: AppConst.appFontSizeh10,
                                        fontWeight:
                                            AppConst.appTextFontWeightMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                // Delivered Button
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     Column(
                                //       mainAxisAlignment: MainAxisAlignment.end,
                                //       crossAxisAlignment: CrossAxisAlignment.end,
                                //       children: [
                                //         !isDelivered
                                //             ? ElevatedButton(
                                //                 style: ElevatedButton.styleFrom(
                                //                   // Foreground color
                                //                   onPrimary:
                                //                       AppConst.appColorWhite,
                                //                   // Background color
                                //                   primary:
                                //                       AppConst.appColorLightBlue,
                                //                   fixedSize:
                                //                       const Size(85.0, 50.0),
                                //                   // shape: RoundedRectangleBorder(
                                //                   //   borderRadius: BorderRadius.circular(
                                //                   //       AppConst.appButtonsBorderRadiusSam),
                                //                   // ),
                                //                 ).copyWith(
                                //                     elevation: ButtonStyleButton
                                //                         .allOrNull(0.0)),
                                //                 onPressed: () {
                                //                   onPressDelivered();
                                //                 },
                                //                 child: const Text(
                                //                   'Deliver',
                                //                   style: TextStyle(
                                //                     fontSize:
                                //                         AppConst.appFontSizeh11,
                                //                     fontWeight: AppConst
                                //                         .appTextFontWeightMedium,
                                //                   ),
                                //                 ),
                                //               )
                                //             : Container(
                                //                 color: AppConst.appColorSeparator,
                                //                 width: 85.0,
                                //                 height: 50.0,
                                //                 child: const Center(
                                //                   child: Text(
                                //                     'Delivered',
                                //                     style: TextStyle(
                                //                       fontSize:
                                //                           AppConst.appFontSizeh11,
                                //                       fontWeight: AppConst
                                //                           .appTextFontWeightMedium,
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ),
                                //       ],
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    
    );
  }
}
