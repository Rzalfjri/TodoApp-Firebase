import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/Models/todomodels.dart';
import 'package:flutter_firebase/Viewmodels/fecthDataPlaces.dart';

class TaskService {
  final DatabaseReference _database =
      FirebaseDatabase.instance.reference().child('TODOAPP');
  final Repository _repository = Repository();

  Future<String> addTask(Todomodels task) async {
    try {
      var taskRef = _database.child(task.judul_tugas);

      await taskRef.set({
        'judul_tugas': task.judul_tugas,
        'detail_tugas': task.detail_tugas,
        'deadline': task.deadline,
        'kategori': task.kategori,
        'completed': task.completed,
      });

      return task.judul_tugas;
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  Future<List<Todomodels>> getTasks() async {
    DataSnapshot snapshot = (await _database.once()) as DataSnapshot;
    List<Todomodels> tasks = [];

    if (snapshot.value != null && snapshot.value is Map) {
      Map<dynamic, dynamic> taskMap = snapshot.value as Map<dynamic, dynamic>;
      taskMap.forEach((key, value) {
        Todomodels task = Todomodels(
          judul_tugas: value['judul_tugas'],
          detail_tugas: value['detail_tugas'],
          deadline: value['deadline'],
          kategori: value['kategori'],
          completed: value['completed'],
        );
        tasks.add(task);
      });
    }

    return tasks;
  }

  Future<List<Todomodels>> getTasksFromApi() async {
    try {
      List<Todomodels> apiTasks = await _repository.fetchDataPlaces();
      return apiTasks;
    } catch (e) {
      print('Error loading tasks from API: $e');
      throw Exception('Failed to load tasks from API');
    }
  }

  Future<void> updateTask(Todomodels task) async {
    try {
      var taskRef = _database.child(task.judul_tugas);

      await taskRef.update({
        'detail_tugas': task.detail_tugas,
        'deadline': task.deadline,
        'kategori': task.kategori,
        'completed': task.completed,
      });
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String judulTugas) async {
    try {
      await _database.child(judulTugas).remove();
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }
}
