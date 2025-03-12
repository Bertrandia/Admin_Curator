import 'package:admin_curator/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:intl/intl.dart';

import '../../../Core/Notifiers/user_task_notifier.dart';

class AssignPriceBottomSheet extends StatelessWidget {
  final String taskId;
  AssignPriceBottomSheet({required this.taskId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DraggableScrollableSheet(
        builder: (context, scrollController) {
          return _buildAdminControls();
        },
      ),
    );
  }

  Widget _buildAdminControls() {
    final NumberFormat currencyFormat = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
      locale: 'hi_IN',
    );

    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
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
              // Text(
              //   'Task Completion Hours: ${_taskHours.toStringAsFixed(1)} hours',
              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              // ),
              Slider(
                value: 0.5,
                min: 0.5,
                max: 8.0,
                divisions: 15, // 0.5 interval from 0.5 to 10
                activeColor: Colors.deepOrange,
                inactiveColor: Colors.deepOrange.shade100,
                label: '${2.toStringAsFixed(1)} hours',
                onChanged: (value) {},
              ),

              SizedBox(height: 16),

              // Payment Slider
              Text(
                'Task Payment: ${currencyFormat.format(0)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Slider(
                value: 100,
                min: 100.0,
                max: 4000,
                divisions: 39, // 100 rs interval from 100 to 5000
                activeColor: Colors.deepOrange,
                inactiveColor: Colors.deepOrange.shade100,
                label: currencyFormat.format(0),
                onChanged: (value) {},
              ),

              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // await notifier
                      //     .taskPriceAndTime(
                      //   taskDurationByAdmin: _taskHours,
                      //   taskPriceByAdmin: _taskAmount,
                      //   taskId: widget.taskId,
                      // )
                      //     .then((val) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text(
                      //         'Task Amount and Time has been updated',
                      //       ),
                      //     ),
                      //   );
                      //   context.go('/dashboard');
                      // });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
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
        ),
      ),
    );
  }
}
