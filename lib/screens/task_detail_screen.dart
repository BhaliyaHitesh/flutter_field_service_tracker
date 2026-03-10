import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends ConsumerWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text("Description: ${task.description}"),

            const SizedBox(height: 10),

            Text("Priority: ${task.priority}"),

            const SizedBox(height: 10),

            Text("Status: ${task.status}"),

            const SizedBox(height: 10),

            Text(
              "Due Date: ${DateFormat('dd MMM yyyy').format(task.dueDate)}",
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(taskProvider.notifier)
                        .updateStatus(task.id, "In Progress");

                    Navigator.pop(context);
                  },
                  child: const Text("Mark In Progress"),
                ),

                const SizedBox(width: 12),

                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(taskProvider.notifier)
                        .updateStatus(task.id, "Completed");

                    Navigator.pop(context);
                  },
                  child: const Text("Mark Completed"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}