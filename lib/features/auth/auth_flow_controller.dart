import 'package:flutter/foundation.dart';

/// Lightweight auth state for the entry flow.
/// Uses ChangeNotifier so UI can react to changes if needed.
/// No persistence — mock only.
class AuthFlowController extends ChangeNotifier {
  String? _username;
  int? _avatarId;
  String? _level;
  bool _isGuest = false;

  String? get username => _username;
  set username(String? value) {
    _username = value;
    notifyListeners();
  }

  int? get avatarId => _avatarId;
  set avatarId(int? value) {
    _avatarId = value;
    notifyListeners();
  }

  String? get level => _level;
  set level(String? value) {
    _level = value;
    notifyListeners();
  }

  bool get isGuest => _isGuest;
  set isGuest(bool value) {
    _isGuest = value;
    notifyListeners();
  }

  void reset() {
    _username = null;
    _avatarId = null;
    _level = null;
    _isGuest = false;
    notifyListeners();
  }
}

/// Global controller for the lightweight auth entry flow.
final authFlowController = AuthFlowController();
