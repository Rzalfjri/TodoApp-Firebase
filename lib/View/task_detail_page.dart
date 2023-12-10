// task_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Models/todomodels.dart';
import 'package:flutter_firebase/Viewmodels/TaskService.dart';

class TaskDetailPage extends StatefulWidget {
  final Todomodels task;

  TaskDetailPage({required this.task});

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TextEditingController _detailController;
  late TextEditingController _deadlineController;
  late TextEditingController _kategoriController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai dari tugas yang ada
    _detailController = TextEditingController(text: widget.task.detail_tugas);
    _deadlineController = TextEditingController(text: widget.task.deadline);
    _kategoriController = TextEditingController(text: widget.task.kategori);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Task Detail'),
        foregroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showEditDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.deepPurpleAccent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTaskDetail(
                    widget.task.judul_tugas,
                    isBold: true,
                    fontSize: 25,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTaskDetail(
                        'DEADLINE: ${_deadlineController.text}',
                        isBold: true,
                        fontSize: 11,
                      ),
                      SizedBox(width: 14),
                      _buildTaskDetail(
                        'CATEGORY:  ${_kategoriController.text}',
                        isBold: true,
                        fontSize: 11,
                      ),
                    ],
                  ),
                  _buildTaskDetail(
                    _detailController.text,
                    isBold: false,
                    fontSize: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskDetail(String value,
      {bool isBold = false, double fontSize = 14.0, TextAlign? textAlign}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        value,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: fontSize,
          color: Colors.black,
        ),
        textAlign: textAlign,
      ),
    );
  }

  void _showEditDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildTextField('Detail Tugas', _detailController),
                _buildTextField('Deadline', _deadlineController),
                _buildTextField('Kategori', _kategoriController),
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
              child: Text('Simpan'),
              onPressed: () {
                _handleSaveChanges();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  void _handleSaveChanges() async {
    // Simpan perubahan ke dalam objek tugas
    widget.task.detail_tugas = _detailController.text;
    widget.task.deadline = _deadlineController.text;
    widget.task.kategori = _kategoriController.text;

    // Lakukan penyimpanan ke API
    try {
      await TaskService().updateTask(widget.task);
      print('Perubahan berhasil disimpan ke API');
    } catch (error) {
      print('Gagal menyimpan perubahan ke API: $error');
      // Tambahkan logika atau tindakan jika penyimpanan gagal
    }

    // Perbarui tampilan
    setState(() {});
  }
}
