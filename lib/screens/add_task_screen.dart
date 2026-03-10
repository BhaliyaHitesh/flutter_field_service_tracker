import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String description = "";
  String priority = "Medium";

  DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              /// Title
              TextFormField(
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) =>
                value!.isEmpty ? "Enter title" : null,
                onSaved: (value) => title = value!,
              ),

              const SizedBox(height: 10),

              /// Description
              TextFormField(
                decoration:
                const InputDecoration(labelText: "Description"),
                validator: (value) =>
                value!.isEmpty ? "Enter description" : null,
                onSaved: (value) => description = value!,
              ),

              const SizedBox(height: 10),

              /// Priority
              DropdownButtonFormField(
                value: priority,
                decoration:
                const InputDecoration(labelText: "Priority"),
                items: ["Low", "Medium", "High"]
                    .map(
                      (p) => DropdownMenuItem(
                    value: p,
                    child: Text(p),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    priority = value!;
                  });
                },
              ),

              const SizedBox(height: 15),

              /// Due Date Picker
              ListTile(
                title: Text(
                  dueDate == null
                      ? "Select Due Date"
                      : "Due Date: ${dueDate!.toLocal().toString().split(' ')[0]}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );

                  if (picked != null) {
                    setState(() {
                      dueDate = picked;
                    });
                  }
                },
              ),

              const SizedBox(height: 25),

              /// Save Button
              ElevatedButton(
                child: const Text("Create Task"),
                onPressed: () {

                  if (!_formKey.currentState!.validate()) return;

                  if (dueDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select due date"),
                      ),
                    );
                    return;
                  }

                  _formKey.currentState!.save();

                  ref.read(taskProvider.notifier).addTask(
                    Task(
                      id: DateTime.now().millisecondsSinceEpoch,
                      title: title,
                      description: description,
                      priority: priority,
                      status: "Pending",
                      dueDate: dueDate!,
                    ),
                  );

                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}