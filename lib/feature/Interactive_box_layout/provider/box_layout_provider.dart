import 'package:flutter/material.dart';

class BoxLayoutProvider with ChangeNotifier {
  int? _userInput;
  int? get userInput => _userInput;

  List<bool> _boxStates = [];
  List<bool> get boxStates => _boxStates;

  final List<int> _tappedItemOrder = [];
  List<int> get tappedItemOrder => _tappedItemOrder;

  bool _isReversing = false;
  bool get isReversing => _isReversing;

  void initializeContainerDetails(int n) {
    _userInput = n;
    _boxStates = List.generate(n, (_) => false);
    _tappedItemOrder.clear();
    _isReversing = false;

    notifyListeners();
  }

  void updateContainerTap(int index) {
    if (_isReversing) return;
    if (!_boxStates[index]) {
      _boxStates[index] = true;
      _tappedItemOrder.add(index);
      notifyListeners();

      if (_tappedItemOrder.length == _userInput) {
        _startReverseAnimation();
      }
    }
  }

  void _startReverseAnimation() async {
    _isReversing = true;
    notifyListeners();

    for (int i = _tappedItemOrder.length - 1; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));

      _boxStates[_tappedItemOrder[i]] = false;
      notifyListeners();
    }

    _tappedItemOrder.clear();
    _isReversing = false;
    notifyListeners();
  }

  (int, int, int) generateBoxCounts() {
    final int n = _userInput!;
    int topContainerCount = ((n * 2) / 5).round();
    int bottomCounterCount = topContainerCount;
    int middleContainerCount = n - topContainerCount - bottomCounterCount;

    return (topContainerCount, middleContainerCount, bottomCounterCount);
  }
}
