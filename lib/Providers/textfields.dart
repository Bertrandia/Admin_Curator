import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailControllerProvider = StateProvider((ref) => TextEditingController(),);
final passwordControllerProvider = StateProvider(
  (ref) => TextEditingController(),
);
