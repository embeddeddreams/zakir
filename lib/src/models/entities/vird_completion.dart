class VirdCompletion {
  double completed;
  String date;

  VirdCompletion({
    this.completed,
    this.date,
  });

  factory VirdCompletion.fromJson(Map<String, dynamic> json) => VirdCompletion(
        completed: json["completed"],
        date: json["date"],
      );
}
