import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_app_development/DataLayer/Providers/APIConnectionProvider/apiConnectionProvider.dart';
import 'package:ts_app_development/DataLayer/Providers/ThemeProvider/themeProvider.dart';
import 'package:ts_app_development/DataLayer/Providers/UserProvider/userProvider.dart';
import 'package:ts_app_development/Screens/genericScreen.dart';
import '../DataLayer/Models/ApiResponse/ApiResponse.dart';
import '../DataLayer/Providers/DataProvider/dataProvider.dart';
import '../DataLayer/Providers/DateTimeRangeProvider/dateTimeRangeProvider.dart';
import '../DataLayer/Providers/LocationProvider/location.dart';
import '../DataLayer/Services/AuthenticationService/authenticationService.dart';
import '../Generic/Functions/functions.dart';
import '../Generic/appConst.dart';
import '../Screens/SplashScreen/splashScreen.dart';
import '../UserControls/PopUpDialog/popupDialog.dart';

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late dynamic user;
  bool isUser = false;
  ApiResponse rolesDataFuture = ApiResponse();
  List<dynamic> rolesData = [];
  bool isDataLoaded = false;
  bool navigateToSplash = false;
  bool somethingWrong = false;

  @override
  void initState() {
    isDataLoaded = false;
    navigateToSplash = false;
    somethingWrong = false;
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (mounted) {
        UserSessionProvider userProvider =
            Provider.of<UserSessionProvider>(context, listen: false);
        DataProvider dataProvider =
            Provider.of<DataProvider>(context, listen: false);
        DateTimeRangeProvider dateTime =
            Provider.of<DateTimeRangeProvider>(context, listen: false);
        APIConnectionProvider apiProvider =
            Provider.of<APIConnectionProvider>(context, listen: false);
        // Checking Session Setting In Provider Data
        user = await userProvider.checkUserSession();
        await dateTime.setDefaultDateTime(DateTime.now());
        await dateTime.setCustomDate(DateTime.now(), DateTime.now());
        await dateTime.setThreeMonthsDate(DateTime.now());
        await dateTime.setTwelveMonthsDate(DateTime.now());
        // Services
        if (user) {
          apiProvider.setAppKey();
          // Getting The Theme
          final prefs = await SharedPreferences.getInstance();
          // Try reading data from the counter key. If it doesn't exist, return 0.
          final primaryColor = prefs.getString('primaryColor') ?? '';
          if (primaryColor != '') {
            if (mounted) {
              context
                  .read<ThemeProvider>()
                  .setPrimaryColor(int.parse(primaryColor));
            }
          }
          dynamic result;
          result = await APICalls();
          if (result[0].ApiError.length > 0) {
            if (result[0].ApiError['StatusCode'] == 401) {
              setState(() {
                navigateToSplash = true;
                isDataLoaded = false;
                somethingWrong = false;
              });
            } else {
              setState(() {
                navigateToSplash = false;
                isDataLoaded = true;
                somethingWrong = false;
              });
              if (mounted) {
                Functions.ShowSnackBar(
                    context, 'Something went wrong while getting menu.');
              }
            }
          } else if (result[0].Data.length >= 0) {
            if (result[0].Data.contains("[{") && result[0].Data.length > 0) {
              rolesData = Functions.convertToListOfObjects(result[0].Data);
              await dataProvider.setRolesData(rolesData);
            }
            setState(() {
              isDataLoaded = true;
              navigateToSplash = false;
              somethingWrong = false;
            });
          }
        } else {
          setState(() {
            navigateToSplash = true;
            isDataLoaded = false;
            somethingWrong = false;
          });
        }
      }
    });
    super.initState();
  }

  Future<List<ApiResponse>> APICalls() async {
    rolesDataFuture = await AuthenticationService.getRolesDetails({
      'appid': '6289',
    });
    return [rolesDataFuture];
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status\n${e.toString()}');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (_connectionStatus.toString() != 'ConnectivityResult.none') {
      if (isDataLoaded) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaleFactor: Functions.getScaleFactor(screenSize)),
            child: GenericScreen(
              route: '/Dashboard',
            ));
      } else if (navigateToSplash) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaleFactor: Functions.getScaleFactor(screenSize)),
            child: const SplashScreen());
      } else if (somethingWrong) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaleFactor: Functions.getScaleFactor(screenSize)),
          child: Scaffold(
            body: PopUpDialog(
              title: 'Something went wrong',
              content: SizedBox(
                height: 60,
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please try again later.',
                      style: TextStyle(
                          fontSize: AppConst.appFontSizeh10,
                          color:
                          context.read<ThemeProvider>().selectedPrimaryColor),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.pushReplacementNamed(context, '/splash');
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     // Foreground color
                    //     onPrimary: AppConst.appColorAccent,
                    //     // Background color
                    //     primary: context.read<ThemeProvider>().selectedPrimaryColor,
                    //     fixedSize: const Size(150, 60),
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(
                    //             AppConst.appButtonsBorderRadiusMed)),
                    //   ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    //   child: const Text(
                    //     'Login',
                    //     style: TextStyle(
                    //         fontSize: AppConst.appFontSizeh10,
                    //         fontWeight: AppConst.appTextFontWeightMedium),
                    //   ),
                    // ),
                  ],
                ),
              ),
              onPressYes: () => {},
              isAction: false,
              isCloseBtn: false,
              isHeader: true,
            ),
          ),
        );
      } else {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaleFactor: Functions.getScaleFactor(screenSize)),
          child: Scaffold(
            body: PopUpDialog(
              title: 'Awaiting Result',
              content: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        color:
                            context.read<ThemeProvider>().selectedPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              onPressYes: () => {},
              isAction: false,
              isHeader: false,
              isCloseBtn: false,
            ),
          ),
        );
      }
    } else {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: Functions.getScaleFactor(screenSize)),
        child: Scaffold(
          body: PopUpDialog(
            title: 'No Internet Connection',
            content: IntrinsicHeight(
              child: Column(
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Icon(
                      size: AppConst.appFontSizeh5,
                      Icons.network_locked,
                      color: context.read<ThemeProvider>().selectedPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
            onPressYes: () => {},
            isAction: false,
            isHeader: true,
            isCloseBtn: false,
          ),
        ),
      );
    }
  }
}
