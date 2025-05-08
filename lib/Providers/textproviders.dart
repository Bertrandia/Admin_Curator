import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Shared controllers for login & signup
final emailControllerProvider = StateProvider((ref) => TextEditingController());
final passwordControllerProvider = StateProvider(
  (ref) => TextEditingController(),
);

// Separate controller for signup only
final fullNameControllerProvider = StateProvider(
  (ref) => TextEditingController(),
);

final commentController = StateProvider((ref) => TextEditingController());

//controllers for the consultant profile
final phoneNumberController = StateProvider((ref) => TextEditingController());
final email2Controller = StateProvider((ref) => TextEditingController());
final cityController = StateProvider((ref) => TextEditingController());
final firstNameControllerProvider = StateProvider(
  (ref) => TextEditingController(),
);
final lastNameControllerProvider = StateProvider(
  (ref) => TextEditingController(),
);
final dobControllerProvider = StateProvider((ref) => TextEditingController());
final nationalityController = StateProvider((ref) => TextEditingController());
final address1ControllerProvider = StateProvider(
  (ref) => TextEditingController(),
);
final address2ControllerProvider = StateProvider(
  (ref) => TextEditingController(),
);
final stateControllerProvider = StateProvider((ref) => TextEditingController());
final districtControllerProvider = StateProvider(
  (ref) => TextEditingController(),
);
final pincodeControllerProvider = StateProvider(
  (ref) => TextEditingController(),
);
final landlineControllerProvider = StateProvider(
  (ref) => TextEditingController(),
);
final aadharControllerProvider = StateProvider(
  (ref) => TextEditingController(),
);
final panControllerProvider = StateProvider((ref) => TextEditingController());
final doAvailability = StateProvider((ref) => TextEditingController());

final accountHolderName = StateProvider((ref) => TextEditingController());
final bankName = StateProvider((ref) => TextEditingController());
final accountNumber = StateProvider((ref) => TextEditingController());
final branchName = StateProvider((ref) => TextEditingController());
final ifscCode = StateProvider((ref) => TextEditingController());
final aboutUrSelf = StateProvider((ref) => TextEditingController());
final curatorSearchQueryProvider = StateProvider<String>((ref) => '');
