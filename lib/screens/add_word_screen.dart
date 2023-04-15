import 'dart:math';

import 'package:dictionary/services/db_service.dart';
import 'package:dictionary/utils/my_widgets.dart';
import 'package:flutter/material.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({Key? key}) : super(key: key);

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  TextEditingController wordController = TextEditingController();
  TextEditingController definitionController = TextEditingController();
  String table = 'eng_uzb';

  void saveWord() async {
    if(wordController.text.isEmpty) {
      MyWidgets().showToast("Enter a word", isError: false);
      return;
    }

    if(definitionController.text.isEmpty) {
      MyWidgets().showToast("Enter a definition", isError: false);
      return;
    }
    Map<String, dynamic> body = {};
    int id = 176064 + Random().nextInt(10000);
    switch(table) {
      case "eng_uzb":
        body = {
          "_id": id,
          "eng": wordController.text,
          "pron": "()",
          "uzb": definitionController.text
        };
        break;
      case "uzb_eng":
        body = {
          "_id": id,
          "uzb": wordController.text,
          "eng": definitionController.text,
          "eng_1": "",
          "eng_2": "",
        };
        break;
      case "definition":
        body = {
          "ID": id,
          "Word": wordController.text,
          "Type": "()",
          "Description": definitionController.text
        };
        break;
    }
    bool? added = await DBService().addWordToDB(table, body);
    if(added != null) {
      if(added) {
        Navigator.pop(context);
      } else {
        MyWidgets().showToast("Not added!");
      }
    } else {
      MyWidgets().showToast("Error occurred!");
    }
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
                    controller: wordController,
                    decoration: InputDecoration(
                        hintText: 'Word you want to add...',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  MyWidgets().sizedBox(15),
                  TextField(
                    controller: definitionController,
                    decoration: InputDecoration(
                        hintText: 'Definition of that word...',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  MyWidgets().sizedBox(15),
                  DropdownButton<String>(
                    value: table,
                    items: <String>[
                      'eng_uzb',
                      'uzb_eng',
                      'definition',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 30),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        table = newValue!;
                      });
                    },
                  ),
                  MyWidgets().sizedBox(15),
                ],
              ),
            ),
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
