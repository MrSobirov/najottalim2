import 'package:dictionary/screens/home/home_screen.dart';
import 'package:dictionary/services/cache_values.dart';
import 'package:dictionary/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseLanguage extends StatelessWidget {
  const ChooseLanguage({Key? key}) : super(key: key);

  void chosen(bool engUzb, BuildContext ctx) async {
    bool saved = await StorageService().saveBool(key: "engUzb", value: engUzb);
    if(saved) {
      CacheKeys.engUzb = engUzb;
      Navigator.pushReplacement(ctx, MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 150.h, bottom: 170.h),
              child: Text(
                "Choose the dictionary type",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            GestureDetector(
              onTap: () => chosen(true, context),
              child: Card(
                elevation: 5,
                child: Container(
                  height: 35.h,
                  width: 170.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r)),
                  child: Text('English to Uzbek'),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () => chosen(false, context),
              child: Card(
                elevation: 5,
                child: Container(
                  height: 35.h,
                  width: 170.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r)),
                  child: Text('Uzbek to English'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
