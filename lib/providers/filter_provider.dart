import 'package:flutter_riverpod/flutter_riverpod.dart';

final statusFilterProvider = StateProvider<String>((ref) {
  return "All";
});