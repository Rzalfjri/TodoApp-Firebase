import 'dart:convert';
import 'package:flutter_firebase/Models/todomodels.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Repository {
  // Update the apiUrl with your new database URL
  final String apiUrl =
      'https://todoapp-c08eb-default-rtdb.firebaseio.com/TODOAPP.json';

  Future<List<Todomodels>> fetchDataPlaces() async {
    Response response = await http.get(Uri.parse(apiUrl));
    List<Todomodels> dataPlaces = [];

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      // Iterasi melalui entri database
      jsonData.forEach((key, value) {
        // Pastikan setiap entri memiliki properti yang diharapkan
        if (value is Map<String, dynamic> &&
            value.containsKey('judul_tugas') &&
            value.containsKey('detail_tugas') &&
            value.containsKey('deadline') &&
            value.containsKey('kategori') &&
            value.containsKey('completed')) {
          // Tambahkan data ke daftar
          Todomodels task = Todomodels.fromJson(value);
          dataPlaces.add(task);
        }
      });

      return dataPlaces;
    } else {
      throw Exception('Failed to load data places');
    }
  }
}
