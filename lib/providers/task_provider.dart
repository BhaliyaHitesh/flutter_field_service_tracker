import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';

final taskProvider =
StateNotifierProvider<TaskNotifier, AsyncValue<List<Task>>>(
      (ref) => TaskNotifier(),
);

class TaskNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  TaskNotifier() : super(const AsyncLoading()) {
    loadTasks();
  }

  final ApiService apiService = ApiService();

  Future<void> loadTasks() async {
    try {
      final tasks = await apiService.fetchTasks();
      state = AsyncData(tasks);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  // void updateStatus(int id, String status) {
  //   state.whenData((tasks) {
  //     final updated = tasks.map((task) {
  //       if (task.id == id) {
  //         return task.copyWith(status: status);
  //       }
  //       return task;
  //     }).toList();
  //
  //     state = AsyncData(updated);
  //   });
  // }


  void updateStatus(int id, String status) {
    final currentTasks = state.asData?.value ?? [];

    final updatedTasks = currentTasks.map((task) {
      if (task.id == id) {
        return task.copyWith(status: status);
      }
      return task;
    }).toList();

    state = AsyncData(updatedTasks);
  }

  void addTask(Task task) {
    final currentTasks = state.asData?.value ?? [];

    state = AsyncData([
      ...currentTasks,
      task,
    ]);
  }

}