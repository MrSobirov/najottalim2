import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseLanguage extends StatelessWidget {
  const ChooseLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 100.h,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onTap: (){},
                child: Card(
                  elevation: 5,
                  child: Text('English to Uzbek'),
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Card(
                  elevation: 5,
                  child: Text('Uzbek to English'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
