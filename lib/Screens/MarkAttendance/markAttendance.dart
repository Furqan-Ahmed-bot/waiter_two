import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ts_app_development/DataLayer/Providers/DataProvider/dataProvider.dart';
import 'package:ts_app_development/DataLayer/Providers/UserProvider/userProvider.dart';
import 'package:ts_app_development/DataLayer/Services/AttendanceService/attendanceService.dart';
import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/Functions/functions.dart';
import '../../Generic/appConst.dart';
import '../../DataLayer/Providers/LocationProvider/location.dart';
import '../../UserControls/AnimatedSwipeButton/animatedSwipeButton.dart';
import '../../UserControls/AttendanceButton/attendanceButton.dart';
import '../../UserControls/PopUpDialog/popupDialog.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({Key? key}) : super(key: key);

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  final TextEditingController _remarksController = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  List<Map<String, dynamic>> isSelectedList = [];
  bool isDataDone = false;
  bool isMarkAttendance = false;
  bool isMarkAttendanceLoading = false;
  bool isErrorGot = false;
  var selectedAttendanceTypeId = "";
  var selectedAttendanceType = "";

  @override
  void initState() {
    super.initState();
    isDataDone = false;
    isMarkAttendance = false;
    isMarkAttendanceLoading = false;
    isErrorGot = false;
    isSelectedList = [];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      DataProvider dataProvider =
          Provider.of<DataProvider>(context, listen: false);
      if (dataProvider.attendanceStatusData.isNotEmpty) {
        for (int i = 0; i < dataProvider.attendanceStatusData.length; i++) {
          if (i == 0) {
            isSelectedList.add({
              'AttendanceType': dataProvider.attendanceStatusData[i]
                  ['AttendanceType'],
              'isSelected': true,
              'AttendanceTypeId': dataProvider.attendanceStatusData[i]
                  ['AttendanceTypeId'],
            });
            selectedAttendanceType =
                dataProvider.attendanceStatusData[i]['AttendanceType'];
          } else {
            isSelectedList.add({
              'AttendanceType': dataProvider.attendanceStatusData[i]
                  ['AttendanceType'],
              'isSelected': false,
              'AttendanceTypeId': dataProvider.attendanceStatusData[i]
                  ['AttendanceTypeId'],
            });
          }
        }
        setState(() {
          isDataDone = true;
        });
      } else {
        setState(() {
          isErrorGot = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // Providers to Get the data
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    UserSessionProvider userProvider =
        Provider.of<UserSessionProvider>(context);
    LocationIdentifier locationProvider =
        Provider.of<LocationIdentifier>(context);

    if (isDataDone) {
      return SingleChildScrollView(
        child: Column(
          children: [
            // Google Maps
            SizedBox(
              width: double.infinity,
              height: (screenSize.height / 2),
              child: GoogleMap(
                mapType: MapType.normal,
                markers: <Marker>{
                  Marker(
                    draggable: true,
                    markerId: const MarkerId("1"),
                    position: LatLng(locationProvider.currentLocation.latitude!,
                        locationProvider.currentLocation.longitude!),
                    icon: BitmapDescriptor.defaultMarker,
                    infoWindow: InfoWindow(
                      title: locationProvider.address.postalCode.toString(),
                    ),
                  )
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      context
                          .read<LocationIdentifier>()
                          .currentLocation
                          .latitude!,
                      context
                          .read<LocationIdentifier>()
                          .currentLocation
                          .longitude!),
                  zoom: 15.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),

            // Text
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppConst.appMainPaddingSmall,
                    horizontal: AppConst.appMainPaddingSmall),
                child: Column(
                  children: [
                    // Location Container
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: AppConst.appMainPaddingLarge),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Location',
                              style: TextStyle(
                                fontSize: AppConst.appFontSizeh11,
                                fontWeight: AppConst.appTextFontWeightMedium,
                              ),
                            ),
                            Text(
                              '${locationProvider.address.name}, ${locationProvider.address.street}, ${locationProvider.address.subLocality}, ${locationProvider.address.locality}, ${locationProvider.address.country}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: AppConst.appFontSizeh11,
                                fontWeight: AppConst.appTextFontWeightMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Buttons Container
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: AppConst.appMainPaddingLarge),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          runSpacing: AppConst.appMainPaddingSmall,
                          spacing: AppConst.appMainPaddingMedium,
                          alignment: WrapAlignment.start,
                          children: [
                            for (int i = 0;
                                i < dataProvider.attendanceStatusData.length;
                                i++)
                              AttendanceButton(
                                icon: dataProvider.attendanceStatusData[i]
                                ['AttendanceType'] != null ? AppConst.markAttendanceStatusIcons[
                                    dataProvider.attendanceStatusData[i]
                                        ['AttendanceType']] : const Icon(Icons.breakfast_dining),
                                buttonText: dataProvider.attendanceStatusData[i]
                                    ['AttendanceType'],
                                buttonColor: AppConst.appColorWhite,
                                isSelected:
                                    isSelectedList[i]['isSelected'] ?? false,
                                onPress: () {
                                  setState(() {
                                    for (int t = 0;
                                        t < isSelectedList.length;
                                        t++) {
                                      isSelectedList[t]['isSelected'] = false;
                                    }
                                    for (int j = 0;
                                        j < isSelectedList.length;
                                        j++) {
                                      if (isSelectedList[j]['AttendanceType'] ==
                                          dataProvider.attendanceStatusData[i]
                                              ['AttendanceType']) {
                                        isSelectedList[j]['isSelected'] = true;
                                        // selectedAttendanceTypeId =
                                        //     dataProvider.attendanceStatusData[i]
                                        //         ['AttendanceTypeId'];
                                        selectedAttendanceType =
                                            dataProvider.attendanceStatusData[i]
                                                ['AttendanceType'];
                                      }
                                    }
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Remarks Text Field
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: AppConst.appMainPaddingLarge),
                      child: TextFormField(
                        controller: _remarksController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: context.read<ThemeProvider>().selectedPrimaryColor,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: context.read<ThemeProvider>().selectedPrimaryColor,
                                width: 2.0,
                              ),
                            ),
                            // icon: Icon(Icons.person),
                            hintText: 'Remarks',
                            hintStyle: TextStyle(
                              fontSize: AppConst.appFontSizeh10,
                              fontWeight: AppConst.appTextHintFontWeight,
                            )),
                        onSaved: (String? value) {},
                        validator: (String? value) {
                          return (value != null && value.length < 50)
                              ? 'Please enter Valid Login Id'
                              : null;
                        },
                      ),
                    ),

                    // Swipe Button
                    AnimatedSwipeButton(
                      buttonText: selectedAttendanceType,
                      onConfirm: () async {
                        setState(() {
                          isMarkAttendance = true;
                          isMarkAttendanceLoading = true;
                        });
                        if (isMarkAttendanceLoading) {
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
                                      CircularProgressIndicator(color: context.read<ThemeProvider>().selectedPrimaryColor,),
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
                        for (int i = 0; i < isSelectedList.length; i++) {
                          if (isSelectedList[i]['isSelected']) {
                            setState(() {
                              selectedAttendanceTypeId = isSelectedList[i]
                              ['AttendanceTypeId']
                                  .toString();
                              selectedAttendanceType = isSelectedList[i]
                              ['AttendanceType']
                                  .toString();
                            });
                          }
                        }
                        if (selectedAttendanceTypeId.isNotEmpty) {
                          final result =
                          await AttendanceService.saveAttendanceRecord({
                            'EmployeeInformationId':
                            userProvider.userData['EmployeeInformationId'].toString(),
                            'AttendanceTypeId': selectedAttendanceTypeId,
                            'UserId':
                            userProvider.userData['UserId'].toString(),
                            'latitude': locationProvider
                                .currentLocation.latitude
                                .toString(),
                            'longitude': locationProvider
                                .currentLocation.longitude
                                .toString(),
                            'currentLocation':
                            '${locationProvider.address.name}, ${locationProvider.address.street}, ${locationProvider.address.subLocality}, ${locationProvider.address.locality}, ${locationProvider.address.country}',
                            'remarks': _remarksController.text.trim(),
                          });
                          if (result.Data.toString().contains('Success')) {
                            if (mounted) {
                              Navigator.pop(context);
                            }
                            setState(() {
                              _remarksController.text = '';
                              isMarkAttendance = false;
                              isMarkAttendanceLoading = false;
                            });
                            if (mounted) {
                              Functions.ShowPopUpDialog(
                                context,
                                'Updated Successfully.',
                                Icon(
                                  Icons.done_outline_outlined,
                                  color: context.read<ThemeProvider>().selectedPrimaryColor,
                                  size: 80,
                                ),
                                    () => {},
                                false,
                                isHeader: true,
                                isCloseBtn: true,
                              );
                              // Navigator.pushReplacementNamed(
                              //     context, '/MarkAttendanceNew');
                            }
                          } else {
                            setState(() {
                              selectedAttendanceType = 'Something went wrong.';
                              isMarkAttendance = false;
                            });
                            if (mounted) {
                              Functions.ShowPopUpDialog(
                                context,
                                'Something went wrong.',
                                Column(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: context.read<ThemeProvider>().selectedPrimaryColor,
                                      size: 60,
                                    ),
                                  ],
                                ),
                                    () {},
                                false,
                                isHeader: true,
                                isCloseBtn: true,
                              );
                            }
                          }
                        } else {
                          setState(() {
                            _remarksController.text = '';
                            isMarkAttendance = false;
                          });
                          Functions.ShowPopUpDialog(
                            context,
                            'Please Select Any Option.',
                            Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: context.read<ThemeProvider>().selectedPrimaryColor,
                                  size: 60,
                                ),
                              ],
                            ),
                                () {},
                            false,
                            isHeader: true,
                            isCloseBtn: true,
                          );
                          Navigator.pushReplacementNamed(
                              context, '/MarkAttendanceNew');
                        }
                      },
                      onCancel: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (isErrorGot) {
      return PopUpDialog(
        title: 'Something went wrong.',
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
        isHeader: false,
        isCloseBtn: false,
      );
    } else if(isMarkAttendance) {
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
        isHeader: false,
        isCloseBtn: false,
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
        isHeader: false,
        isCloseBtn: false,
      );
    }
  }
}
