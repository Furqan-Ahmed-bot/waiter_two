import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ts_app_development/UserControls/AppLargeButton/appLargeButton.dart';
import 'package:ts_app_development/UserControls/PageRouteBuilder/pageRouteBuilder.dart';

import '../../Generic/appConst.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
    buildSignature: '',
  );

  @override
  initState() {
    super.initState();
    _initPackageInfo();
    final timer = Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(
            context, '/login');
      },
    );
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppConst.appColorTechnoSysDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              builder: (BuildContext context, double value, Widget? child) {
                return Padding(
                  padding:
                      EdgeInsets.only(top: screenSize.height * 0.3 * value),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 1500),
                    opacity: 1.0 * value,
                    child: Image.asset(
                      'assets/images/tslogo_white.png',
                      width: 327.0,
                      height: 160.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              child: null,
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              builder: (BuildContext context, double value, Widget? child) {
                return Expanded(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 1500),
                    opacity: 1.0 * value,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        // Version Number is in pubspec.yaml file (on Top)
                        'v${_packageInfo.version} 2-Jul-2022',  // Build Date Should Be Changed According to the release
                        style: const TextStyle(
                          fontSize: AppConst.appFontSizeh11,
                          fontWeight: AppConst.appTextFontWeightLight,
                          color: AppConst.appColorWhite,
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: null,
            ),
            // Expanded(
            //   child: TweenAnimationBuilder(
            //     tween: Tween<double>(begin: 0.0, end: screenSize.height * 0.05),
            //     duration: const Duration(milliseconds: 1500),
            //     builder: (BuildContext context, double value, Widget? child) {
            //       return Align(
            //         alignment: Alignment.bottomCenter,
            //         child: Padding(
            //           padding: EdgeInsets.only(bottom: value),
            //           child: AppLargeButton(
            //             onPressedFunc: () {
            //               Navigator.pushReplacementNamed(context, '/login');
            //             },
            //             titleWidget: const Text(
            //               'Login',
            //               style: TextStyle(
            //                 fontSize: AppConst.appFontSizeh9,
            //                 fontWeight: AppConst.appTextHintFontWeight,
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //     child: null,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
