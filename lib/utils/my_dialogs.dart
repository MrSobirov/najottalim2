import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MyDialogs {
  void descriptionDialog(BuildContext context, String title, String description) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0),),),
          title: Text(title, style: TextStyle(fontSize: 15.sp, color: Colors.red), textAlign: TextAlign.center,),
          content: Html(
            data: description,
          ),
          actions: [
            GestureDetector(
              onTap: () => Navigator.of(ctx).pop(),
              child: Container(
                margin: EdgeInsets.only(right: 6.w, bottom: 4.h),
                height: 27.h,
                width: 60.w,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8.w, ),
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

  Future<String?> voiceDialog(BuildContext context) {
    bool listening = false;
    String recordedWord = "";
    stt.SpeechToText speech = stt.SpeechToText();
    return showDialog<String>(
      context: context,
      builder: (dialogCTX) => WillPopScope(
        onWillPop: () async {
          Navigator.pop(dialogCTX, recordedWord);
          return false;
        },
        child: SizedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0),),),
            title: Text(
              "Tap to speak",
              style: TextStyle(fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 150.h,
              child: StatefulBuilder(
                builder: (recordCTR, recordSetState) {
                  return  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          bool available = await speech.initialize();
                          if(listening) {
                            speech.stop();
                            listening = false;
                            recordSetState(() {});
                          } else {
                            if(available ) {
                              listening = true;
                              speech.listen(
                                  onResult: (SpeechRecognitionResult result) {
                                    recordedWord = result.alternates[0].recognizedWords;
                                    listening = false;
                                    recordSetState(() {});
                                  }
                              );
                              recordSetState(() {});
                            }
                            else {
                              print("The user has denied the use of speech recognition.");
                            }
                          }
                        },
                        child: CircleAvatar(
                          radius: 60.r,
                          backgroundColor: Colors.blue,
                          child: Icon(listening ? Icons.stop : Icons.mic, size: 45.w, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        recordedWord.isNotEmpty ? recordedWord : "Result here.....",
                      ),
                    ],
                  );
                },
              )
            ),
          ),
        ),
      ),
    );
  }
}