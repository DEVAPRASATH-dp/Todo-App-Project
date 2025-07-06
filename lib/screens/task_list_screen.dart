import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/task_provider.dart';
import '../models/task_model.dart';
import '../screens/add_task_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

enum TaskFilter { all, active, completed }

class _TaskListScreenState extends State<TaskListScreen> {
  void _deleteTask(String taskId) {
    if (!mounted) return;
    Provider.of<TaskProvider>(context, listen: false).delete(taskId);
  }

  TaskFilter _filter = TaskFilter.all;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }
  // didChangeDependencies removed to avoid double loading

  void _logout(BuildContext context) async {
    await AuthService().signOut();
    if (!mounted) return;
    // Only use context if still mounted
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final provider = Provider.of<TaskProvider>(context);
    final allTasks = provider.tasks;
    List<Task> tasks;
    switch (_filter) {
      case TaskFilter.active:
        tasks = allTasks.where((t) => !t.isCompleted).toList();
        break;
      case TaskFilter.completed:
        tasks = allTasks.where((t) => t.isCompleted).toList();
        break;
      case TaskFilter.all:
        tasks = allTasks;
        break;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: SafeArea(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
            title: null,
            actions: [
              if (user != null)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.photoURL ?? ''),
                        radius: 18,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.deepPurple),
                      tooltip: 'Edit Name',
                      onPressed: () async {
                        final newName = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(
                              currentName: user.displayName,
                            ),
                          ),
                        );
                        if (!mounted) return;
                        if (newName != null &&
                            newName is String &&
                            newName.isNotEmpty) {
                          setState(() {}); // Refresh UI
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Name updated!')),
                          );
                        }
                      },
                    ),
                    // Improved logout button with confirmation dialog and tooltip
                    Tooltip(
                      message: 'Logout',
                      child: IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () async {
                          final shouldLogout = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                'Are you sure you want to logout?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                          );
                          if (shouldLogout == true) {
                            _logout(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
            ],
            toolbarHeight: 40,
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      backgroundColor: Colors.deepPurple.shade50,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFede7f6),
                  Color(0xFFd1c4e9),
                  Color(0xFFede7f6),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                // Centered interactive unique logo and app name
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!mounted) return;
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Welcome!'),
                            content: const Text(
                              'This is your Todo App. Stay productive!',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple,
                              Colors.purpleAccent,
                              Colors.deepPurple.shade200,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.task_alt,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Todo App',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (user != null && user.displayName != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Hello, ${user.displayName}!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (user != null && user.displayName == null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Hello, ${user.email ?? ''}!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 8),
                // Filter toggle
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: _filter == TaskFilter.all,
                        onSelected: (_) =>
                            setState(() => _filter = TaskFilter.all),
                        selectedColor: Colors.deepPurple,
                        labelStyle: TextStyle(
                          color: _filter == TaskFilter.all
                              ? Colors.white
                              : Colors.deepPurple,
                        ),
                        backgroundColor: Colors.deepPurple.shade50,
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Active'),
                        selected: _filter == TaskFilter.active,
                        onSelected: (_) =>
                            setState(() => _filter = TaskFilter.active),
                        selectedColor: Colors.deepPurple,
                        labelStyle: TextStyle(
                          color: _filter == TaskFilter.active
                              ? Colors.white
                              : Colors.deepPurple,
                        ),
                        backgroundColor: Colors.deepPurple.shade50,
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Completed'),
                        selected: _filter == TaskFilter.completed,
                        onSelected: (_) =>
                            setState(() => _filter = TaskFilter.completed),
                        selectedColor: Colors.deepPurple,
                        labelStyle: TextStyle(
                          color: _filter == TaskFilter.completed
                              ? Colors.white
                              : Colors.deepPurple,
                        ),
                        backgroundColor: Colors.deepPurple.shade50,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: tasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Remove faded Google logo for a clean look
                              const SizedBox(height: 18),
                              const Text(
                                "No tasks yet.\nTap + to add your first task!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(top: 8, bottom: 80),
                          itemCount: tasks.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, index) {
                            final task = tasks[index];
                            Color priorityColor;
                            switch (task.priority) {
                              case 'High':
                                priorityColor = Colors.redAccent;
                                break;
                              case 'Medium':
                                priorityColor = Colors.orangeAccent;
                                break;
                              default:
                                priorityColor = Colors.green;
                            }
                            return Dismissible(
                              key: ValueKey(task.id),
                              direction: !task.isCompleted
                                  ? DismissDirection.startToEnd
                                  : DismissDirection.none,
                              background: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 24),
                                color: Colors.green,
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              confirmDismiss: (_) async {
                                if (!task.isCompleted) {
                                  Provider.of<TaskProvider>(
                                    context,
                                    listen: false,
                                  ).toggle(task);
                                  setState(() {});
                                  return false;
                                }
                                return false;
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                margin: EdgeInsets.zero,
                                child: ListTile(
                                  leading: Checkbox(
                                    value: task.isCompleted,
                                    onChanged: (val) {
                                      Provider.of<TaskProvider>(
                                        context,
                                        listen: false,
                                      ).toggle(task);
                                      setState(() {});
                                    },
                                    activeColor: Colors.deepPurple,
                                  ),
                                  title: Text(
                                    task.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: task.isCompleted
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    task.description.isNotEmpty
                                        ? task.description
                                        : 'No description',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: task.isCompleted
                                          ? Colors.grey
                                          : null,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.flag,
                                        color: priorityColor,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 2),
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 13,
                                        color: Colors.deepPurple,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        task.dueDate.toLocal().toString().split(
                                          ' ',
                                        )[0],
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.deepPurple,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (task.isCompleted) ...[
                                        const SizedBox(width: 8),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                            size: 18,
                                          ),
                                          tooltip: 'Delete Task',
                                          onPressed: () => _deleteTask(task.id),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          if (mounted) {
            Provider.of<TaskProvider>(context, listen: false).loadTasks();
            setState(() {});
          }
        },
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add),
        label: const Text(
          "Add Task",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
