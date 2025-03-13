import '../../Models/patron_model.dart';

class PatronState {
  final bool isLoading;
  final PatronModel? patron;
  final String? errorMessage;

  PatronState({required this.isLoading, this.patron, this.errorMessage});

  // Initial State
  factory PatronState.initial() => PatronState(isLoading: false);

  // Loading State
  PatronState copyWith({
    bool? isLoading,
    PatronModel? patron,
    String? errorMessage,
  }) {
    return PatronState(
      isLoading: isLoading ?? this.isLoading,
      patron: patron ?? this.patron,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
