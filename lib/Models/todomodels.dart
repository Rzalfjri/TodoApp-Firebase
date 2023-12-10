import 'dart:convert';

Map<String, Todomodels> todomodelsFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, Todomodels>(k, Todomodels.fromJson(v)));

String todomodelsToJson(Map<String, Todomodels> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Todomodels {
  String judul_tugas;
  String detail_tugas;
  String deadline;
  String kategori;
  bool completed;

  Todomodels({
    required this.judul_tugas,
    required this.detail_tugas,
    required this.deadline,
    required this.kategori,
    required this.completed,
  });

  factory Todomodels.fromJson(Map<String, dynamic> json) {
    return Todomodels(
      judul_tugas: json['judul_tugas'] ?? '',
      detail_tugas: json['detail_tugas'] ?? '',
      deadline: json['deadline'] ?? '',
      kategori: json['kategori'] ?? '',
      completed: json['completed'] ?? '', // Ubah string menjadi boolean
    );
  }

  Map<String, dynamic> toJson() => {
        "judul_tugas": judul_tugas,
        "detail_tugas": detail_tugas,
        "deadline": deadline,
        "kategori": kategori,
        "completed": completed,
      };
}
