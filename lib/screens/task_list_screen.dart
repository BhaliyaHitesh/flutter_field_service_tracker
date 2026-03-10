import 'package:flutter/material.dart';
import 'package:flutter_field_service_tracker/providers/filter_provider.dart';
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

    /// WATCH FILTER
    final selectedStatus = ref.watch(statusFilterProvider);


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

          final filteredTasks = selectedStatus == "All"
              ? tasks
              : tasks.where((task) => task.status == selectedStatus).toList();


          return Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(12),
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: "Filter by Status",
                    border: OutlineInputBorder(),
                  ),
                  items: ["All", "Pending", "In Progress", "Completed"]
                      .map(
                        (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    ref.read(statusFilterProvider.notifier).state = value!;
                  },
                ),
              ),


              Expanded(child: RefreshIndicator(
                onRefresh: () async {
                  ref.read(taskProvider.notifier).loadTasks();
                },
                child:

          (filteredTasks.isNotEmpty) ?ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {

                    final task = filteredTasks[index];

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
                )
                 :const Center(
                    child: Text("No tasks available"),
                  ),
              )),

            ],
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