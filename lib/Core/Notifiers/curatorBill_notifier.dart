import 'package:admin_curator/Core/Services/curatorBill_service.dart';
import 'package:admin_curator/Core/States/curator_task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CuratorBillNotifier extends StateNotifier<TaskState> {
  final CuratorBillService _curatorBillService;
  // final DocumentReference taskRef;
  CuratorBillNotifier(this._curatorBillService)
    : super(TaskState(isLoading: true, curatorBills: [], listOfTasks: [])) {
      // fetchBills(taskRef: taskRef);
    }


  void fetchBills({required DocumentReference taskRef}) async {
    _curatorBillService.getCuratorBillsByTaskRef(taskRef).listen((bills) {
      state = state.copyWith(isLoading: false, curatorBills: bills);
    });
  }
}
