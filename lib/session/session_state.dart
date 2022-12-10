import 'package:flutter/foundation.dart';

import 'package:induna/models/User.dart';

abstract class SessionState {}

class UnknownSessionState extends SessionState {}

class Unauthenticated extends SessionState {}

class Authenticated extends SessionState {
  final User user;
  User? selectedUser;

  Authenticated({required this.user});
}