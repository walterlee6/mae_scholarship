import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scholarship_application/repositories/chat_repository.dart';

final chatProvider = Provider(
  (ref) => ChatRepository(),
);

// final authProvider = Provider(
//   (ref) => AuthRepository(),
// );
