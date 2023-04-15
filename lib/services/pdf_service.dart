import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:html/parser.dart';


import '../utils/my_widgets.dart';

class PdfService {
  pw.Container buildPdf(List<Map<String, String>> items) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: double.infinity,
      width: double.infinity,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: items.map((item) {
          final document = parse("${item["text"]}");
          final String contentText = parse(document.body?.text).documentElement?.text ?? "";
          return pw.Column(
              children: [
                pw.Text(
                    "${item['name']}",
                    style: pw.TextStyle(
                      fontSize: 15.sp,
                      fontWeight: pw.FontWeight.bold,
                    )
                ),
                pw.Text(
                    contentText,
                    style: pw.TextStyle(fontSize: 13.sp)
                )
              ]
          );
        }).toList(),
      ),
    );
  }

  Future<void> savePdf(List<Map<String, String>> items) async {
    print(items.length);
    pw.Document doc = pw.Document();
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return buildPdf(items);
      },
    ));
    final bytes = await doc.save();
    final path = Directory((Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory() //FOR IOS
    )!.path);
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      debugPrint("Existing path  " + path.path);
    } else {
      path.create(recursive: false);
      debugPrint("New path  " + path.path);
    }
    File file = File("${path.path}/dictionary-words.pdf");
    await file.writeAsBytes(bytes);
    final String url = file.path;
    MyWidgets().showToast(url, isError: false);
    await OpenFile.open(url);
  }
}
