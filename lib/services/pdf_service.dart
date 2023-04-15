import 'package:dictionary/models/definition_model.dart';
import 'package:dictionary/models/eng_model.dart';
import 'package:dictionary/models/uzb_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  pw.Container buildPrintableInvoice({List<UzbEngModel> uzbEng = const [], List<EngUzbModel> engUzb = const [], List<DefinitionModel> definition = const []}) {
    List<Map<String, String>> items = [];
    int type = uzbEng.isNotEmpty ? 1 : engUzb.isNotEmpty ? 2 : 3;
    switch(type) {
      case 1:
        for(UzbEngModel item in uzbEng) {
          items.add({
            "name": item.uzb,
            "text": item.eng
          });
        }
        break;
      case 2:
        for(EngUzbModel item in engUzb) {
          items.add({
            "name": item.eng,
            "text": item.uzb
          });
        }
        break;
      case 3:
        for(DefinitionModel item in definition) {
          items.add({
            "name": item.word,
            "text": item.description
          });
        }
        break;
    }

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: double.infinity,
      width: double.infinity,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: items.map((item) => pw.Row(
          children: [
            pw.Text(
              "${item['name']}",
              style: pw.TextStyle(
                fontSize: 15.sp,
                fontWeight: pw.FontWeight.bold,
              )
            ),
            pw.Expanded(
              child: pw.Text(
                "${item["text"]}",
                style: pw.TextStyle(fontSize: 13.sp)
              )
            )
          ]
        )).toList(),
      ),
    );
  }
}
