// To parse this JSON data, do
//
//     final zikir = zikirFromJson(jsonString);

import 'dart:convert';

// Zikir zikirFromJson(String str) => Zikir.fromJson(json.decode(str));
// String zikirToJson(Zikir data) => json.encode(data.toJson());

class Zikir {
  String text;
  List<String> textArray;
  String translation;
  String narration;
  String authenticity;
  String reference;
  int count;
  List<int> types;
  List<String> timeRange;

  Zikir({
    this.text,
    this.textArray,
    this.translation,
    this.narration,
    this.authenticity,
    this.reference,
    this.count,
    this.types,
    this.timeRange,
  });

  Zikir copyWith({
    String text,
    String textArray,
    String translation,
    String narration,
    String authenticity,
    String reference,
    int count,
    List<int> types,
    List<String> timeRange,
  }) =>
      Zikir(
        text: text ?? this.text,
        textArray: textArray ?? this.textArray,
        translation: translation ?? this.translation,
        narration: narration ?? this.narration,
        authenticity: authenticity ?? this.authenticity,
        reference: reference ?? this.reference,
        count: count ?? this.count,
        types: types ?? this.types,
        timeRange: timeRange ?? this.timeRange,
      );

  factory Zikir.fromJson(Map<String, dynamic> json) => Zikir(
        text: json["text"],
        textArray: json["textArray"] == null
            ? null
            : List<String>.from(json["textArray"].map((x) => x)),
        translation: json["translation"],
        narration: json["narration"],
        authenticity: json["authenticity"],
        reference: json["reference"],
        count: json["count"],
        types: json["types"] == null
            ? null
            : List<int>.from(json["types"].map((x) => x as int)),
        timeRange: json["timeRange"] == null
            ? null
            : List<String>.from(json["timeRange"].map((x) => x as String)),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "textArray": textArray,
        "translation": translation,
        "narration": narration,
        "authenticity": authenticity,
        "reference": reference,
        "count": count,
        "types": List<dynamic>.from(types.map((x) => x)),
        "timeRange": List<dynamic>.from(timeRange.map((x) => x)),
      };
}
