import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ts_app_development/DataLayer/Providers/APIConnectionProvider/apiConnectionProvider.dart';
import 'package:ts_app_development/DataLayer/Providers/DataProvider/dataProvider.dart';
import 'package:ts_app_development/DataLayer/Providers/DateTimeRangeProvider/dateTimeRangeProvider.dart';
import 'package:ts_app_development/DataLayer/Providers/FiltersProvider/filterProviders.dart';
import 'package:ts_app_development/DataLayer/Providers/ThemeProvider/themeProvider.dart';
import 'package:ts_app_development/DataLayer/Providers/UserProvider/userProvider.dart';
import 'package:ts_app_development/Screens/SplashScreen/splashScreen.dart';
import 'Authentication/AuthenticationWrapper.dart';
import 'Authentication/Login/login.dart';
import 'DataLayer/Providers/LocationProvider/location.dart';
import 'Generic/appConst.dart';
import 'Screens/genericScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => APIConnectionProvider()),
      ChangeNotifierProvider(create: (context) => LocationIdentifier()),
      ChangeNotifierProvider(create: (context) => UserSessionProvider()),
      ChangeNotifierProvider(create: (context) => DateTimeRangeProvider()),
      ChangeNotifierProvider(create: (context) => DataProvider()),
      ChangeNotifierProvider(create: (context) => FilterProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BX Mobile',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthenticationWrapper(),
        '/Auth': (context) => const AuthenticationWrapper(),
        '/login': (context) => const Login(),
        '/splash': (context) => const SplashScreen(),
        '/Dashboard': (context) => GenericScreen(
              route: '/Dashboard',
            ),
        '/MarkAttendanceNew': (context) => GenericScreen(
              route: '/MarkAttendanceNew',
            ),
        '/TimeAndAttendance': (context) => GenericScreen(
              route: '/TimeAndAttendance',
            ),
        '/settings': (context) => GenericScreen(
              route: '/settings',
            ),
        '/updatePassword': (context) => GenericScreen(
              route: '/updatePassword',
            ),
        '/EmployeePayroll': (context) => GenericScreen(
          route: '/EmployeePayroll',
        ),
        '/about': (context) => GenericScreen(
              route: '/about',
            ),
        '/faq': (context) => GenericScreen(
              route: '/faq',
            ),
        '/OrderDeliveryStatus': (context) => GenericScreen(
              route: '/OrderDeliveryStatus',
            ),
            
         
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: context.read<ThemeProvider>().selectedPrimaryColor,
          secondary: AppConst.appColorWhite,
        ),
      ),
      // home: const GenericScreen(),
    );
  }
}
