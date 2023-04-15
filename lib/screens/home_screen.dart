import 'package:dictionary/utils/my_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
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
                onPressed: () {
                  setState(() {
                    controller.clear();
                  });
                },
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
            onTap: () {
              setState(() {
                controller.clear();
              });
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: ClipOval(
            child: Image.asset(
          'assets/images/gb_logo.png',
          fit: BoxFit.cover,
        )),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) => Column(
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
                MyDialogs().descriptionDialog(context, 'title', 'description');
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                height: 40,
                width: double.infinity,
                child: Text(
                  'abandon',
                  textAlign: TextAlign.start,

                ),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        ),
        itemCount: 10,
      ),
    );
  }
}
