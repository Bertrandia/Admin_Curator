import 'package:admin_curator/Core/Notifiers/profile_notifier.dart';
import 'package:admin_curator/Presentation/Widgets/global_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;
import '../../Core/Notifiers/user_task_notifier.dart';
import '../../Providers/providers.dart';

class UnassignDialog extends StatefulWidget {
  final String userEmail;
  final String taskID;
  final WidgetRef ref;

  final CuratorTaskNotifier tasksNotifier;

  const UnassignDialog({
    Key? key,
    required this.ref,
    required this.userEmail,
    required this.taskID,
    required this.tasksNotifier,
  }) : super(key: key);

  @override
  _UnassignDialogState createState() => _UnassignDialogState();
}

class _UnassignDialogState extends State<UnassignDialog> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitRejection() async {
    String reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a reason for rejection")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    bool success = await widget.tasksNotifier.removeCurator(
      taskId: widget.taskID,
    );

    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Task updated")));
      final taskModel = await widget.tasksNotifier.getTaskById(
        id: widget.taskID,
      );
      final taskState = widget.ref.watch(taskProvider);
      Navigator.pop(context, taskState.selectedTask);

      // html.window.location.reload();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to update task")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Unassign Task"),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter the reason for unassign:",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              hintText: "Enter reason...",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        // TextButton(
        //   onPressed: () => Navigator.pop(context), // Close dialog
        //   child: const Text("Cancel"),
        // ),
        SizedBox(
          width: 150,
          child: GlobalButton(
            text: "Cancel",
            onPressed: () {
              Navigator.pop(context);
            },
            height: 35,
            isOutlined: true,
          ),
        ),
        SizedBox(
          width: 150,
          child: GlobalButton(
            text: "Submit",
            onPressed: () {
              if (!_isSubmitting) {
                _submitRejection();
              }
            },
            height: 35,
            isOutlined: true,
          ),
        ),
        // ElevatedButton(
        //   onPressed: _isSubmitting ? null : _submitRejection,
        //   child:
        //       _isSubmitting
        //           ? const CircularProgressIndicator(color: Colors.white)
        //           : const Text("Submit"),
        // ),
      ],
    );
  }
}
