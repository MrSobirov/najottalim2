import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:html/parser.dart';


import '../utils/my_widgets.dart';

class PdfService {
  pw.Container buildPdf(List<Map<String, String>> items, ByteData data) {
    var myFont = Font.ttf(data);
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
            crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                    "${item['name']}",
                    style: pw.TextStyle(
                      fontSize: 15.sp,
                      font: myFont,
                      fontWeight: pw.FontWeight.bold,
                    )
                ),
                pw.Text(
                    contentText,
                    style: pw.TextStyle(fontSize: 13.sp, font: myFont)
                ),
                pw.SizedBox(height: 20.h)
              ]
          );
        }).toList(),
      ),
    );
  }

  Future<void> savePdf(List<Map<String, String>> items, ByteData data) async {
    print(items.length);
    pw.Document doc = pw.Document();
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return buildPdf(items, data);
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
    File file = File("${path.path}/dictionary-words${Random().nextInt(100)}.pdf");
    await file.writeAsBytes(bytes);
    final String url = file.path;
    MyWidgets().showToast(url, isError: false);
    print(url);
    await OpenFile.open(url);
    print("opened");
  }
}
