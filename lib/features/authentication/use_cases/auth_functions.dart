import 'package:uuid/uuid.dart';

class AuthFunctions{
  
  /// Generates a unique user ID.
  static String generateUserId() => const Uuid().v4();

}