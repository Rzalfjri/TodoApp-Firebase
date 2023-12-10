// main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Models/todomodels.dart';
import 'package:flutter_firebase/View/profileview.dart';
import 'package:flutter_firebase/View/task_detail_page.dart';
import 'package:flutter_firebase/Viewmodels/TaskService.dart';

class MainScreen extends StatefulWidget {
  final Function(Todomodels) onTaskSelected;

  const MainScreen({Key? key, required this.onTaskSelected}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const int homeIndex = 0;
  static const int completedIndex = 1;

  late Future data;
  List<Todomodels> data2 = [];

  late TaskService _taskService;
  List<Todomodels> tasks = [];
  List<Todomodels> completedTasks = [];
  List<Todomodels> pendingTasks = [];
  var bottomNavigationBarIndex = homeIndex;

  @override
  void initState() {
    super.initState();
    _taskService = TaskService();
    _loadTasksFromApi();
  }

  Future<void> _loadTasksFromApi() async {
    try {
      List<Todomodels> apiTasks = await _taskService.getTasksFromApi();

      setState(() {
        tasks = apiTasks;
        completedTasks = tasks.where((task) => task.completed).toList();
        pendingTasks = tasks.where((task) => !task.completed).toList();
      });
    } catch (e) {
      print('Error loading tasks from API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO\'S'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              _navigateToProfileView(context);
            },
          ),
        ],
        automaticallyImplyLeading: false, // Menyembunyikan tombol kembali
      ),
      body: _buildTaskList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        key: Key('fabKey'),
        onPressed: _showAddTodoDialog,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.deepPurple,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.list),
              color: bottomNavigationBarIndex == homeIndex
                  ? Colors.white
                  : Colors.grey,
              onPressed: () {
                _updateIndex(homeIndex);
              },
            ),
            IconButton(
              icon: Icon(Icons.check),
              color: bottomNavigationBarIndex == completedIndex
                  ? Colors.white
                  : Colors.grey,
              onPressed: () {
                _updateIndex(completedIndex);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    List<Todomodels> displayedTasks = bottomNavigationBarIndex == completedIndex
        ? completedTasks
        : pendingTasks;

    return displayedTasks.isEmpty
        ? _buildNoTasksWidget()
        : ListView.builder(
            itemCount: displayedTasks.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(displayedTasks[index].judul_tugas),
                  subtitle: Text(displayedTasks[index].deadline),
                  onTap: () {
                    _navigateToDetailPage(displayedTasks[index]);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: displayedTasks[index].completed,
                        onChanged: (value) {
                          _handleTaskCompleted(
                              displayedTasks[index], value ?? false);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _handleDismissed(index);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildNoTasksWidget() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Hero(
                tag: 'Clipboard',
                child: Image.asset('assets/images/Clipboard-empty.png'),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Text(
                    'No tasks',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'YOUR TASK IS NOT FINISHED YET.',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      fontFamily: 'opensans',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            )
          ],
        ),
      ),
    );
  }

  void _showAddTodoDialog() async {
    var judulController = TextEditingController();
    var detailController = TextEditingController();
    var deadlineController = TextEditingController();
    var kategoriController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ADD TODO\'S'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: judulController,
                  decoration: InputDecoration(labelText: 'Judul'),
                ),
                TextField(
                  controller: detailController,
                  decoration: InputDecoration(labelText: 'Detail Tugas'),
                ),
                TextField(
                  controller: deadlineController,
                  decoration: InputDecoration(labelText: 'Deadline'),
                ),
                TextField(
                  controller: kategoriController,
                  decoration: InputDecoration(labelText: 'Kategori'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Tambah'),
              onPressed: () {
                _handleAddTodo(
                  judulController.text,
                  detailController.text,
                  deadlineController.text,
                  kategoriController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleAddTodo(
    String judul,
    String detail,
    String deadline,
    String kategori,
  ) async {
    Todomodels newTask = Todomodels(
      judul_tugas: judul,
      detail_tugas: detail,
      deadline: deadline,
      kategori: kategori,
      completed: false, // Set status tugas baru sebagai belum selesai
    );

    await _taskService.addTask(newTask);

    // Tambahkan tugas baru ke daftar yang sesuai terlepas dari statusnya
    tasks.add(newTask);

    // Update daftar tugas yang sesuai
    completedTasks = tasks.where((task) => task.completed).toList();
    pendingTasks = tasks.where((task) => !task.completed).toList();

    _loadTasksFromApi();
  }

  void _handleDismissed(int index) async {
    try {
      if (index >= 0 && index < tasks.length) {
        await _taskService.deleteTask(tasks[index].judul_tugas);

        // Hapus tugas dari daftar lokal
        Todomodels removedTask = tasks.removeAt(index);

        // Hapus tugas dari daftar yang sesuai
        if (removedTask.completed) {
          completedTasks.remove(removedTask);
        } else {
          pendingTasks.remove(removedTask);
        }

        setState(() {
          // setelah menghapus tugas, panggil setState untuk membangun ulang UI
        });
      } else {
        print('Invalid index: $index');
      }
    } catch (e) {
      print('Error deleting task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting task'),
        ),
      );
    }
  }

  void _navigateToDetailPage(Todomodels task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailPage(task: task),
      ),
    );
  }

// Bagian navigasi

  void _navigateToProfileView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileView(),
      ),
    );
  }

  void _handleTaskCompleted(Todomodels task, bool completed) async {
    task.completed = completed;

    try {
      await _taskService.updateTask(task);

      // Hapus tugas dari daftar yang sesuai
      if (completed) {
        pendingTasks.remove(task);
        completedTasks.add(task);
        _updateIndex(completedIndex); // Pindah ke tab selesai
      } else {
        completedTasks.remove(task);
        pendingTasks.add(task);
        _updateIndex(homeIndex); // Pindah ke tab beranda
      }

      setState(() {});
    } catch (e) {
      print('Error updating task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating task'),
        ),
      );
    }
  }

  void _updateIndex(int index) {
    setState(() {
      bottomNavigationBarIndex = index;
    });
  }
}
