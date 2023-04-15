// To parse this JSON data, do
//
//     final wordModel = wordModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<WordModel> wordModelFromJson(String str) => List<WordModel>.from(json.decode(str).map((x) => WordModel.fromJson(x)));

class WordModel {
  WordModel({
    required this.word,
    required this.audio,
    required this.definition,
    required this.synonyms

  });

  final String word;
  final String audio;
  final String definition;
  final List synonyms;

  factory WordModel.fromJson(Map<String, dynamic> json) => WordModel(
    word: json["word"],
    audio: json["phonetics"]["audio"],
    definition: json["meanings"]["definitions"]["definition"],
    synonyms: json["meanings"]["synonyms"],

  );

}
