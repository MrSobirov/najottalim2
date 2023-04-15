List<EngUzbModel> engUzbModelFromJson(List<Map<String, dynamic>> str) => List<EngUzbModel>.from(str.map((x) => EngUzbModel.fromJson(x)));

class EngUzbModel {
  EngUzbModel({
    required this.id,
    required this.eng,
    required this.pron,
    required this.uzb,
    required this.pdfChosen,
  });

  final int id;
  final String eng;
  final String pron;
  final String uzb;
  bool pdfChosen;

  factory EngUzbModel.fromJson(Map<String, dynamic> json) => EngUzbModel(
    id: json["_id"],
    eng: json["eng"],
    pron: json["pron"],
    uzb: json["uzb"],
    pdfChosen: false,
  );
}
