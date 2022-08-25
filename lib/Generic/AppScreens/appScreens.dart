import 'package:flutter/material.dart';
import 'package:ts_app_development/Screens/MarkAttendance/markAttendance.dart';
import 'package:ts_app_development/Screens/MyHistory/myHistory.dart';

import '../../Screens/OrderStatus/orderStatus.dart';
import '../../Screens/Payroll/payroll.dart';

class AppScreens {
  // Screens Array
  static List<Map> screens = [
    // ['TITLE', INDEX, Route, ComponentPath, Icon]

    // To create a new screen update an entry here
    // go to the main.dart file and update the second entry there
    // then go to the genericScreen's handleScreens() function and update an entry there
    // that's it to make a new screen
    // {
    //   'Title': 'Dashboard',
    //   'Index': 0,
    //   'Route': '/TimeAndAttendance',
    //   'Component': const Dashboard(),
    //   'Icon': const Icon(Icons.dashboard),
    // },
    {
      'Title': 'Attendance',
      'Index': 0,
      'Route': '/MarkAttendanceNew',
      'Component': const MarkAttendance(),
      'Icon': const Icon(Icons.fact_check_rounded)
    },
    {
      'Title': 'Attendance View',
      'Index': 1,
      'Route': '/TimeAndAttendance',
      'Component': const MyHistory(route: '/TimeAndAttendance',),
      'Icon': const Icon(Icons.calendar_today_rounded)
    },
    {
      'Title': 'Order Delivery Status',
      'Index': 2,
      'Route': '/OrderDeliveryStatus',
      'Component': const OrderStatus(route: '/OrderDeliveryStatus',),
      'Icon': const Icon(Icons.calendar_today_rounded)
    },
    {
      'Title': 'Payslips',
      'Index': 3,
      'Route': '/EmployeePayroll',
      'Component': const Payroll(),
      'Icon': const Icon(Icons.payments_rounded)
    },
  ];

  static Map<String, dynamic> screenIcons = {
    'Dashboard' : const Icon(Icons.dashboard),
    'MarkAttendanceNew' : const Icon(Icons.fact_check_rounded),
    'TimeAndAttendance' : const Icon(Icons.calendar_today_rounded),
    'OrderDeliveryStatus' : const Icon(Icons.calendar_today_rounded),
    'EmployeePayroll' : const Icon(Icons.payments_rounded),
    'settings' : const Icon(Icons.settings)
  };

  static Map<String, dynamic> screenTabs = {
    '/TimeAndAttendance' : {'tabs' : 3, 'tabsList' : ['March', 'April', 'May'],},
    '/OrderDeliveryStatus' : {'tabs' : 2, 'tabsList' : ['Pending', 'Delivered'],},
  };
}
