import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _priority = 'Medium';
  DateTime? _dueDate;

  void _saveTask() {
    if (_titleController.text.isEmpty || _dueDate == null) return;
    final task = Task(
      id: const Uuid().v4(),
      title: _titleController.text,
      description: _descController.text,
      dueDate: _dueDate!,
      priority: _priority,
    );
    Provider.of<TaskProvider>(context, listen: false).add(task);
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Description",
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _priority,
              items: [
                'Low',
                'Medium',
                'High',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              decoration: const InputDecoration(
                labelText: "Priority",
                prefixIcon: Icon(Icons.flag),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _priority = val!),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _dueDate == null
                    ? "Pick a due date"
                    : _dueDate!.toLocal().toString().split(' ')[0],
              ),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _saveTask,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                "Save Task",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
