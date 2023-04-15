import 'package:dictionary/screens/definition/definition_screen.dart';
import 'package:dictionary/screens/drawer.dart';
import 'package:dictionary/screens/home/home_cubit.dart';
import 'package:dictionary/services/cache_values.dart';
import 'package:dictionary/services/storage_service.dart';
import 'package:dictionary/utils/my_dialogs.dart';
import 'package:dictionary/utils/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    bool reachBottom = false;
    int page = CacheKeys.engUzb ? CacheKeys.engUzbPage : CacheKeys.uzbEngPage;
    return BlocProvider(
      create: (ctx1) => HomeCubit()..getWords("", page),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (cubitCTX, state) {
          reachBottom = false;
          if(state is HomeLoading) {
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
                    autofocus: false,
                    controller: searchController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: null,
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                actions: [
                  SizedBox(width: 10.w),
                  Container(
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      alignment: Alignment.center,
                      width: 38.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.change_circle_outlined,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              drawer: AppDrawer(cubitCTX),
            );
          } else if (state is HomeLoaded) {
            bool emptyResult = CacheKeys.engUzb ? CachedModels.engUzbModel.isEmpty : CachedModels.uzbEngModel.isEmpty;
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
                        icon: const Icon(Icons.clear, color: Colors.red ),
                        onPressed: () async {
                          searchController.clear();
                          int page = 1;
                          if(CacheKeys.engUzb) {
                            page = CacheKeys.engUzbPage++;
                          } else {
                            page = CacheKeys.uzbEngPage++;
                          }
                          await BlocProvider.of<HomeCubit>(cubitCTX).getWords("", page);
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                    onChanged: (String text) async {
                      await BlocProvider.of<HomeCubit>(cubitCTX).getWords(text, 1);
                    },
                  ),
                ),
                actions: [
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () {},
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: GestureDetector(
                      onTap: () async {
                        bool saved = await StorageService().saveBool(key: "engUzb", value: !CacheKeys.engUzb);
                        if(saved) {
                          CacheKeys.engUzb = !CacheKeys.engUzb;
                          searchController.clear();
                          MyWidgets().showToast("Language is changed to ${CacheKeys.engUzb ? "english" : "uzbek"}", isError: false);
                          int page = 1;
                          if(CacheKeys.engUzb) {
                            page = CacheKeys.engUzbPage++;
                          } else {
                            page = CacheKeys.uzbEngPage++;
                          }
                          await BlocProvider.of<HomeCubit>(cubitCTX).getWords("", page);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        alignment: Alignment.center,
                        width: 38.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Icon(
                          Icons.change_circle_outlined,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              drawer: AppDrawer(cubitCTX),
              body: Column(
                children: [
                  if(!emptyResult) Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollEnd) {
                        var metrics = scrollEnd.metrics;
                        if (metrics.atEdge) {
                          if (metrics.pixels != 0) {
                            if(state.loadMore && !state.loading && !reachBottom) {
                              reachBottom = true;
                              int page = 1;
                              if(CacheKeys.engUzb) {
                                page = CacheKeys.engUzbPage++;
                              } else {
                                page = CacheKeys.uzbEngPage++;
                              }
                              BlocProvider.of<HomeCubit>(cubitCTX).getWords(searchController.text, page);
                            }
                          }
                        }
                        return true;
                      },
                      child: ListView.builder(
                        itemCount: CacheKeys.engUzb ? CachedModels.engUzbModel.length : CachedModels.uzbEngModel.length,
                        itemBuilder: (ctx, index) {
                          String name = CacheKeys.engUzb ? CachedModels.engUzbModel[index].eng : CachedModels.uzbEngModel[index].uzb;
                          String description = CacheKeys.engUzb ? CachedModels.engUzbModel[index].uzb : CachedModels.uzbEngModel[index].eng;
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Details(name, description),
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
                  if(emptyResult) Center(
                    child: Column(
                      children: [
                        SizedBox(height: 100.h),
                        Text("Word is not found!", style: TextStyle(fontSize: 30.sp)),
                        SizedBox(height: 20.h),
                        Icon(Icons.search_off_sharp, size: 80.w)
                      ],
                    ),
                  ),
                  if(state.loading) Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Text(
                      "Loading...",
                      style: TextStyle(
                        fontSize: 15.sp
                      ),
                    ),
                  )
                ],
              ),
              floatingActionButton: CacheKeys.engUzb ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DefinitionScreen()));
                },
                child: ClipOval(
                    child: Image.asset(
                      'assets/images/gb_logo.png',
                      fit: BoxFit.cover,
                    )),
              ) : SizedBox(),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
