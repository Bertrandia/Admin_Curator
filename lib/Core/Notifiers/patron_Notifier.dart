import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../States/patron_state.dart';
import '../services/patron_service.dart';

class PatronNotifier extends StateNotifier<PatronState> {
  final PatronService _patronService;

  PatronNotifier(this._patronService) : super(PatronState.initial());

  Future<void> fetchPatron(DocumentReference patronId) async {
    try {
      state = state.copyWith(isLoading: true);
      final patron = await _patronService.getPatronModel(patronId);
      state = state.copyWith(isLoading: false, patron: patron);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

// Provider for PatronNotifier
