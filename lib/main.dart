import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'customers/customer-list.dart';
void main() {
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(325, 667),
      builder: () {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Visit kashmir',
          home: CustomerList(),
        );
      },
    );
  }
}


