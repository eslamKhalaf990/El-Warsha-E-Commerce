import 'package:flutter/foundation.dart';

enum MockRepoState { normal, loading, empty, error }

class MockDebugController extends ChangeNotifier {
  static final MockDebugController instance = MockDebugController._();
  MockDebugController._();

  MockRepoState _state = MockRepoState.normal;
  MockRepoState get state => _state;

  void setState(MockRepoState newState) {
    _state = newState;
    notifyListeners();
  }

  void reset() {
    _state = MockRepoState.normal;
    notifyListeners();
  }
}
