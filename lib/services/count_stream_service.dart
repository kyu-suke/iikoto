import 'dart:async';

class CountStreamService {
  final _calcController = StreamController<int>();
  final _outputController = StreamController<String>();
  final _stopController = StreamController<void>();

  Function(int) get add => _calcController.sink.add;

  Stream<String> get onAdd => _outputController.stream;

  Stream<void> get onStop => _stopController.stream;

  static CountStreamService _instance;

  factory CountStreamService() {
    if (_instance == null) {
      _instance = new CountStreamService._();
      _instance._calcController.stream.listen((count) {
        _instance._outputController.sink.add('$count');
      });
    }

    return _instance;
  }

  CountStreamService._();
}
