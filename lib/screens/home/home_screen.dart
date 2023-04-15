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
    TextEditingController controller = TextEditingController();
    int page = 1;
    bool reachBottom = false;
    return BlocProvider(
      create: (ctx1) => HomeCubit()..getWords("", 1),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (cubitCTX, state) {
          reachBottom = false;
          if(state is HomeLoading) {
            return Scaffold(
              appBar: AppBar(
                title: Container(
                  width: double.infinity,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {},
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
                  Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: 30.w,
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
                ],
              ),
              drawer: AppDrawer(),
            );
          } else if (state is HomeLoaded){
            return Scaffold(
              appBar: AppBar(
                title: Container(
                  width: double.infinity,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {},
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
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
                  GestureDetector(
                    onTap: () async {
                      bool saved = await StorageService().saveBool(key: "engUzb", value: !CacheKeys.engUzb);
                      if(saved) {
                        CacheKeys.engUzb = !CacheKeys.engUzb;
                        MyWidgets().showToast("Language is changed to ${CacheKeys.engUzb ? "english" : "uzbek"}", isError: false);
                        await BlocProvider.of<HomeCubit>(cubitCTX).getWords("", 1);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: 30.w,
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
              drawer: AppDrawer(),
              body: Column(
                children: [
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollEnd) {
                        var metrics = scrollEnd.metrics;
                        if (metrics.atEdge) {
                          if (metrics.pixels != 0) {
                            if(state.loadMore && !state.loading && !reachBottom) {
                              reachBottom = true;
                              page++;
                              BlocProvider.of<HomeCubit>(cubitCTX).getWords(controller.text, page);
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
                  if(state.loading) Text(
                    "Loading",
                    style: TextStyle(
                      fontSize: 15.sp
                    ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: ClipOval(
                    child: Image.asset(
                      'assets/images/gb_logo.png',
                      fit: BoxFit.cover,
                    )),
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
