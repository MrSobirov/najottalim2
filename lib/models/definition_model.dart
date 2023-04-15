List<DefinitionModel> definitionModelFromJson(List<Map<String, dynamic>> str) => List<DefinitionModel>.from(str.map((x) => DefinitionModel.fromJson(x)));

class DefinitionModel {
  DefinitionModel({
    required this.id,
    required this.word,
    required this.type,
    required this.description,
    required this.idAlphabet,
    required this.pdfChosen,
  });

  final int id;
  final String word;
  final String type;
  final String description;
  final int idAlphabet;
  bool pdfChosen;

  factory DefinitionModel.fromJson(Map<String, dynamic> json) => DefinitionModel(
    id: json["ID"] ?? 0,
    word: json["Word"],
    type: json["Type"] == "()" ? "" : json["Type"],
    description: json["Description"],
    idAlphabet: json["ID_ALPHABET"] ?? 0,
    pdfChosen: false,
  );

}
