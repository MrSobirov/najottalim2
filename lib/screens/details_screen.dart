import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Details extends StatelessWidget {
  final String name;
  final String description;
  const Details(this.name, this.description, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search result'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text(
             " $name",
             textAlign: TextAlign.center,
             style: TextStyle(
                 fontSize: 22.sp,
                 color: Colors.red,
               fontWeight: FontWeight.w600
             ),
           ),
           SizedBox(height: 10.h),
           Html(data: description,),
          ],
        ),
      ),
    );
  }
}
