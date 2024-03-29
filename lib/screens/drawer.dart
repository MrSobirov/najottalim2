import 'package:dictionary/screens/add_word_screen.dart';
import 'package:dictionary/screens/online/online_screen.dart';
import 'package:dictionary/screens/pdf/pdf_page.dart';
import 'package:dictionary/utils/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/cache_values.dart';
import '../services/storage_service.dart';
import 'home/home_cubit.dart';

class AppDrawer extends StatelessWidget {
  final BuildContext homeCubitCTX;
  const AppDrawer(this.homeCubitCTX, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'Dictionary',
              style: TextStyle(fontSize: 22.sp),
            ),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: Text(
              'Search Online',
              style: TextStyle(fontSize: 16.sp),
            ),
            onTap: () async {
              if (await CacheKeys.hasInternet()) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => OnlineScreen()));
              } else {
                MyWidgets().showToast("No connection!");
              }
            },
          ),
          MyWidgets().divider(),
          ListTile(
            leading: const Icon(Icons.change_circle_outlined),
            title: Text(
              'Change Language',
              style: TextStyle(fontSize: 16.sp),
            ),
            onTap: () async {
              bool saved = await StorageService()
                  .saveBool(key: "engUzb", value: !CacheKeys.engUzb);
              if (saved) {
                CacheKeys.engUzb = !CacheKeys.engUzb;
                MyWidgets().showToast(
                    "Language is changed to ${CacheKeys.engUzb ? "english" : "uzbek"}",
                    isError: false);
                Navigator.pop(context);
                int page = 1;
                if (CacheKeys.engUzb) {
                  page = CacheKeys.engUzbPage++;
                } else {
                  page = CacheKeys.uzbEngPage++;
                }
                await BlocProvider.of<HomeCubit>(homeCubitCTX)
                    .getWords("", page);
              }
            },
          ),
          MyWidgets().divider(),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(
              'Add a word',
              style: TextStyle(fontSize: 16.sp),
            ),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddWordScreen())),
          ),
          MyWidgets().divider(),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: Text(
              'Convert to pdf',
              style: TextStyle(fontSize: 16.sp),
            ),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => PdfPage())),
          ),
        ],
      ),
    );
  }
}
