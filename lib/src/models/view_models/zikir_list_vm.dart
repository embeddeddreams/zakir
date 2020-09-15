class ZikirListVM {
  int id;
  String text;
  List<String> textArray;
  String tag;
  String description;
  List<int> types;

  ZikirListVM(
      {this.id,
      this.text,
      this.textArray,
      this.tag,
      this.description,
      this.types});

  ZikirListVM copyWith({
    int id,
    String text,
    String textArray,
    String tag,
    String description,
  }) =>
      ZikirListVM(
        id: id ?? this.id,
        text: text ?? this.text,
        textArray: textArray ?? this.textArray,
        tag: tag ?? this.tag,
        description: description ?? this.description,
      );

  factory ZikirListVM.fromJson(Map<String, dynamic> json) => ZikirListVM(
        id: json["id"],
        text: json["text"],
        textArray: json["textArray"] == null
            ? null
            : List<String>.from(json["textArray"].map((x) => x)),
        tag: json["tag"],
        description: json["description"],
        types: json["types"] == null
            ? null
            : List<int>.from(json["types"].map((x) => x as int)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "textArray": textArray,
        "tag": tag,
        "description": description,
        "types": List<dynamic>.from(types.map((x) => x)),
      };
}
