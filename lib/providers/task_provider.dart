import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';

final taskProvider =
StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
    loadTasks();
  }

  final api = ApiService();

  Future<void> loadTasks() async {
    try {
      final tasks = await api.fetchTasks();
      state = tasks;
    } catch (e) {
      state = [];
    }
  }

  void addTask(Task task) {
    state = [...state, task];
  }

  void updateStatus(int id, String status) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(status: status) else task
    ];
  }
}