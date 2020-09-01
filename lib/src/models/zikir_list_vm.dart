class ZikirListVM {
  String text;
  List<String> textArray;
  String tag;
  String description;

  ZikirListVM({
    this.text,
    this.textArray,
    this.tag,
    this.description,
  });

  ZikirListVM copyWith({
    String text,
    String textArray,
    String tag,
    String description,
  }) =>
      ZikirListVM(
        text: text ?? this.text,
        textArray: textArray ?? this.textArray,
        tag: tag ?? this.tag,
        description: description ?? this.description,
      );

  factory ZikirListVM.fromJson(Map<String, dynamic> json) => ZikirListVM(
        text: json["text"],
        textArray: json["textArray"] == null
            ? null
            : List<String>.from(json["textArray"].map((x) => x)),
        tag: json["tag"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "textArray": textArray,
        "tag": tag,
        "description": description,
      };
}
