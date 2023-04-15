import 'package:dictionary/utils/my_widgets.dart';
import 'package:flutter/material.dart';
class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Dictionary'),
            automaticallyImplyLeading: false,
          ),

          ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Online'),
              onTap: () {

              }),
          MyWidgets().divider(),
          ListTile(
              leading: const Icon(Icons.change_circle_outlined),
              title: const Text('Change Language'),
              onTap: () {
              }),
          MyWidgets().divider(),
          ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add a word'),
              onTap: () {
              }),
          MyWidgets().divider(),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('Convert to pdf'),
            onTap: () {

            },
          ),
        ],
      ),
    );
  }
}
