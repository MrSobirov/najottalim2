import 'package:dictionary/utils/my_widgets.dart';
import 'package:flutter/material.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({Key? key}) : super(key: key);

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  String dropdownValue = 'table1';
  void saveWord(){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add A Word'),
        actions: [
          IconButton(
            onPressed: saveWord,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(5),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: controller1,
                  decoration: InputDecoration(
                      hintText: 'Word you want to add...',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(20))),
                ),
                MyWidgets().sizedBox(15),
                TextField(
                  controller: controller2,
                  decoration: InputDecoration(
                      hintText: 'Definition of that word...',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(20))),
                ),
                MyWidgets().sizedBox(15),
                DropdownButton<String>(
                  value: dropdownValue,
                  items: <String>[
                    'table1',
                    'table2',
                    'table3',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 30),
                      ),
                    );
                  }).toList(),
                  // Step 5.
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                ),
                MyWidgets().sizedBox(15),
              ],
            ),),
            ElevatedButton.icon(
              onPressed: saveWord,
              icon: const Icon(Icons.add),
              label: const Text('Add A Word'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  elevation: 0,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            ),
          ],
        ),
      ),
    );
  }
}
