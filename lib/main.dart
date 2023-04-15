import 'package:dictionary/screens/choose_language.dart';
import 'package:dictionary/screens/home_screen.dart';
import 'package:dictionary/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dictionary',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(

            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp,bodyColor: Colors.black),
          ),
          home: child,
        );
      },
      child: ChooseLanguage(),
    );
  }
}
