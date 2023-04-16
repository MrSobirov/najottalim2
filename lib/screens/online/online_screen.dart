import 'package:dictionary/models/word_model.dart';
import 'package:dictionary/screens/online/online_cubit.dart';
import 'package:dictionary/utils/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

class OnlineScreen extends StatelessWidget {
  const OnlineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return BlocProvider(
      create: (ctx1) => OnlineCubit()..searchWordOnline(""),
      child: BlocBuilder<OnlineCubit, OnlineState>(
        builder: (cubitCTX, state) {
          if(state is OnlineLoading) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Container(
                  width: double.infinity,
                  height: 35.h,
                  padding: EdgeInsets.only(left: 8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () async {
                          searchController.clear();
                          await BlocProvider.of<OnlineCubit>(cubitCTX).searchWordOnline("");
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      alignment: Alignment.center,
                      width: 38.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.mic,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if(state is OnlineLoaded) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Container(
                  width: double.infinity,
                  height: 35.h,
                  padding: EdgeInsets.only(left: 8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () async {
                          searchController.clear();
                          await BlocProvider.of<OnlineCubit>(cubitCTX).searchWordOnline("");
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (String text) async {
                      await BlocProvider.of<OnlineCubit>(cubitCTX).searchWordOnline(text);
                    },
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      alignment: Alignment.center,
                      width: 38.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.mic,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              body: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                itemCount: state.wordList.length,
                itemBuilder: (ctx, index) {
                  WordModel item = state.wordList[index];
                  Function? audioState;
                  bool playing = false;
                  bool completed = false;
                  Duration? _duration = Duration.zero;
                  Duration? _position = Duration.zero;
                  AudioPlayer player = AudioPlayer();
                  String playingPhonetics = "";
                  bool haveAudio = false;
                  for(Phonetic phonetic in item.phonetics) {
                    if(phonetic.audio.isNotEmpty) {
                      haveAudio = true;
                      playingPhonetics = phonetic.text;
                      player.setUrl(phonetic.audio);
                    }
                  }
                  // Listen player states
                  player.playerStateStream.listen((event) async {
                    playing = event.playing;
                    if (event.processingState == ProcessingState.completed) {
                      playing = false;
                      _position = const Duration(seconds: 0);
                      completed = true;
                    }
                    if(audioState != null) {
                      audioState!(() {});
                    }
                  });
                  // Listen audio duration
                  player.durationStream.listen((newDuration) {
                    _duration = newDuration;
                  });
                  // Listen audio position
                  player.positionStream.listen((newPosition) {
                    _position = newPosition;
                  });
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black
                              ),
                              children: [
                                TextSpan(text: "${item.word}\n", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600)),
                                TextSpan(text: item.phonetic),
                              ]
                            ),
                          ),
                          if(haveAudio) StatefulBuilder(
                            builder: (audioCTX, audioSetState) {
                              audioState = audioSetState;
                              return  GestureDetector(
                                onTap: () async {
                                  if(!playing) {
                                    playing = true;
                                    completed = false;
                                    MyWidgets().showToast(playingPhonetics, isError: false);
                                    await player.play();
                                    if(completed) {
                                      await player.seek(const Duration(seconds: 0));
                                      await player.pause();
                                    }
                                  }
                                  if(playing) {
                                    playing = false;
                                    await player.pause();
                                  }
                                  audioSetState(() {});
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 25.r,
                                  child: Icon(playing ? Icons.pause : Icons.play_arrow, size: 30.w),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: item.meanings.map((meaning) {
                          int defCount = 0;
                          return Card(
                            elevation: 5,
                            color: Colors.grey.shade200,
                            child: Container(
                              width: 350.w,
                              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                              margin: EdgeInsets.symmetric(vertical: 8.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Part of speech: ${meaning.partOfSpeech}",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontStyle: FontStyle.italic
                                    ),
                                  ),
                                  if(meaning.synonyms.isNotEmpty) Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.h),
                                    child: Text(
                                      "Synonyms: ${meaning.synonyms.toString().replaceAll('[', "").replaceAll(']', "")}",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  ),
                                  if(meaning.antonyms.isNotEmpty) Text(
                                    "Antonyms: ${meaning.antonyms.toString().replaceAll('[', "").replaceAll(']', "")}",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontStyle: FontStyle.italic
                                    ),
                                  ),
                                  if(meaning.definitions.isNotEmpty) Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10.h),
                                      Text(
                                        "Definitions:",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontStyle: FontStyle.italic
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Column(
                                          children: meaning.definitions.map((def) {
                                            defCount++;
                                            return Text(
                                                "$defCount). ${def.definition} \n    Example: ${def.example}"
                                            );
                                          }).toList()
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  );
                },
              ),
            );
          } else if(state is OnlineError) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Container(
                  width: double.infinity,
                  height: 35.h,
                  padding: EdgeInsets.only(left: 8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () async {
                          searchController.clear();
                          await BlocProvider.of<OnlineCubit>(cubitCTX).searchWordOnline("");
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      alignment: Alignment.center,
                      width: 38.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.mic,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              body: Center(
                child: Text(
                  "Error occurred"
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
