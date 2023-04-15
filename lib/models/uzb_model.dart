List<UzbEngModel> uzbEngModelFromJson(List<Map<String, dynamic>> str) => List<UzbEngModel>.from(str.map((x) => UzbEngModel.fromJson(x)));

class UzbEngModel {
  UzbEngModel({
    required this.id,
    required this.uzb,
    required this.eng,
    required this.eng1,
    required this.eng2,
  });

  final int id;
  final String uzb;
  final String eng;
  final String eng1;
  final String eng2;

  factory UzbEngModel.fromJson(Map<String, dynamic> json) => UzbEngModel(
    id: json["_id"],
    uzb: json["uzb"],
    eng: json["eng"],
    eng1: json["eng_1"],
    eng2: json["eng_2"],
  );
}
