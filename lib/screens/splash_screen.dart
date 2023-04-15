import 'package:dictionary/screens/choose_language.dart';
import 'package:dictionary/services/cache_values.dart';
import 'package:dictionary/services/db_service.dart';
import 'package:dictionary/services/storage_service.dart';
import 'package:dictionary/utils/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  void navigate() async {
    Widget page = HomeScreen();
    bool opened = await DBService().openAssetDatabase();
    MyWidgets().showToast("Database ${opened ? "" : "not "}loaded", isError: false);
    bool? engUzb = await StorageService().getBool(key: "engUzb");
    if(engUzb == null) {
      page = ChooseLanguage();
    } else {
      CacheKeys.engUzb = engUzb;
    }
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 250.h),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 80.r,
                backgroundImage: AssetImage(
                  'assets/icons/app_logo.png',
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Legion Dictionary',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
