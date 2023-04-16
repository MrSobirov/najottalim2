import 'package:dictionary/models/word_model.dart';
import 'package:dictionary/utils/my_widgets.dart';
import 'package:flutter/cupertino.dart';

import '../services/http_services.dart';

class WordRepo {
  Future<List<WordModel>?> wordRepo(String word) async {
    final HttpResult response = await ApiRequests().get(slug: 'https://api.dictionaryapi.dev/api/v2/entries/en/$word');
    if(response.isSuccess) {
      try {
        return wordModelFromJson(response.body);
      }
      catch(error, stacktrace) {
        debugPrint("Model error : $error, $stacktrace");
        MyWidgets().showToast("Word is not found online");
        return [];
      }
    } else {
      debugPrint("Api error : ${response.status}, ${response.body}");
      return null;
    }
  }
}