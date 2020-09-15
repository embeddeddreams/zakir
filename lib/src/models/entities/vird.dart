import 'package:zakir/src/models/entities/vird_completion.dart';

class Vird {
  int id;
  int ownerId;
  List<int> zikirIds;
  String name;
  List<VirdCompletion> completed;
  String startDate;
  bool muted;

  Vird({
    this.id,
    this.zikirIds,
    this.name,
    this.completed,
    this.startDate,
    this.muted,
  });

  factory Vird.fromJson(Map<String, dynamic> json) => Vird(
        id: json["id"],
        zikirIds: json["zikirIds"] == null
            ? null
            : List<int>.from(json["zikirIds"].map((x) => x as int)),
        completed: json["completed"] == null
            ? null
            : List<VirdCompletion>.from(
                json["completed"].map((x) => VirdCompletion.fromJson(x))),
        name: json["name"],
        startDate: json["startDate"],
        muted: json["muted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "startDate": startDate,
        "muted": muted,
        "zikirIds": List<dynamic>.from(zikirIds.map((x) => x)),
        "completed": List<dynamic>.from(completed.map((x) => x)),
      };
}
