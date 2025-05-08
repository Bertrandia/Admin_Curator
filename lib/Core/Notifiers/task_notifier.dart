import 'dart:convert';

import 'package:admin_curator/Models/comment.dart';
import 'package:admin_curator/Models/model_tasks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../Services/task_service.dart';
import '../States/curator_task_state.dart';
import 'dart:developer' as developer;
import 'package:download/download.dart';

class TasksNotifier extends StateNotifier<TaskState> {
  final TasksService _tasksService;

  TasksNotifier(this._tasksService)
    : super(TaskState(isLoading: true, listOfTasks: [])) {
    fetchTasks();
  }

  void fetchTasks() async {
    _tasksService.getTasksWithCuratorsStream().listen((tasks) {
      state = state.copyWith(isLoading: false, tasks: tasks);
    });
  }

  void getPaymentPendingTasks() async {
    state = state.copyWith(isLoading: true);

    _tasksService.getPaymentPendingTasks().listen((tasks) {
      state = state.copyWith(isLoading: false, listOfCompletedTasks: tasks);
    });
  }

  Future<bool> addCommentToTask({
    required String taskId,
    required Comment comment,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      await _tasksService.addCommentToTask(comment: comment, taskId: taskId);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to Accept: $e',
      );
      return false;
    }
  }

  Future<void> downloadTasksCSV() async {
    try {
      List<TaskModel> tasksRecord = state.listOfTasks;

      // String fileContent =
      //     "Patron Name,Assigned LM,Created At,AI Category,AI SubCategory,AI TAG,Category,SubCategory,Category Tag,Assign Date,Assign Date Time,Due Date,Due Date Time,Description,Status Category,Last Comment,Subject,Billing Model,Co Owner,In Process Date,On-Hold Date,Completed Date,Cancelled Date,Priority,Task Open Days,Days Remaining,Delayed,Task ID, Created By,ExtraOrdinary Score,Insights and Approach of Execution,Proactiveness Score,Values Score,Timeliness Score, LM Perception";

      String fileContent =
          "Task ID,Task Category,Task Sub Category,Category Tag,Task Subject,Task Description,Remarks,Priority,Task Status Category,"
          "Task Assign Date,Task Due Date,Task Start Time,Task End Time,Task Received Time,Task Date,"
          "Assigned LM Name,Created By,Created At,Is Cockpit Task Created,Is Delayed,Is Task Disabled,"
          "Patron Name,Patron Address,"
          "Selected Home Curator Department,Curator Task Status,Assigned Time Slot,"
          "Task Owner,Billing Model,Reference Image,"
          "Task Price By Admin,Task Duration By Admin,Task Start Time By Curator,Task End Time By Curator,"
          "List Of Images Uploaded By Curator,List Of Videos Uploaded By Curator,Location Mode,Is Admin Approved";

      String formatCsvField(dynamic field) {
        if (field == null) return '""';

        if (field is Timestamp) {
          field = field.toDate(); // Convert Firestore Timestamp to DateTime
        }

        String stringField = field.toString();

        if (field is DateTime) {
          stringField = DateFormat('dd/MM/yyyy').format(field);
        }
        return '"${stringField.replaceAll('"', '""')}"';
      }

      String formatCsvFieldForDelay(bool? isDelayed) {
        if (isDelayed == null || !isDelayed) {
          return '';
        }
        return 'Delayed';
      }

      String formatCsvFieldWithTime(dynamic date) {
        if (date == null) return '';

        if (date is Timestamp) {
          // Convert Firestore Timestamp to DateTime
          date = (date).toDate();
        }
        // return DateFormat('hh:mm a').format(date);
        if (date is DateTime) {
          return DateFormat('hh:mm a').format(date);
        }
        return '';
      }

      for (var record in tasksRecord) {
        fileContent +=
            "\n" +
            formatCsvField(record.taskID) +
            "," +
            formatCsvField(record.taskCategory) +
            "," +
            formatCsvField(record.taskSubCategory) +
            "," +
            formatCsvField(record.categoryTag) +
            "," +
            formatCsvField(record.taskSubject) +
            "," +
            formatCsvField(record.taskDescription) +
            "," +
            formatCsvField(record.remarks) +
            "," +
            formatCsvField(record.priority) +
            "," +
            formatCsvField(record.taskStatusCategory) +
            "," +
            formatCsvField(record.taskAssignDate) +
            "," +
            formatCsvField(record.taskDueDate) +
            "," +
            formatCsvFieldWithTime(record.taskStartTime) +
            "," +
            formatCsvFieldWithTime(record.taskEndTime) +
            "," +
            formatCsvField(record.taskRecievedTime) +
            "," +
            formatCsvField(record.taskDate) +
            "," +
            formatCsvField(record.assignedLMName) +
            "," +
            formatCsvField(record.createdBy) +
            "," +
            formatCsvField(record.createdAt) +
            "," +
            formatCsvFieldForDelay(record.isCockpitTaskCreated) +
            "," +
            formatCsvFieldForDelay(record.isDelayed) +
            "," +
            formatCsvFieldForDelay(record.isTaskDisabled) +
            "," +
            formatCsvField(record.patronName) +
            "," +
            formatCsvField(record.patronAddress) +
            "," +
            formatCsvField(record.selectedHomeCuratorDepartment) +
            "," +
            formatCsvField(record.curatorTaskStatus) +
            // "," +
            // formatCsvField(record.taskAssignedToCurator) +
            "," +
            formatCsvField(record.assignedTimeSlot) +
            "," +
            formatCsvField(record.taskOwner) +
            "," +
            formatCsvField(record.billingModel) +
            "," +
            formatCsvField(record.refImage) +
            "," +
            formatCsvField(record.taskPriceByAdmin) +
            "," +
            formatCsvField(record.taskDurationByAdmin) +
            "," +
            formatCsvFieldWithTime(record.taskStartTimeByCurator) +
            "," +
            formatCsvFieldWithTime(record.taskEndTimeByCurator) +
            "," +
            formatCsvField(record.listOfImagesUploadedByCurator.join(';')) +
            "," +
            formatCsvField(record.listOfVideosUploadedByCurator.join(';')) +
            "," +
            formatCsvField(record.locationMode) +
            "," +
            formatCsvField(record.isAdminApproved);
      }

      final fileName = "Task${DateTime.now().toIso8601String()}.csv";
      var bytes = utf8.encode(fileContent);
      final stream = Stream.fromIterable(bytes);

      await download(stream, fileName);

      developer.log('CSV download completed successfully');
    } catch (e, stackTrace) {
      developer.log('Error in downloadTasksCSV: $e\n$stackTrace');
      rethrow;
    }
  }
}
