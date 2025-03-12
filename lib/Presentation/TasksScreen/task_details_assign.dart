import 'package:admin_curator/Core/Notifiers/user_task_notifier.dart';
import 'package:admin_curator/Models/model_tasks.dart';
import 'package:admin_curator/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TaskAdminPage extends ConsumerStatefulWidget {
  final String taskId;
  const TaskAdminPage(this.taskId, {super.key});

  @override
  ConsumerState<TaskAdminPage> createState() => _CuratorProfilesState();
}

class _CuratorProfilesState extends ConsumerState<TaskAdminPage> {
  double _taskHours = 2.0; // Default 2 hours
  double _taskAmount = 500.0; // Default 500 Rs

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.watch(taskProvider.notifier).getTaskById(id: widget.taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);
    final notifier = ref.read(taskProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTaskDetails(taskState.selectedTask),
                  Divider(height: 1, thickness: 1),
                  _buildTaskImages(taskState.selectedTask),
                  Divider(height: 1, thickness: 1),
                  _buildAdminControls(notifier),
                  Divider(height: 1, thickness: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDetails(TaskModel? Model) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Model?.taskSubject ?? 'NA',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange.shade800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            Model?.taskDescription ?? 'NA',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          SizedBox(height: 16),
          _buildDetailRow(
            'Assigned Date',
            DateFormat('dd/MM/yy').format(Model!.taskAssignDate.toDate()),
          ),
          _buildDetailRow(
            'Completion Date',
            DateFormat('dd/MM/yy').format(Model.taskEndTime.toDate()) ??
                'Not yet completed',
          ),
          SizedBox(height: 16),
          _buildAssignedBySection(Model),
          SizedBox(height: 16),
          _buildReviewSection(Model),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange.shade700,
          ),
        ),
        Text(value, style: TextStyle(fontSize: 16, color: Colors.black87)),
      ],
    );
  }

  Widget _buildAssignedBySection(TaskModel? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Patron Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange.shade700,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://via.placeholder.com/80'),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model?.patronName ?? 'Bruce Banner',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Pinch Marigold',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewSection(TaskModel? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange.shade700,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '${model?.taskDescription ?? 'NA'}',
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskImages(TaskModel? model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            top: 16.0,
            right: 16.0,
            bottom: 8.0,
          ),
          child: Text(
            'Task Images',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange.shade700,
            ),
          ),
        ),
        Container(
          height: 200, // Reduced height for images
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 250, // Reduced width for images
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage('assets/images/wardrobe.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            7,
            (index) => Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == 3 ? Colors.deepOrange : Colors.grey.shade300,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAdminControls(CuratorTaskNotifier notifier) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
      locale: 'hi_IN',
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pay Scale',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange.shade800,
            ),
          ),
          SizedBox(height: 16),

          // Task Hours Slider
          Text(
            'Task Completion Hours: ${_taskHours.toStringAsFixed(1)} hours',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Slider(
            value: _taskHours,
            min: 0.5,
            max: 8.0,
            divisions: 15, // 0.5 interval from 0.5 to 10
            activeColor: Colors.deepOrange,
            inactiveColor: Colors.deepOrange.shade100,
            label: '${_taskHours.toStringAsFixed(1)} hours',
            onChanged: (value) {
              setState(() {
                _taskHours = value;
              });
            },
          ),

          SizedBox(height: 16),

          // Payment Slider
          Text(
            'Task Payment: ${currencyFormat.format(_taskAmount)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Slider(
            value: _taskAmount,
            min: 100.0,
            max: 4000,
            divisions: 39, // 100 rs interval from 100 to 5000
            activeColor: Colors.deepOrange,
            inactiveColor: Colors.deepOrange.shade100,
            label: currencyFormat.format(_taskAmount),
            onChanged: (value) {
              setState(() {
                _taskAmount = value;
              });
            },
          ),

          SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await notifier
                      .taskPriceAndTime(
                        taskDurationByAdmin: _taskHours,
                        taskPriceByAdmin: _taskAmount,
                        taskId: widget.taskId,
                      )
                      .then((val) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Task Amount and Time has been updated',
                            ),
                          ),
                        );
                        context.go('/dashboard');
                      });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
