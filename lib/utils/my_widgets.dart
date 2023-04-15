import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyWidgets {
  void showToast(String msg, {bool isError = true, bool isBottom = true}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        fontSize: 13.sp,
        gravity: isBottom ? ToastGravity.BOTTOM : ToastGravity.TOP,
        backgroundColor: isError ? Colors.red : Colors.grey.shade400,
        textColor: Colors.white
    );
  }
  Widget sizedBox(double size){
    return SizedBox(height: size,);
  }
  Widget divider(){
    return Divider(color: Colors.black54,);
  }

}