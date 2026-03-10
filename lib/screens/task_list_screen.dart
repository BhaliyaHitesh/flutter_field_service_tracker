import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import 'task_detail_screen.dart';
import 'add_task_screen.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Tasks"),
      ),

      body: tasksAsync.when(

        /// Loading State
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        /// Error State
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Failed to load tasks"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  ref.read(taskProvider.notifier).loadTasks();
                },
                child: const Text("Retry"),
              )
            ],
          ),
        ),

        /// Data State
        data: (tasks) {

          if (tasks.isEmpty) {
            return const Center(
              child: Text("No tasks available"),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(taskProvider.notifier).loadTasks();
            },
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {

                final task = tasks[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Status: ${task.status}"),
                        Text("Priority: ${task.priority}"),
                        Text(
                          "Due: ${DateFormat('dd MMM yyyy').format(task.dueDate)}",
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TaskDetailScreen(task: task),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTaskScreen(),
            ),
          );
        },
      ),
    );
  }
}