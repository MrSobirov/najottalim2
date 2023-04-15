import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDialogs {
  void descriptionDialog(BuildContext ctx, String title, String description) {
    showDialog(
      context: ctx,
      builder: (dialogCTX) {
        return Column();
      },
    );
  }
}