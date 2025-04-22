import 'package:admin_curator/Core/Services/curatorBill_service.dart';
import 'package:admin_curator/Core/States/curator_task_state.dart';
import 'package:admin_curator/Models/curatorBill_model.dart';
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

  Future<bool> updateBill({
    required bool isAdminApproved,
    required DocumentReference billId,
    required status,
  }) async {
    try {
      _curatorBillService.updateBill(isAdminApproved, billId, status);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateRejectionBill({
    required bool isAdminApproved,
    required String rejectionReason,
    required DocumentReference billId,
  }) async {
    try {
      _curatorBillService.updateRejectionBill(
        isAdminApproved,
        rejectionReason,
        billId,
      );
      state = state.copyWith(isLoading: false, isTaskBillCreated: false);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateTaskBillStatus({
    required bool isTaskBillCreated,
    required DocumentReference billId,
  }) async {
    try {
      _curatorBillService.updateTaskBillStatus(billId, isTaskBillCreated);
      state = state.copyWith(isLoading: false, isTaskBillCreated: true);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> createCuratorBill({
    required String fileName,
    required String vendorName,
    required String invoiceNumber,
    required String invoiceDescription,
    required String invoiceDate,
    required String soldTo,
    required List<Map<String, dynamic>> items,
    required DocumentReference taskRef,
    required DocumentReference curatorRef,
    required double totalAmount,
    required double taskHours,
    required double taskPrice,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final billModel = await _curatorBillService.createCuratorBill(
        fileName,
        vendorName,
        invoiceNumber,
        invoiceDescription,
        invoiceDate,
        soldTo,
        totalAmount,
        items,
        taskRef,
        curatorRef,
        taskHours,
        taskPrice,
      );
      print('PDF_created');
      state = state.copyWith(isLoading: false, bill: billModel);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> createTaskBill({
    required String fileName,
    required String vendorName,
    required String invoiceNumber,
    required String invoiceDescription,
    required String invoiceDate,
    required String soldTo,
    required List<Map<String, dynamic>> items,
    required DocumentReference taskRef,
    required DocumentReference curatorRef,
    required double totalAmount,
    required double taskHours,
    required double taskPrice,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final billModel = await _curatorBillService.createTaskBill(
        fileName,
        vendorName,
        invoiceNumber,
        invoiceDescription,
        invoiceDate,
        soldTo,
        totalAmount,
        items,
        taskRef,
        curatorRef,
      );

      final taskModel = await _curatorBillService.updateTaskBillStatus(
        taskRef,
        true,
      );

      //
      state = state.copyWith(
        isLoading: false,
        bill: billModel,
        isTaskBillCreated: true,
        selectedTask: taskModel,
      );

      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> getAdditionalBill({required DocumentReference taskRef}) async {
    state = state.copyWith(isLoading: true);
    try {
      final curatorAdditionalBill = await _curatorBillService.getAdditionalBill(
        taskRef: taskRef,
      );
      if (curatorAdditionalBill != null) {
        state = state.copyWith(additionalBill: curatorAdditionalBill);
      } else {
        state = state.copyWith(additionalBill: null);
      }
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> getTaskBill({
    required DocumentReference taskRef,
    required bool isTaskBillCreated,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final taskBill = await _curatorBillService.getTaskBill(
        taskRef: taskRef,
        isTaskBillCreated: isTaskBillCreated,
      );
      if (taskBill != null) {
        state = state.copyWith(taskBill: taskBill);
      } else {
        state = state.copyWith(additionalBill: null);
      }
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }
}
