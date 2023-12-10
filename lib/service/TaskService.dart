// import 'dart:html';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_firebase/Models/todomodels.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart%20';

// class TaskService {
//   static final String _baseUrl =
//       'https://todoapp-c08eb-default-rtdb.firebaseio.com/TODOAPP.json';

//   Future getData() async {
//     Uri urlApi = Uri.parse(_baseUrl);

//     final Response = await http.get(urlApi);
//     if (Response.statusCode == 200) {
//       return todomodelsFromJson(Response.body.toString());
//     } else {
//       throw Exception("Failed to load data");
//     }
//   }


// }
