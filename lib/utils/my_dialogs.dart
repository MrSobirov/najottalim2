import 'package:flutter/material.dart';

class MyDialogs {
  void descriptionDialog(BuildContext context ,String title, String description) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Ok'),
            ),
          ],
          title: Text(title,style: TextStyle(color: Colors.black),),
          content: Text(description,style: TextStyle(color: Colors.black),),
        ));
  }
}