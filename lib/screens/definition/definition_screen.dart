import 'package:dictionary/services/cache_values.dart';
import 'package:dictionary/utils/my_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../details_screen.dart';
import 'definition_cubit.dart';

class DefinitionScreen extends StatelessWidget {
  const DefinitionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    int page = 1;
    bool reachBottom = false;
    return BlocProvider(
      create: (ctx1) => DefinitionCubit()..getWords("", 1),
      child: BlocBuilder<DefinitionCubit, DefinitionState>(
        builder: (cubitCTX, state) {
          reachBottom = false;
          if(state is DefinitionLoading) {
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
                        icon: const Icon(Icons.clear),
                        onPressed: null,
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: 30.w,
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
                ],
              ),
            );
          } else if (state is DefinitionLoaded) {
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
                        icon: const Icon(Icons.clear),
                        onPressed: () async {
                          searchController.clear();
                          await BlocProvider.of<DefinitionCubit>(cubitCTX).getWords("", 1);
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                    onChanged: (String text) async {
                      await BlocProvider.of<DefinitionCubit>(cubitCTX).getWords(text, 1);
                    },
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: 30.w,
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
              body: Column(
                children: [
                  if(CachedModels.definitionModel.isNotEmpty) Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollEnd) {
                        var metrics = scrollEnd.metrics;
                        if (metrics.atEdge) {
                          if (metrics.pixels != 0) {
                            if(state.loadMore && !state.loading && !reachBottom) {
                              reachBottom = true;
                              page++;
                              BlocProvider.of<DefinitionCubit>(cubitCTX).getWords(searchController.text, page);
                            }
                          }
                        }
                        return true;
                      },
                      child: ListView.builder(
                        itemCount: CachedModels.definitionModel.length,
                        itemBuilder: (ctx, index) {
                          String name = CachedModels.definitionModel[index].word;
                          String description = CachedModels.definitionModel[index].description;
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Details(),
                                    ),
                                  );
                                },
                                onLongPress: () {
                                  MyDialogs().descriptionDialog(context, name, description);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.w),
                                  alignment: Alignment.centerLeft,
                                  height: 40.h,
                                  width: double.infinity,
                                  child: Text(
                                    name,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 13.sp
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                height: 5.h,
                                color: Colors.black,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  if(CachedModels.definitionModel.isEmpty) Center(
                    child: Column(
                      children: [
                        SizedBox(height: 100.h),
                        Text("Word is not found!", style: TextStyle(fontSize: 30.sp)),
                        SizedBox(height: 20.h),
                        Icon(Icons.search_off_sharp, size: 80.w)
                      ],
                    ),
                  ),
                  if(state.loading) Text(
                    "Loading",
                    style: TextStyle(
                        fontSize: 15.sp
                    ),
                  )
                ],
              )
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
