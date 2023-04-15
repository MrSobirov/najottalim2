import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDialogs {
  void descriptionDialog(BuildContext context, String title, String description) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title, style: TextStyle(fontSize: 15.sp, color: Colors.red), textAlign: TextAlign.center,),
          content: Html(
            data: description,
          ),
          actions: [
            GestureDetector(
              onTap: () => Navigator.of(ctx).pop(),
              child: Container(
                height: 27.h,
                width: 60.w,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12.r)
                ),
                child: Text(
                  "Close",
                  style: TextStyle(fontSize: 13.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
    );
  }
  void voiceDialog(BuildContext context) {

  }
}