import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_item.dart';
import '../helpers/database_helper.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<TaskItem> _tasks = [];
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadTasks();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _saveThemePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _dbHelper.getAllTasks();
      setState(() {
        _tasks = tasks;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading tasks: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    _loadTasks();
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Task Notes Manager',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isDarkMode
                    ? [const Color(0xFF4F46E5), const Color(0xFF6366F1)]
                    : [const Color(0xFF6366F1), const Color(0xFF818CF8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // Welcome message with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isDarkMode
                      ? [const Color(0xFF4F46E5).withOpacity(0.3), const Color(0xFF6366F1).withOpacity(0.2)]
                      : [const Color(0xFF6366F1).withOpacity(0.1), const Color(0xFF818CF8).withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                'My Tasks & Notes',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : const Color(0xFF6366F1),
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            // Theme toggle
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: _isDarkMode ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                value: _isDarkMode,
                onChanged: (value) {
                  _saveThemePreference(value);
                },
                activeThumbColor: const Color(0xFF6366F1),
              ),
            ),
            // Tasks ListView
            Expanded(
              child: _tasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks yet. Tap the + button to add one!',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        final priorityColor = _getPriorityColor(task.priority);
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            leading: Container(
                              width: 4,
                              decoration: BoxDecoration(
                                color: priorityColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? Colors.grey
                                    : null,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: priorityColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      task.priority,
                                      style: TextStyle(
                                        color: priorityColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    task.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: task.isCompleted,
                                  onChanged: (value) async {
                                    final updatedTask = task.copyWith(
                                      isCompleted: value ?? false,
                                    );
                                    await _dbHelper.updateTask(updatedTask);
                                    _loadTasks();
                                  },
                                  activeColor: const Color(0xFF6366F1),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  color: Colors.red[400],
                                  onPressed: () {
                                    _deleteTask(task.id!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTaskScreen(),
              ),
            );
            if (result == true) {
              _loadTasks();
            }
          },
          tooltip: 'Add Task',
          icon: const Icon(Icons.add),
          label: const Text('Add Task'),
        ),
      ),
    );
  }
}

