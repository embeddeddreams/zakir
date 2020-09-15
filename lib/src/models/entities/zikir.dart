// To parse this JSON data, do
//
//     final zikir = zikirFromJson(jsonString);

import 'dart:convert';

// Zikir zikirFromJson(String str) => Zikir.fromJson(json.decode(str));
// String zikirToJson(Zikir data) => json.encode(data.toJson());

class Zikir {
  int id;
  String text;
  List<String> textArray;
  String transcription;
  String translation;
  String narration;
  String authenticity;
  String reference;
  int count;
  List<int> types;
  List<String> timeRange;
  bool isFavorited;
  bool isInVird;

  Zikir({
    this.id,
    this.text,
    this.textArray,
    this.transcription,
    this.translation,
    this.narration,
    this.authenticity,
    this.reference,
    this.count,
    this.types,
    this.timeRange,
    this.isFavorited = false,
    this.isInVird = false,
  });

  Zikir copyWith({
    String id,
    String text,
    String textArray,
    String translation,
    String transcription,
    String narration,
    String authenticity,
    String reference,
    int count,
    List<int> types,
    List<String> timeRange,
    bool isFavorited,
    bool isInVird,
  }) =>
      Zikir(
        id: id ?? this.id,
        text: text ?? this.text,
        textArray: textArray ?? this.textArray,
        transcription: transcription ?? this.transcription,
        translation: translation ?? this.translation,
        narration: narration ?? this.narration,
        authenticity: authenticity ?? this.authenticity,
        reference: reference ?? this.reference,
        count: count ?? this.count,
        types: types ?? this.types,
        timeRange: timeRange ?? this.timeRange,
        isFavorited: isFavorited ?? this.isFavorited,
        isInVird: isInVird ?? this.isInVird,
      );

  factory Zikir.fromJson(Map<String, dynamic> json) => Zikir(
        id: json["id"],
        text: json["text"],
        textArray: json["textArray"] == null
            ? null
            : List<String>.from(json["textArray"].map((x) => x)),
        transcription: json["transcription"],
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
        isFavorited: json["isFavorited"],
        isInVird: json["isInVird"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "textArray": textArray,
        "translation": translation,
        "narration": narration,
        "authenticity": authenticity,
        "reference": reference,
        "count": count,
        "types": List<dynamic>.from(types.map((x) => x)),
        "timeRange": List<dynamic>.from(timeRange.map((x) => x)),
        "isFavorited": isFavorited,
        "isInVird": isInVird,
      };
}
