import 'package:dictionary/models/word_model.dart';
import 'package:flutter/cupertino.dart';

import '../services/http_services.dart';

class WordRepo {
  Future<List<WordModel>?> wordRepo() async {
    final HttpResult response = await ApiRequests().get(slug: 'https://api.dictionaryapi.dev/api/v2/entries/en/WORD',);
    if(response.isSuccess) {
      try {
        debugPrint(response.body);
        return wordModelFromJson(response.body);
      }
      catch(error,s){
        debugPrint(error.toString());
        debugPrint(s.toString());
        return null;
      }
    } else {
      debugPrint(response.body);
      return null;
    }
  }
}