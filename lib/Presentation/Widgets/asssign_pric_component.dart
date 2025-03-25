import 'package:admin_curator/Presentation/Dashboard/Widgets/custom_SearchableDD.dart';
import 'package:admin_curator/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../Constants/app_colors.dart';

class AssignPriceDialog extends ConsumerStatefulWidget {
  final String taskId;
  final String taskSubject;
  final String taskDescription;
  final String timeSlot;
  final String taskMode;

  final double taskPrice;

  final double taskHours;
  const AssignPriceDialog({
    Key? key,
    required this.taskId,
    required this.taskSubject,
    required this.taskDescription,
    required this.timeSlot,
    required this.taskPrice,
    required this.taskMode,
    required this.taskHours,
  }) : super(key: key);

  @override
  ConsumerState<AssignPriceDialog> createState() => _AssignPriceDialogState();
}

class _AssignPriceDialogState extends ConsumerState<AssignPriceDialog> {
  late double taskHours;
  late double taskPrice;
  late NumberFormat currencyFormat;

  @override
  void initState() {
    super.initState();
    taskHours = widget.taskHours;
    taskPrice = widget.taskPrice;
    currencyFormat = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
      locale: 'hi_IN',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        color: Colors.white70,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Task Details', style: _headerStyle()),
              const SizedBox(height: 12),
              SearchableDropdown(),
              _buildLabel('Subject:', widget.taskSubject),
              _buildLabel('Description:', widget.taskDescription),
              _buildLabel('Time Slot:', widget.timeSlot),
              _buildLabel('Time Mode:', widget.taskMode),
              const SizedBox(height: 20),

              Text(
                'Task Hours: ${taskHours.toStringAsFixed(1)} hours',
                style: _textStyle(),
              ),
              Slider(
                value: taskHours,
                min: 0.0,
                max: 8.0,
                divisions: 16,
                activeColor: AppColors.primary,
                inactiveColor: Colors.deepOrange.shade100,
                label: '${taskHours.toStringAsFixed(1)} hours',
                onChanged: (value) => setState(() => taskHours = value),
              ),
              const SizedBox(height: 12),

              Text(
                'Task Price: ${currencyFormat.format(taskPrice)}',
                style: _textStyle(),
              ),
              Slider(
                value: taskPrice,
                min: 0,
                max: 4000,
                divisions: 40,
                activeColor: AppColors.primary,
                inactiveColor: Colors.deepOrange.shade100,
                label: currencyFormat.format(taskPrice),
                onChanged: (value) => setState(() => taskPrice = value),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: _buttonTextStyle()),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      ref.read(taskHoursProvider.notifier).state = taskHours;
                      ref.read(taskPriceProvider.notifier).state = taskPrice;
                      await ref
                          .read(taskProvider.notifier)
                          .taskPriceAndTime(
                            taskDurationByAdmin: taskHours,
                            taskPriceByAdmin: taskPrice,
                            taskId: widget.taskId,
                            isAdminApproved: true,
                          )
                          .then((val) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Price & Time Updated!"),
                              ),
                            );
                            Navigator.pop(context);
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Save Changes', style: _buttonTextStyle()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _boldStyle()),
          Text(value, style: _textStyle()),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
  TextStyle _boldStyle() => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
  TextStyle _textStyle() =>
      const TextStyle(fontSize: 16, color: AppColors.primary);
  TextStyle _buttonTextStyle() =>
      const TextStyle(fontSize: 16, color: AppColors.primary);
}
