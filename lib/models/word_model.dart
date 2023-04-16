import 'dart:convert';

List<WordModel> wordModelFromJson(String str) => List<WordModel>.from(json.decode(str).map((x) => WordModel.fromJson(x)));

class WordModel {
  WordModel({
    required this.word,
    required this.phonetics,
    required this.meanings,
    required this.phonetic,
  });

  final String word;
  final List<Phonetic> phonetics;
  final List<Meaning> meanings;
  final String phonetic;

  factory WordModel.fromJson(Map<String, dynamic> json) => WordModel(
    word: json["word"],
    phonetics: List<Phonetic>.from(json["phonetics"].map((x) => Phonetic.fromJson(x))),
    meanings: List<Meaning>.from(json["meanings"].map((x) => Meaning.fromJson(x))),
    phonetic: json["phonetic"] ?? "",
  );
}

class Meaning {
  Meaning({
    required this.partOfSpeech,
    required this.definitions,
    required this.synonyms,
    required this.antonyms,
  });

  final String partOfSpeech;
  final List<Definition> definitions;
  final List<String> synonyms;
  final List<String> antonyms;

  factory Meaning.fromJson(Map<String, dynamic> json) => Meaning(
    partOfSpeech: json["partOfSpeech"],
    definitions: List<Definition>.from(json["definitions"].map((x) => Definition.fromJson(x))),
    synonyms: List<String>.from(json["synonyms"].map((x) => x)),
    antonyms: List<String>.from(json["antonyms"].map((x) => x)),
  );
}

class Definition {
  Definition({
    required this.definition,
    required this.example,
  });

  final String definition;
  final String example;

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
    definition: json["definition"],
    example: json["example"] ?? "",
  );
}

class Phonetic {
  Phonetic({
    required this.text,
    required this.audio,
  });

  final String text;
  final String audio;

  factory Phonetic.fromJson(Map<String, dynamic> json) => Phonetic(
    text: json["text"] ?? "",
    audio: json["audio"] ?? "",
  );
}
